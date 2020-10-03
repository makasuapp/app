import 'package:kitchen/services/date_converter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/day_prep.dart';
import '../models/recipe_step.dart';
import '../services/web_api.dart';
import '../api/prep_update.dart';
import 'package:meta/meta.dart';
import '../service_locator.dart';
import 'scoped_lookup.dart';
import '../services/logger.dart';

const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedDayPrep extends Model {
  List<DayPrep> _prep;
  WebApi api;

  @visibleForTesting
  List<PrepUpdate> unsavedUpdates;
  @visibleForTesting
  int retryCount = 0;
  Map<int, Set<int>> _recipeDependencies = Map();

  static ScopedLookup _scopedLookup = locator<ScopedLookup>();

  ScopedDayPrep(
      {List<DayPrep> prep,
      WebApi api,
      List<PrepUpdate> unsavedUpdates,
      ScopedLookup scopedLookup}) {
    this.unsavedUpdates = unsavedUpdates ?? [];
    this._prep = prep ?? [];
    this.api = api ?? locator<WebApi>();

    if (scopedLookup != null) {
      _scopedLookup = scopedLookup;
    }
  }

  static RecipeStep recipeStepFor(DayPrep prep) {
    final recipeStep = _scopedLookup.getRecipeStep(prep.recipeStepId);
    if (recipeStep != null) {
      return recipeStep;
    } else {
      throw Exception(
          "no recipe step found with id ${prep.recipeStepId} for prep ${prep.id}");
    }
  }

  List<DayPrep> getPrep() {
    return this._prep;
  }

  void clear() {
    this._prep = List<DayPrep>();
    notifyListeners();
  }

  Future<void> addFetched(List<DayPrep> fetchedPrep) async {
    this._prep = _mergePrep(fetchedPrep);
    this._recipeDependencies = mkRecipeDependencyMap();
    this._prep.sort((a, b) => compareForPrepList(a, b));
    notifyListeners();
  }

  @visibleForTesting
  Map<int, Set<int>> mkRecipeDependencyMap() {
    var map = Map<int, Set<int>>();
    this._prep.forEach((p) {
      final recipeStep = recipeStepFor(p);
      final rId = recipeStep.recipeId;
      if (map[rId] == null) {
        map[rId] = Set<int>();
      }

      recipeStep.inputs.forEach((i) {
        if (i.inputableType == "Recipe") {
          map[rId].add(i.inputableId);
        }
      });
    });
    return map;
  }

  @visibleForTesting
  int compareForPrepList(DayPrep a, DayPrep b) {
    final rsA = recipeStepFor(a);
    final rsB = recipeStepFor(b);
    if (rsA.recipeId == rsB.recipeId) {
      //earlier step first
      return rsA.number - rsB.number;
    } else {
      //earlier needed step first
      if (a.minNeededAtSec != b.minNeededAtSec) {
        return a.minNeededAtSec - b.minNeededAtSec;
      } else if (this
          ._recipeDependencies[rsA.recipeId]
          .contains(rsB.recipeId)) {
        //A dependent on B so B comes first
        return 1;
      } else if (this
          ._recipeDependencies[rsB.recipeId]
          .contains(rsA.recipeId)) {
        //B dependent on A so A comes first
        return -1;
      } else {
        return rsA.recipeId - rsB.recipeId;
      }
    }
  }

  //if we want to persist to db, then we'll also want to merge db entries here
  List<DayPrep> _mergePrep(List<DayPrep> newPrep) {
    if (this.unsavedUpdates.length == 0) {
      return newPrep;
    }

    var prepMap = Map<int, DayPrep>();
    newPrep.forEach((p) {
      prepMap[p.id] = p;
    });

    this.unsavedUpdates.forEach((update) {
      final prep = prepMap[update.dayPrepId];
      if (prep.qtyUpdatedAtSec == null ||
          update.timeSec > prep.qtyUpdatedAtSec) {
        prep.madeQty = update.madeQty;
        prep.qtyUpdatedAtSec = update.timeSec;
      }

      prepMap[prep.id] = prep;
    });

    return prepMap.values.toList();
  }

  Future<void> updatePrepQty(DayPrep prep, double qty) async {
    final updatedPrep = DayPrep.clone(prep, qty, DateTime.now());
    final updatedPreps =
        this._prep.map((p) => p.id == prep.id ? updatedPrep : p).toList();

    this._prep = updatedPreps;
    notifyListeners();

    this.unsavedUpdates.add(
        PrepUpdate(prep.id, updatedPrep.madeQty, updatedPrep.qtyUpdatedAtSec));
    await _saveUnsavedQty();
  }

  Future<void> updatePrepQtys(Map<int, double> prepIdsWithQtysToUpdate) async {
    final timeOfUpdate = DateTime.now();

    final updatedPreps = this
        ._prep
        .map((p) => (prepIdsWithQtysToUpdate.containsKey(p.id))
            ? DayPrep.clone(p, prepIdsWithQtysToUpdate[p.id], timeOfUpdate)
            : p)
        .toList();

    this._prep = updatedPreps;
    notifyListeners();
    this.unsavedUpdates.addAll(prepIdsWithQtysToUpdate.entries.map((e) {
          return PrepUpdate(
              e.key, e.value, DateConverter.toServer(timeOfUpdate));
        }).toList());

    await _saveUnsavedQty();
  }

  Future<void> _saveUnsavedQty() async {
    try {
      final savingUpdatesMap = Map<String, PrepUpdate>.fromIterable(
          this.unsavedUpdates,
          key: (u) => u.id(),
          value: (u) => u);
      if (savingUpdatesMap.keys.length > 0) {
        await this.api.postOpDaySavePrepQty(savingUpdatesMap.values.toList());
      }

      this.retryCount = 0;
      this.unsavedUpdates = this
          .unsavedUpdates
          .where((u) => !savingUpdatesMap.containsKey(u.id()))
          .toList();
    } catch (err) {
      Logger.error(err);
      _retryLater();
    }
  }

  Future<void> _retryLater() async {
    final retryCount = this.retryCount + 1;
    this.retryCount = retryCount;

    final waitTime = RETRY_WAIT_SECONDS * retryCount;
    await Future.delayed(Duration(seconds: waitTime));

    if (retryCount <= NUM_RETRIES) {
      _saveUnsavedQty();
    } else {
      Logger.error("hit max retries in scoped_day_prep");
    }
  }
}

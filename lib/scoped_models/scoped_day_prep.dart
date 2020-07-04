import 'package:scoped_model/scoped_model.dart';
import '../models/day_prep.dart';
import '../models/recipe_step.dart';
import '../services/web_api.dart';
import '../models/prep_update.dart';
import 'package:meta/meta.dart';
import '../service_locator.dart';
import 'scoped_order.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedDayPrep extends Model {
  List<DayPrep> prep;
  WebApi api;

  @visibleForTesting
  List<PrepUpdate> unsavedUpdates;
  @visibleForTesting
  int savingAtSec;
  @visibleForTesting
  int retryCount = 0;
  Map<int, Set<int>> _recipeDependencies = Map();

  ScopedDayPrep({ingredients, prep, api, unsavedUpdates}) {
    this.unsavedUpdates = unsavedUpdates ?? [];
    this.prep = prep ?? [];
    this.api = api ?? locator<WebApi>();
  }

  static RecipeStep recipeStepFor(DayPrep prep) {
    final scopedOrder = locator<ScopedOrder>();
    return scopedOrder.recipeStepsMap[prep.recipeStepId];
  }

  Future<void> addFetched(List<DayPrep> fetchedPrep) async {
    this.prep = _mergePrep(fetchedPrep);
    this._recipeDependencies = buildDependencyMap();
    this.prep.sort((a, b) => sortPrepList(a, b));
    notifyListeners();
  }

  @visibleForTesting
  Map<int, Set<int>> buildDependencyMap() {
    var map = Map<int, Set<int>>();
    this.prep.forEach((p) {
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
  int sortPrepList(DayPrep a, DayPrep b) {
    //TODO: also include timing constraints - min/max
    final rsA = recipeStepFor(a);
    final rsB = recipeStepFor(b);
    if (rsA.recipeId == rsB.recipeId) {
      if (rsA.stepType == rsB.stepType) {
        //earlier step first
        return rsA.number - rsB.number;
      } else {
        //prep before cook
        return rsA.stepType.compareTo(rsB.stepType) * -1;
      }
    } else {
      if (this._recipeDependencies[rsA.recipeId].contains(rsB.recipeId)) {
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
}

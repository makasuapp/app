import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import '../models/op_day.dart';
import '../models/day_ingredient.dart';
import '../models/day_prep.dart';
import '../services/web_api.dart';
import '../models/ingredient_update.dart';
import 'package:meta/meta.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

//TODO: might make more sense to separately do scoped ingredients and prep?
class ScopedOpDay extends Model {
  List<DayIngredient> ingredients; 
  List<DayPrep> prep; 
  bool isLoading = false;
  WebApi api;

  @visibleForTesting
  List<IngredientUpdate> unsavedUpdates; 
  @visibleForTesting
  int savingAtSec;
  @visibleForTesting
  int retryCount = 0;
  int _lastUpdateAtSec;
  DateTime _lastLoaded;

  ScopedOpDay({ingredients, prep, api, unsavedUpdates}) {
    this.unsavedUpdates = unsavedUpdates ?? []; 
    this.ingredients = ingredients ?? [];
    this.prep = prep ?? [];
    this.api = api ?? WebApi();
  }

  Future<void> loadOpDay() async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    //TODO: pull to refresh should force this to happen
    if (this._lastLoaded == null ||
      this._lastLoaded.millisecondsSinceEpoch < lastMidnight.millisecondsSinceEpoch
    ) {
      this.isLoading = true;
      notifyListeners();

      final opDay = await _fetchOpDay();
      this.ingredients = _mergeIngredients(opDay.ingredients);
      //TODO: merge between unsaved and loaded, sort by dependencies / timing
      this.prep = opDay.prep;
      this.isLoading = false;
      notifyListeners();

      this._lastLoaded = now;
    }
  }

  void updateIngredientQty(DayIngredient ingredient, double qty, {int bufferMs}) {
    final updatedAt = DateTime.now();
    final updatedIngredient = DayIngredient(
      ingredient.id, ingredient.name, ingredient.expectedQty, hadQty: qty, 
      unit: ingredient.unit, qtyUpdatedAtSec: updatedAt.millisecondsSinceEpoch ~/ 1000
    );

    final updatedIngredients = this.ingredients.map((i) =>
      i.id == ingredient.id ? updatedIngredient : i
    ).toList();

    this.ingredients = updatedIngredients;
    notifyListeners();

    _persistIngredient(updatedIngredient, bufferMs: bufferMs);
  }

  @visibleForTesting
  Future<void> saveUnsavedQty() async {
    if (this.savingAtSec == null) {
      final savingAtSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      this.savingAtSec = savingAtSec;

      try {
        if (this.unsavedUpdates.length > 0) {
          await this.api.postOpDaySaveIngredientsQty(this.unsavedUpdates);
        }

        this.savingAtSec = null;
        this.retryCount = 0;
        this.unsavedUpdates = this.unsavedUpdates.where((u) {
          return u.timeSec > savingAtSec;
        }).toList();
      } catch(err) {
        //TODO: log to sentry?
        this.savingAtSec = null;
        this._retryLater();    
      }
    } else {
      this._retryLater();
    }
  }

  //TODO: should there be a mechanism to end the retries if it's not needed anymore?
  //currently it's okay if it retries unnecessarily, no harm done
  Future<void> _retryLater() async {
    final retryCount = this.retryCount + 1;
    this.retryCount = retryCount;

    final waitTime = RETRY_WAIT_SECONDS * retryCount;
    await Future.delayed(Duration(seconds: waitTime));

    if (retryCount <= NUM_RETRIES) {
      this.saveUnsavedQty();
    } else {
      //TODO: log to sentry?
      print("hit max retries");
    }
  }

  //for now just returns ingredients
  Future<OpDay> _fetchOpDay() async {
    final opDayJson = await this.api.fetchOpDayJson();

    return OpDay.fromJson(json.decode(opDayJson));
  }

  //if we want to persist to db, then we'll also want to merge db entries here
  List<DayIngredient> _mergeIngredients(List<DayIngredient> ingredients) {
    if (this.unsavedUpdates.length == 0) {
      return ingredients;
    }

    var ingredientsMap = Map<int, DayIngredient>();
    ingredients.forEach((i) { 
      ingredientsMap[i.id] = i;
    });

    this.unsavedUpdates.forEach((update) {
      final ingredient = ingredientsMap[update.dayIngredientId];
      if (ingredient.qtyUpdatedAtSec == null || update.timeSec > ingredient.qtyUpdatedAtSec) {
        ingredient.hadQty = update.hadQty;
        ingredient.qtyUpdatedAtSec = update.timeSec;
      }

      ingredientsMap[ingredient.id] = ingredient;
    });

    return ingredientsMap.values.toList();
  }

  void _persistIngredient(DayIngredient ingredient, {int bufferMs}) async {
    this.unsavedUpdates.add(IngredientUpdate(ingredient.id, ingredient.hadQty, ingredient.qtyUpdatedAtSec));
    this._lastUpdateAtSec = ingredient.qtyUpdatedAtSec;

    final buffer = bufferMs ?? SAVE_BUFFER_SECONDS * 1000;
    await Future.delayed(Duration(milliseconds: buffer));

    if (this.unsavedUpdates.length > 0 && this.unsavedUpdates.last.timeSec != this._lastUpdateAtSec) {
      return;
    }

    await this.saveUnsavedQty();
  }
}
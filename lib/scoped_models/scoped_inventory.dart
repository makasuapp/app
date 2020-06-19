import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import '../models/day_ingredient.dart';
import '../services/web_api.dart';
import '../models/ingredient_update.dart';
import 'package:meta/meta.dart';

const SAVE_BUFFER_SECONDS = 15;

class ScopedInventory extends Model {
  List<DayIngredient> ingredients; 
  bool isLoading = false;
  WebApi api;

  @visibleForTesting
  List<IngredientUpdate> unsavedUpdates; 
  @visibleForTesting
  int savingAtSec;
  int _lastUpdateAtSec;

  ScopedInventory({ingredients, api, unsavedUpdates}) {
    this.unsavedUpdates = unsavedUpdates ?? []; 
    this.ingredients = ingredients ?? [];
    this.api = api ?? WebApi();
  }

  Future<void> loadInventory() async {
    this.isLoading = true;
    notifyListeners();

    final ingredients = await _fetchInventory();
    this.ingredients = _mergeIngredients(ingredients);
    this.isLoading = false;
    notifyListeners();
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

  //for now just returns ingredients
  Future<List<DayIngredient>> _fetchInventory() async {
    final ingredientsJson = await this.api.fetchInventoryJson();

    List<DayIngredient> ingredients = new List<DayIngredient>();
    for (var jsonItem in json.decode(ingredientsJson)) {
      ingredients.add(DayIngredient.fromJson(jsonItem));
    }

    return ingredients;
  }

  Future<void> saveQty(List<IngredientUpdate> updates) {
    return this.api.postInventorySaveQty(updates);
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

    if (this.unsavedUpdates.last.timeSec != this._lastUpdateAtSec) {
      return;
    }

    //if saving already, ignore this save? probably better to queue it
    if (this.savingAtSec == null) {
      final savingAtSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      this.savingAtSec = savingAtSec;

      try {
        await saveQty(this.unsavedUpdates);

        //list may have changed after the await
        this.savingAtSec = null;
        this.unsavedUpdates = this.unsavedUpdates.where((u) {
          return u.timeSec > savingAtSec;
        }).toList();
      } catch(err) {
        this.savingAtSec = null;
        //TODO: log to sentry?
      }
    }
  }
}
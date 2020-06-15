import 'package:scoped_model/scoped_model.dart';
import '../models/day_ingredient.dart';

class ScopedInventory extends Model {
  List<DayIngredient> ingredients = [];
  bool isLoading = false;

  Future<void> loadInventory() async {
    this.isLoading = true;
    notifyListeners();

    final ingredients = await DayIngredient.fetchAll();
    this.ingredients = ingredients;
    this.isLoading = false;
    notifyListeners();
  }

  void updateIngredientQty(DayIngredient ingredient, double qty) {
    final updatedIngredients = this.ingredients.map((i) {
      if (i.id == ingredient.id) {
        return DayIngredient(i.id, i.name, i.expectedQty, hadQty: qty, unit: i.unit);
      } else {
        return i;
      }
    }).toList();

    this.ingredients = updatedIngredients;
    notifyListeners();

    //TODO: make api call and save locally
  }
}
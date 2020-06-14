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
}
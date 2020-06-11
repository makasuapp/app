import 'package:scoped_model/scoped_model.dart';
import '../models/ingredient.dart';

class ScopedInventory extends Model {
  List<Ingredient> ingredients = [];
  bool isLoading = false;

  Future<void> loadInventory() async {
    this.isLoading = true;
    notifyListeners();

    final ingredients = await Ingredient.fetchAll();
    this.ingredients = ingredients;
    this.isLoading = false;
    notifyListeners();
  }
}
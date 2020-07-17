import 'package:scoped_model/scoped_model.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';

class ScopedData extends Model {
  Map<int, Recipe> recipesMap = Map();
  Map<int, RecipeStep> recipeStepsMap = Map();
  Map<int, Ingredient> ingredientsMap = Map();

  ScopedData({
    List<Recipe> recipes,
    List<RecipeStep> recipeSteps,
    List<Ingredient> ingredients,
  }) {
    addData(
        recipes: recipes, recipeSteps: recipeSteps, ingredients: ingredients);
  }

  void addData(
      {List<Recipe> recipes,
      List<RecipeStep> recipeSteps,
      List<Ingredient> ingredients}) {
    if (recipes != null) {
      recipes.forEach((recipe) => this.recipesMap[recipe.id] = recipe);
    }
    if (recipeSteps != null) {
      recipeSteps.forEach((step) => this.recipeStepsMap[step.id] = step);
    }
    if (ingredients != null) {
      ingredients.forEach(
          (ingredient) => this.ingredientsMap[ingredient.id] = ingredient);
    }

    notifyListeners();
  }
}

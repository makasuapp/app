import 'package:scoped_model/scoped_model.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';

class ScopedLookup extends Model {
  Map<int, Recipe> _recipesMap = Map();
  Map<int, RecipeStep> _recipeStepsMap = Map();
  Map<int, Ingredient> _ingredientsMap = Map();

  ScopedLookup({
    List<Recipe> recipes,
    List<RecipeStep> recipeSteps,
    List<Ingredient> ingredients,
  }) {
    addData(
        recipes: recipes, recipeSteps: recipeSteps, ingredients: ingredients);
  }

  Recipe getRecipe(int recipeId) {
    return this._recipesMap[recipeId];
  }

  RecipeStep getRecipeStep(int recipeStepId) {
    return this._recipeStepsMap[recipeStepId];
  }

  Ingredient getIngredient(int ingredientId) {
    return this._ingredientsMap[ingredientId];
  }

  void addData(
      {List<Recipe> recipes,
      List<RecipeStep> recipeSteps,
      List<Ingredient> ingredients}) {
    if (recipes != null) {
      recipes.forEach((recipe) => this._recipesMap[recipe.id] = recipe);
    }
    if (recipeSteps != null) {
      recipeSteps.forEach((step) => this._recipeStepsMap[step.id] = step);
    }
    if (ingredients != null) {
      ingredients.forEach(
          (ingredient) => this._ingredientsMap[ingredient.id] = ingredient);
    }

    notifyListeners();
  }
}

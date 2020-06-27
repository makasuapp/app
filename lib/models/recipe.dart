import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../services/web_api.dart';
import './recipe_step.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final int id;
  final String name;
  final bool publish;
  @JsonKey(name: "output_qty", nullable: true)
  final double outputQty;
  @JsonKey(nullable: true)
  final String unit;

  @JsonKey(name: "prep_steps", nullable: true)
  List<RecipeStep> prepSteps;
  @JsonKey(name: "cook_steps", nullable: true)
  List<RecipeStep> cookSteps;

  Recipe(this.id, this.name, this.prepSteps, this.cookSteps, {this.outputQty, this.unit, this.publish = false});

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  static Future<List<Recipe>> fetchAll() async {
    final recipesJson = await WebApi().fetchRecipesJson();
    List<Recipe> recipes = new List<Recipe>();
    for (var jsonItem in json.decode(recipesJson)) {
      recipes.add(Recipe.fromJson(jsonItem));
    }

    return recipes;
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../services/web_api.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  final int id;
  final String name;

  Ingredient(this.id, this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

  static Future<List<Ingredient>> fetchAll() async {
    final ingredientsJson = await WebApi.fetchIngredientsJson();
    List<Ingredient> ingredients = new List<Ingredient>();
    for (var jsonItem in json.decode(ingredientsJson)) {
      ingredients.add(Ingredient.fromJson(jsonItem));
    }

    return ingredients;
  }
}
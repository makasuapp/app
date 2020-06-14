import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../services/web_api.dart';

part 'day_ingredient.g.dart';

@JsonSerializable()
class DayIngredient {
  final int id;
  final String name;
  @JsonKey(name: "expected_qty")
  final double expectedQty;
  @JsonKey(name: "had_qty", nullable: true)
  final double hadQty;
  @JsonKey(name: "unit", nullable: true)
  final String unit;

  DayIngredient(this.id, this.name, this.expectedQty, {this.hadQty, this.unit});

  factory DayIngredient.fromJson(Map<String, dynamic> json) => _$DayIngredientFromJson(json);

  static Future<List<DayIngredient>> fetchAll() async {
    final ingredientsJson = await WebApi.fetchInventoryJson();
    List<DayIngredient> ingredients = new List<DayIngredient>();
    for (var jsonItem in json.decode(ingredientsJson)) {
      ingredients.add(DayIngredient.fromJson(jsonItem));
    }

    return ingredients;
  }

  String expectedQtyWithUnit() {
    final isInteger = this.expectedQty == this.expectedQty.toInt();
    final qty = isInteger ? this.expectedQty.toInt().toString() : this.expectedQty.toStringAsPrecision(2);

    if (this.unit == null) {
      return qty;
    } else {
      return "$qty ${this.unit}";
    }
  }
}
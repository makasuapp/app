import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/models/day_input.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient extends DayInputable {
  final int id;
  final String name;
  @JsonKey(name: "volume_weight_ratio", nullable: true)
  final double volumeWeightRatio;

  Ingredient(this.id, this.name, {this.volumeWeightRatio})
      : super(name, volumeWeightRatio);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

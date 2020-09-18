import 'package:json_annotation/json_annotation.dart';

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
  @JsonKey(name: "volume_weight_ratio", nullable: true)
  final double volumeWeightRatio;

  @JsonKey(name: "step_ids", nullable: true)
  List<int> stepIds = List();

  Recipe(this.id, this.name,
      {List<int> stepIds,
      this.outputQty,
      this.unit,
      this.volumeWeightRatio,
      this.publish = false}) {
    this.stepIds = stepIds ?? [];
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

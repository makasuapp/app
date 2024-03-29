import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/models/day_input.dart';
import 'package:kitchen/services/unit_converter.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe extends DayInputable {
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
      this.publish = false})
      : super(name, volumeWeightRatio) {
    this.stepIds = stepIds ?? [];
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  double servingsProduced(double usageQty, String usageUnit) {
    final convertedQty = UnitConverter.convert(usageQty,
        inputUnit: usageUnit,
        outputUnit: this.unit,
        volumeWeightRatio: this.volumeWeightRatio);
    return convertedQty / this.outputQty;
  }
}

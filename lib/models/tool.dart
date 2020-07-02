import 'package:json_annotation/json_annotation.dart';

part 'tool.g.dart';

@JsonSerializable()
class Tool {
  final int id;
  final String name;

  Tool(this.id, this.name);

  factory Tool.fromJson(Map<String, dynamic> json) => _$ToolFromJson(json);
}

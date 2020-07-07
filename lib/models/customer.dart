import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final int id;
  @JsonKey(nullable: true)
  final String email;
  @JsonKey(nullable: true)
  final String name;
  @JsonKey(name: "phone_number", nullable: true)
  final String phoneNumber;

  Customer(this.id, {this.email, this.name, this.phoneNumber});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  String info() {
    var includedInfo = List<String>();
    if (this.name != null) {
      includedInfo.add(this.name);
    } else {
      includedInfo.add(this.id.toString());
    }

    if (this.phoneNumber != null) {
      includedInfo.add("(${this.phoneNumber})");
    } else if (this.email != null) {
      includedInfo.add("(${this.email})");
    }

    return includedInfo.join(" ");
  }
}

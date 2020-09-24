import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/components/list_picker.dart';
import 'package:kitchen/services/unit_converter.dart';

///onPick required
class UnitPicker extends StatelessWidget {
  final String selectedUnit;
  final bool canConvertAllUnits;
  final Function(String input) onPick;

  UnitPicker(this.selectedUnit, {this.canConvertAllUnits = false, this.onPick})
      : assert(onPick != null);

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems;
    if (this.canConvertAllUnits) {
      dropdownItems = weightUnits.keys.toList() + volumeUnits.keys.toList();
    } else if (weightUnits.containsKey(this.selectedUnit)) {
      dropdownItems = weightUnits.keys.toList();
    } else {
      dropdownItems = volumeUnits.keys.toList();
    }

    return ListPicker(this.selectedUnit,
        onPick: this.onPick, list: dropdownItems);
  }
}

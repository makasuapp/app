import 'package:flutter/material.dart';
import 'package:kitchen/services/unit_converter.dart';
import '../adjust_quantity_styles.dart';

///onPick required
class UnitPicker extends StatelessWidget {
  final String selectedUnit;
  final bool canConvertAllUnits;
  final Function(String input) onPick;

  UnitPicker(this.selectedUnit, {this.canConvertAllUnits = false, this.onPick})
      : assert(onPick != null);

  @override
  Widget build(BuildContext context) {
    var dropdownItems;
    if (this.canConvertAllUnits) {
      dropdownItems = weightUnits.keys
              .map((String value) => _renderDropdownItem(value))
              .toList() +
          volumeUnits.keys
              .map((String value) => _renderDropdownItem(value))
              .toList();
    } else if (weightUnits.containsKey(this.selectedUnit)) {
      dropdownItems = weightUnits.keys
          .map((String value) => _renderDropdownItem(value))
          .toList();
    } else {
      dropdownItems = volumeUnits.keys
          .map((String value) => _renderDropdownItem(value))
          .toList();
    }
    return DropdownButton<String>(
      value: this.selectedUnit,
      icon: AdjustQuantityStyles.unitPickerIcon,
      iconSize: AdjustQuantityStyles.unitPickerIconSize,
      style: AdjustQuantityStyles.unitPickerText,
      underline: Container(
        height: AdjustQuantityStyles.unitPickerUnderlineHeight,
        color: AdjustQuantityStyles.unitPickerUnderlineColor,
      ),
      items: dropdownItems,
      onChanged: (input) => this.onPick(input),
    );
  }

  DropdownMenuItem<String> _renderDropdownItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }
}

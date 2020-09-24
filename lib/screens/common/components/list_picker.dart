import 'package:flutter/material.dart';
import '../adjust_quantity_styles.dart';

///list and onPick required
class ListPicker extends StatelessWidget {
  final List<String> list;
  final Function(String input) onPick;
  final String selectedUnit;

  ListPicker(this.selectedUnit, {this.list, this.onPick})
      : assert(onPick != null),
        assert(list != null);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: this.selectedUnit,
      icon: AdjustQuantityStyles.unitPickerIcon,
      iconSize: AdjustQuantityStyles.unitPickerIconSize,
      style: AdjustQuantityStyles.unitPickerText,
      underline: Container(
        height: AdjustQuantityStyles.unitPickerUnderlineHeight,
        color: AdjustQuantityStyles.unitPickerUnderlineColor,
      ),
      items: this.list.map((item) => _renderDropdownItem(item)).toList(),
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

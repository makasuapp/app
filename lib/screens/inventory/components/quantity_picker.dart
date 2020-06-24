import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../inventory_styles.dart';

class QuantityPicker extends StatelessWidget {
  final int maxQty;
  final double qty;
  final Function(double newQty) onPick;

  QuantityPicker(this.qty, this.onPick, {this.maxQty});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Picker picker = _renderQtyPicker(this.qty);
        picker.showDialog(context);
      },
      child: Container(
        padding: InventoryStyles.quantityPickerPadding,
        child: Text(this.qty.toString(), style: InventoryStyles.quantityPickerText)
      )
    );
  }

  Picker _renderQtyPicker(double initialQty) {
    final initWhole = initialQty.toInt();
    final initDecimal = (initialQty % 1 * 10).toInt();
    final maxQty = this.maxQty ?? 99;

    return new Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: maxQty, initValue: initWhole),
        NumberPickerColumn(begin: 0, end: 9, initValue: initDecimal),
      ]),
      delimiter: [
        PickerDelimiter(child: Container(
          width: 30.0,
          alignment: Alignment.center,
          child: Text("."),
        ))
      ],
      hideHeader: true,
      title: new Text("Please Select"),
      onConfirm: (Picker picker, List value) {
        final values = picker.getSelectedValues();
        final whole = values[0] as int;
        final decimal = values[1] as int;
        final newQty = whole + (decimal / 10);

        this.onPick(newQty);
      }
    );
  }
}
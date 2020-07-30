import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';
import 'components/cancel_button.dart';
import 'components/submit_button.dart';
import 'adjust_quantity_styles.dart';

class AdjustQuantityPage extends StatefulWidget {
  final String title;
  final double initQty;
  final String initUnit;
  final bool canConvertAllUnits;
  final void Function(double qty, String unit, BuildContext qtyViewContext)
      onSubmit;

  AdjustQuantityPage(
      {this.title,
      this.canConvertAllUnits = false,
      this.onSubmit,
      this.initQty,
      this.initUnit})
      : assert(onSubmit != null),
        assert(title != null);

  @override
  createState() => _AdjustQuantityPageState();
}

class _AdjustQuantityPageState extends State<AdjustQuantityPage> {
  double _setQty;
  String _setUnit;

  @override
  void initState() {
    super.initState();
    this._setQty = this.widget.initQty ?? 1;
    this._setUnit = this.widget.initUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Adjust Quantity")),
        body: Container(
            padding: Styles.spacerPadding,
            child: Column(children: [
              _renderTitle(),
              _renderPickers(),
              _renderButtons(context)
            ])));
  }

  Widget _renderTitle() {
    return Text(this.widget.title, style: AdjustQuantityStyles.title);
  }

  Widget _renderPickers() {
    final unitInGroups = weightUnits.containsKey(this._setUnit) ||
        volumeUnits.containsKey(this._setUnit);
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        _renderQtyPicker(),
        this._setUnit != null
            ? unitInGroups ? _renderUnitPicker() : Text("${this._setUnit}")
            : Container()
      ],
    );
  }

  Widget _renderQtyPicker() {
    return Container(
        width: 100,
        child: TextField(
          style: AdjustQuantityStyles.qtyPickerText,
          decoration:
              InputDecoration(hintText: this.widget.initQty.toStringAsFixed(2)),
          keyboardType: TextInputType.number,
          onChanged: (input) {
            setState(() {
              this._setQty = double.tryParse(input);
            });
          },
        ));
  }

  DropdownMenuItem<String> _renderDropdownItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }

  Widget _renderUnitPicker() {
    var dropdownItems;
    if (this.widget.canConvertAllUnits) {
      dropdownItems = weightUnits.keys
              .map((String value) => _renderDropdownItem(value))
              .toList() +
          volumeUnits.keys
              .map((String value) => _renderDropdownItem(value))
              .toList();
    } else if (weightUnits.containsKey(this._setUnit)) {
      dropdownItems = weightUnits.keys
          .map((String value) => _renderDropdownItem(value))
          .toList();
    } else {
      dropdownItems = volumeUnits.keys
          .map((String value) => _renderDropdownItem(value))
          .toList();
    }
    return DropdownButton<String>(
      value: this._setUnit,
      icon: AdjustQuantityStyles.unitPickerIcon,
      iconSize: AdjustQuantityStyles.unitPickerIconSize,
      style: AdjustQuantityStyles.unitPickerText,
      underline: Container(
        height: AdjustQuantityStyles.unitPickerUnderlineHeight,
        color: AdjustQuantityStyles.unitPickerUnderlineColor,
      ),
      items: dropdownItems,
      onChanged: (input) {
        setState(() {
          this._setUnit = input;
        });
      },
    );
  }

  Widget _renderButtons(BuildContext context) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CancelButton(() => Navigator.pop(context)),
          SubmitButton(
              () => this.widget.onSubmit(this._setQty, this._setUnit, context))
        ]),
        padding: Styles.spacerPadding);
  }
}

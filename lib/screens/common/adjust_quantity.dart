import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitchen/styles.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'components/cancel_button.dart';
import 'components/submit_button.dart';
import 'components/unit_picker.dart';
import 'adjust_quantity_styles.dart';

///onSubmit and title required
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
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[_renderQtyPicker(), _renderUnitPicker()],
    );
  }

  Widget _renderUnitPicker() {
    if (this._setUnit != null) {
      final unitInGroups = weightUnits.containsKey(this._setUnit) ||
          volumeUnits.containsKey(this._setUnit);
      return unitInGroups
          ? UnitPicker(this._setUnit,
              canConvertAllUnits: this.widget.canConvertAllUnits,
              onPick: (input) => setState(() => this._setUnit = input))
          : Text("${this._setUnit}");
    } else
      return Container();
  }

  Widget _renderQtyPicker() {
    return Container(
        width: 100,
        child: TextField(
          style: AdjustQuantityStyles.qtyPickerText,
          decoration:
              InputDecoration(hintText: this.widget.initQty.toStringAsFixed(2)),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (input) {
            setState(() {
              this._setQty = double.tryParse(input);
            });
          },
        ));
  }

  Widget _renderButtons(BuildContext context) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CancelButton(() => Navigator.pop(context)),
          SubmitButton(() {
            if (this._setQty != null) {
              this.widget.onSubmit(this._setQty, this._setUnit, context);
            } else {
              Navigator.pop(context);
            }
          })
        ]),
        padding: Styles.spacerPadding);
  }
}

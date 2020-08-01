import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/components/unit_picker.dart';
import '../../common/components/cancel_button.dart';
import '../../common/components/submit_button.dart';

///onSubmit and onCancel required
class GotDialog extends StatefulWidget {
  final void Function(double gotQty, String gotUnit, int priceCents,
      String priceUnit, BuildContext dialogContext) onSubmit;
  final void Function(BuildContext dialogContext) onCancel;
  final double initQty;
  final String initUnit;

  GotDialog({this.onSubmit, this.onCancel, this.initQty, this.initUnit})
      : assert(onSubmit != null),
        assert(onCancel != null);

  @override
  createState() => _GotDialogState();
}

class _GotDialogState extends State<GotDialog> {
  double _gotQty;
  String _gotUnit;
  int _priceCents;
  String _priceUnit;

  @override
  void initState() {
    super.initState();
    this._gotQty = this.widget.initQty;
    this._gotUnit = this.widget.initUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("How much did you get and at what price?"),
      content:
          Column(children: <Widget>[_renderQtyFields(), _renderPriceFields()]),
      actions: <Widget>[
        CancelButton(() => this.widget.onCancel(context)),
        SubmitButton(() {
          if (this._gotQty != null) {
            this.widget.onSubmit(this._gotQty, this._gotUnit, this._priceCents,
                this._priceUnit, context);
          } else
            this.widget.onCancel(context);
        })
      ],
    );
  }

  Widget _renderQtyFields() {
    return Wrap(children: <Widget>[
      Text("Got: "),
      _renderInputField(this.widget.initQty.toStringAsFixed(2),
          (input) => setState(() => this._gotQty = double.tryParse(input))),
      //TODO: how deal with non-traditional unit / select no unit?
      UnitPicker(this._gotUnit,
          canConvertAllUnits: true,
          onPick: (unit) => setState(() => this._gotUnit = unit))
    ]);
  }

  Widget _renderPriceFields() {
    return Wrap(
      alignment: WrapAlignment.start,
      children: <Widget>[
        Text("Price: \$"),
        _renderInputField(
            "4.99",
            (input) => setState(() =>
                this._priceCents = (double.tryParse(input) * 100).toInt())),
        Text(" per "),
        _renderInputField(
            "450g", (input) => setState(() => this._priceUnit = input),
            keyboardType: TextInputType.text),
      ],
    );
  }

  Widget _renderInputField(String hintText, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.number}) {
    return Container(
        width: 70,
        child: TextField(
          decoration: InputDecoration(hintText: hintText),
          keyboardType: keyboardType,
          onChanged: (input) => onChanged(input),
        ));
  }
}

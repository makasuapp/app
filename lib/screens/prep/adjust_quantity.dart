import 'package:flutter/material.dart';
import '../op_day/quantity_picker.dart';
import '../common/cancel_button.dart';
import '../common/submit_button.dart';
import '../../models/day_prep.dart';
import './prep_styles.dart';

class PrepAdjustQuantityPage extends StatefulWidget {
  final DayPrep prep;
  final void Function(double qty, BuildContext qtyViewContext) onSubmit;

  PrepAdjustQuantityPage(this.prep, {this.onSubmit}) : assert(onSubmit != null);

  @override
  createState() => _PrepAdjustQuantityPageState();
}

class _PrepAdjustQuantityPageState extends State<PrepAdjustQuantityPage> {
  double _setQty;

  @override
  void initState() {
    super.initState();
    final prep = this.widget.prep;
    if (prep.madeQty != null) {
      this._setQty = prep.madeQty;
    } else {
      this._setQty = prep.expectedQty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Adjust Quantity")),
        body: Container(
            padding: PrepStyles.adjustQuantityTopPadding,
            child:
                //TODO: add description of prep
                Column(children: [_renderPicker(), _renderButtons(context)])));
  }

  Widget _renderPicker() {
    final prep = this.widget.prep;

    //TODO: swap out for number input
    //TODO: picker is for % of total - sets newQty to percentage of expected
    return QuantityPicker(
        this._setQty, (double newQty) => setState(() => this._setQty = newQty),
        maxQty: prep.expectedQty.toInt());
  }

  Widget _renderButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CancelButton(() => Navigator.pop(context)),
      SubmitButton(() => this.widget.onSubmit(this._setQty, context))
    ]);
  }
}

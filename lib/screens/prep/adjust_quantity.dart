import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../common/cancel_button.dart';
import '../common/submit_button.dart';
import '../../models/day_prep.dart';
import './prep_styles.dart';
import '../../service_locator.dart';
import '../../scoped_models/scoped_order.dart';

class PrepAdjustQuantityPage extends StatefulWidget {
  final DayPrep prep;
  final void Function(double qty, BuildContext qtyViewContext) onSubmit;

  PrepAdjustQuantityPage(this.prep, {this.onSubmit}) : assert(onSubmit != null);

  @override
  createState() => _PrepAdjustQuantityPageState();
}

class _PrepAdjustQuantityPageState extends State<PrepAdjustQuantityPage> {
  double _setQty;
  final scopedOrder = locator<ScopedOrder>();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final prep = this.widget.prep;
    if (prep.madeQty != null) {
      this._setQty = prep.madeQty;
    } else {
      this._setQty = prep.expectedQty;
    }
    _controller = TextEditingController(text: "100");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeStep =
        this.scopedOrder.recipeStepsMap[this.widget.prep.recipeStepId];

    return Scaffold(
        appBar: AppBar(title: Text("Adjust Quantity")),
        body: Container(
            padding: PrepStyles.adjustQuantityTopPadding,
            child: Column(children: [
              Text(recipeStep.instruction, style: PrepStyles.listItemText),
              _renderPicker(),
              _renderButtons(context)
            ])));
  }

  Widget _renderPicker() {
    return Container(
        width: 180,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '% of total expected done',
          ),
          onChanged: (input) {
            final percentage = min(double.tryParse(input), 100.0);
            this._setQty = percentage * this.widget.prep.expectedQty;
          },
        ));
  }

  Widget _renderButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CancelButton(() => Navigator.pop(context)),
      SubmitButton(() => this.widget.onSubmit(this._setQty, context))
    ]);
  }
}

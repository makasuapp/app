import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../common/components/cancel_button.dart';
import '../common/components/submit_button.dart';
import '../../models/day_prep.dart';
import 'prep_styles.dart';
import '../../service_locator.dart';
import '../../scoped_models/scoped_lookup.dart';

class AdjustPrepDonePage extends StatefulWidget {
  final DayPrep prep;
  final void Function(double qty, BuildContext qtyViewContext) onSubmit;

  AdjustPrepDonePage(this.prep, {this.onSubmit}) : assert(onSubmit != null);

  @override
  createState() => _AdjustPrepDonePageState();
}

class _AdjustPrepDonePageState extends State<AdjustPrepDonePage> {
  double _setQty;
  final scopedLookup = locator<ScopedLookup>();

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
    final recipeStep =
        this.scopedLookup.getRecipeStep(this.widget.prep.recipeStepId);

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

  //TODO: change this to a dropdown incremented by 10?
  Widget _renderPicker() {
    return Container(
        width: 180,
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: "100",
            labelText: '% of total expected done',
          ),
          onChanged: (input) {
            final percentage = min(double.tryParse(input), 100.0);
            this._setQty = (percentage / 100) * this.widget.prep.expectedQty;
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

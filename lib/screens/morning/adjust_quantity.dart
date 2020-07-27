import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/cancel_button.dart';
import '../common/submit_button.dart';
import '../../models/day_ingredient.dart';
import '../../scoped_models/scoped_day_ingredient.dart';
import './morning_styles.dart';

class IngredientAdjustQtyPage extends StatefulWidget {
  final DayIngredient ingredient;
  final void Function(double qty, BuildContext qtyViewContext) onSubmit;

  IngredientAdjustQtyPage(this.ingredient, {this.onSubmit})
      : assert(onSubmit != null);

  @override
  createState() => _IngredientAdjustQtyPageState();
}

class _IngredientAdjustQtyPageState extends State<IngredientAdjustQtyPage> {
  double _setQty;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final ingredient = this.widget.ingredient;
    if (ingredient.hadQty != null) {
      this._setQty = ingredient.hadQty;
    } else {
      this._setQty = ingredient.expectedQty;
    }

    _controller =
        TextEditingController(text: this._setQty.toStringAsPrecision(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Adjust Qty")),
        body: Container(
            padding: MorningStyles.adjustQuantityTopPadding,
            child: Column(children: [
              Text(
                  ScopedDayIngredient.ingredientFor(this.widget.ingredient)
                      .name,
                  style: MorningStyles.listItemText),
              _renderPickers(),
              _renderButtons(context)
            ])));
  }

  Widget _renderPickers() {
    final ingredient = this.widget.ingredient;
    List<Widget> pickers = List();

    pickers.add(Container(
        width: 100,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (input) {
            this._setQty = double.tryParse(input);
            print(this._setQty);
          },
        )));
    // pickers.add(QuantityPicker(
    //     this._setQty, (double newQty) => setState(() => this._setQty = newQty),
    //     maxQty: ingredient.expectedQty.toInt()));

    if (ingredient.unit != null) {
      //TODO(unit_conversion): convert to picker
      pickers.add(Text(" ${ingredient.unit}",
          style: MorningStyles.adjustQuantityUnitText));
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: pickers);
  }

  Widget _renderButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CancelButton(() => Navigator.pop(context)),
      SubmitButton(() => this.widget.onSubmit(this._setQty, context))
    ]);
  }
}

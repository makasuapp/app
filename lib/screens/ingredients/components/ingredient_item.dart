import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/styles.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:kitchen/services/unit_converter.dart';
import '../../common/components/swipable.dart';
import '../../common/adjust_quantity.dart';
import '../../../models/day_input.dart';
import '../ingredients_styles.dart';
import '../../../scoped_models/scoped_day_input.dart';

class IngredientsItem extends StatelessWidget {
  final DayInput input;
  final Function() refreshList;

  IngredientsItem(this.input, {this.refreshList});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayInput>(
        builder: (context, child, scopedInput) =>
            _renderItem(context, scopedInput));
  }

  Widget _renderItem(BuildContext context, ScopedDayInput scopedInput) {
    final originalQty = this.input.hadQty;

    return Swipable(
        canSwipeLeft: () => Future.value(this.input.hadQty != null),
        canSwipeRight: () => Future.value(this.input.hadQty == null ||
            this.input.hadQty < this.input.expectedQty),
        onSwipeLeft: (context) {
          scopedInput.updateInputQty(this.input, null);
          _notifyQtyUpdate("Ingredient unchecked", context, this.input,
              scopedInput, originalQty);
        },
        onSwipeRight: (context) {
          scopedInput.updateInputQty(this.input, this.input.expectedQty);
          _notifyQtyUpdate("Ingredient checked", context, this.input,
              scopedInput, originalQty);
        },
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: 'adjust_ingredients_qty'),
                      builder: (_) {
                        final inputable =
                            ScopedDayInput.inputableFor(this.input);

                        //TODO: convert up for the init qty/unit
                        return AdjustQuantityPage(
                            title: inputable.name,
                            canConvertAllUnits:
                                inputable.volumeWeightRatio != null,
                            initQty: input.hadQty ?? input.expectedQty,
                            initUnit: input.unit,
                            onSubmit: (double setQty, String newUnit,
                                    BuildContext qtyViewContext) =>
                                _onAdjustQty(input, scopedInput, context,
                                    setQty, newUnit, qtyViewContext));
                      }));
            },
            child: _renderItemText(context)));
  }

  _renderItemText(BuildContext context) {
    return Container(
        color: input.hadQty != null && input.hadQty >= input.expectedQty
            ? IngredientsStyles.checkedItemColor
            : null,
        width: MediaQuery.of(context).size.width,
        padding: IngredientsStyles.listItemPadding,
        child: InputWithQuantity(ScopedDayInput.inputableFor(input).name,
            input.expectedQty, input.inputableType, input.unit,
            adjustedInputQty: input.hadQty,
            adjustedInputUnit: input.unit,
            regularTextStyle: IngredientsStyles.listItemText,
            originalQtyStyle: IngredientsStyles.expectedItemText,
            adjustedQtyStyle: IngredientsStyles.unexpectedItemText));
  }

  void _onAdjustQty(
      DayInput input,
      ScopedDayInput scopedInput,
      BuildContext originalContext,
      double setQty,
      String newUnit,
      BuildContext qtyViewContext) async {
    final originalQty = input.hadQty;
    final newQty = UnitConverter.convert(setQty,
        inputUnit: newUnit, outputUnit: input.unit);

    await scopedInput.updateInputQty(input, newQty);

    Navigator.pop(qtyViewContext);

    //refresh list
    if (input.inputableType == DayInputType.Recipe) {
      this.refreshList();
    } else {
      _notifyQtyUpdate("Ingredient updated", originalContext, input,
          scopedInput, originalQty);
    }
  }

  void _notifyQtyUpdate(String notificationText, BuildContext context,
      DayInput input, ScopedDayInput scopedInput, double originalQty) {
    Flushbar flush;
    flush = Flushbar(
        message: notificationText,
        duration: Duration(seconds: 3),
        isDismissible: true,
        mainButton: InkWell(
            onTap: () {
              scopedInput.updateInputQty(input, originalQty);
              flush.dismiss();
            },
            child: Text("Undo", style: Styles.textHyperlink)))
      ..show(context);
  }
}

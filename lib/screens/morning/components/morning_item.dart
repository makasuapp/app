import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/styles.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/screens/common/components/step_input_item.dart';
import 'package:kitchen/services/unit_converter.dart';
import '../../common/components/swipable.dart';
import '../../common/adjust_quantity.dart';
import '../../../models/day_ingredient.dart';
import '../morning_styles.dart';
import '../../../scoped_models/scoped_day_ingredient.dart';

class MorningItem extends StatelessWidget {
  final DayIngredient ingredient;

  MorningItem(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayIngredient>(
        builder: (context, child, scopedIngredient) =>
            _renderItem(context, scopedIngredient));
  }

  Widget _renderItem(
      BuildContext context, ScopedDayIngredient scopedIngredient) {
    final originalQty = ingredient.hadQty;

    return Swipable(
        canSwipeLeft: () => Future.value(ingredient.hadQty != null),
        canSwipeRight: () => Future.value(ingredient.hadQty == null ||
            ingredient.hadQty < ingredient.expectedQty),
        onSwipeLeft: (context) {
          scopedIngredient.updateIngredientQty(ingredient, null);
          _notifyQtyUpdate("Ingredient unchecked", context, ingredient,
              scopedIngredient, originalQty);
        },
        onSwipeRight: (context) {
          scopedIngredient.updateIngredientQty(
              ingredient, ingredient.expectedQty);
          _notifyQtyUpdate("Ingredient checked", context, ingredient,
              scopedIngredient, originalQty);
        },
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                final baseIngredient =
                    ScopedDayIngredient.ingredientFor(ingredient);

                //TODO: convert up for the init qty/unit
                return AdjustQuantityPage(
                    title: baseIngredient.name,
                    canConvertAllUnits:
                        baseIngredient.volumeWeightRatio != null,
                    initQty: ingredient.hadQty ?? ingredient.expectedQty,
                    initUnit: ingredient.unit,
                    onSubmit: (double setQty, String newUnit,
                            BuildContext qtyViewContext) =>
                        _onAdjustQty(ingredient, scopedIngredient, context,
                            setQty, newUnit, qtyViewContext));
              }));
            },
            child: _renderItemText(context)));
  }

  _renderItemText(BuildContext context) {
    return Container(
        color: ingredient.hadQty != null &&
                ingredient.hadQty >= ingredient.expectedQty
            ? MorningStyles.checkedItemColor
            : null,
        width: MediaQuery.of(context).size.width,
        padding: MorningStyles.listItemPadding,
        child: StepInputItem(ScopedDayIngredient.ingredientFor(ingredient).name,
            ingredient.expectedQty, InputType.Ingredient, ingredient.unit,
            adjustedInputQty: ingredient.hadQty,
            regularTextStyle: MorningStyles.listItemText,
            originalQtyStyle: MorningStyles.expectedItemText,
            adjustedQtyStyle: MorningStyles.unexpectedItemText));
  }

  void _onAdjustQty(
      DayIngredient ingredient,
      ScopedDayIngredient scopedIngredient,
      BuildContext originalContext,
      double setQty,
      String newUnit,
      BuildContext qtyViewContext) {
    final originalQty = ingredient.hadQty;
    final newQty = UnitConverter.convert(setQty,
        inputUnit: newUnit, outputUnit: ingredient.unit);

    scopedIngredient.updateIngredientQty(ingredient, newQty);

    Navigator.pop(qtyViewContext);
    _notifyQtyUpdate("Ingredient updated", originalContext, ingredient,
        scopedIngredient, originalQty);
  }

  void _notifyQtyUpdate(
      String notificationText,
      BuildContext context,
      DayIngredient ingredient,
      ScopedDayIngredient scopedIngredient,
      double originalQty) {
    Flushbar flush;
    flush = Flushbar(
        message: notificationText,
        duration: Duration(seconds: 3),
        isDismissible: true,
        mainButton: InkWell(
            onTap: () {
              scopedIngredient.updateIngredientQty(ingredient, originalQty);
              flush.dismiss();
            },
            child: Text("Undo", style: Styles.textHyperlink)))
      ..show(context);
  }
}

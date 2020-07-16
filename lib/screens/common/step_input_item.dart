import 'dart:core';
import 'package:flutter/material.dart';
import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';

class StepInputItem extends StatelessWidget {
  final StepInput input;
  final TextStyle defaultTextStyle;
  final TextStyle remainingIngredientsStyle;
  final TextStyle totalIngredientsStyle;
  final DayPrep prep;

  StepInputItem(this.input,
      {this.defaultTextStyle,
      this.remainingIngredientsStyle,
      this.totalIngredientsStyle,
      this.prep});

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();
    double toMakeConversion;

    if (this.prep != null &&
        this.prep.madeQty != null &&
        this.prep.madeQty < this.prep.expectedQty) {
      toMakeConversion =
          (this.prep.expectedQty - this.prep.madeQty) / this.prep.expectedQty;
    }

    if (input.inputableType == "RecipeStep" &&
        input.unit == null &&
        input.quantity == 1) {
      widgets.add(Text(input.name, style: _setStyle(this.defaultTextStyle)));
    } else {
      final totalQty = this.prep != null
          ? input.quantity * this.prep.expectedQty
          : input.quantity;

      if (toMakeConversion != null) {
        final remainingQty = totalQty * toMakeConversion;
        widgets.add(Text(
            "${UnitConverter.qtyWithUnit(remainingQty, input.unit)} ",
            style: _setStyle(this.remainingIngredientsStyle)));
        widgets.add(Text(UnitConverter.qtyWithUnit(totalQty, input.unit),
            style: _setStyle(this.totalIngredientsStyle)));
      } else {
        widgets.add(Text(UnitConverter.qtyWithUnit(totalQty, input.unit),
            style: _setStyle(this.defaultTextStyle)));
      }
      widgets
          .add(Text(" ${input.name}", style: _setStyle(this.defaultTextStyle)));
    }

    return Wrap(children: widgets);
  }

  TextStyle _setStyle(TextStyle style) {
    if (style == null) {
      if (this.defaultTextStyle == null) {
        return Styles.textDefault;
      }
      return this.defaultTextStyle;
    }
    return style;
  }
}

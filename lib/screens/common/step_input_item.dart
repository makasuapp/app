import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';

enum InputItemStyles { regular, original, adjusted }

class StepInputItem extends StatelessWidget {
  // final StepInput input;
  final String inputName;
  final double originalInputQty;
  final String inputType;
  final String originalInputUnit;
  final double adjustedInputQty;
  final TextStyle regularTextStyle;
  final TextStyle adjustedQtyStyle;
  final TextStyle originalQtyStyle;

  StepInputItem(
    this.inputName,
    this.originalInputQty,
    this.inputType,
    this.originalInputUnit, {
    this.regularTextStyle,
    this.adjustedQtyStyle,
    this.originalQtyStyle,
    this.adjustedInputQty,
  });

  factory StepInputItem.fromStepInputItem(StepInput input,
      {double adjustedInputQty,
      TextStyle regularTextStyle,
      TextStyle adjustedQtyStyle,
      TextStyle originalQtyStyle}) {
    return StepInputItem(
      input.name,
      input.quantity,
      input.inputableType,
      input.unit,
      regularTextStyle: regularTextStyle,
      adjustedQtyStyle: adjustedQtyStyle,
      originalQtyStyle: originalQtyStyle,
      adjustedInputQty: adjustedInputQty,
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();

    if (this.inputType == "RecipeStep" &&
        this.originalInputUnit == null &&
        this.originalInputQty == 1 &&
        this.adjustedInputQty == null) {
      widgets
          .add(Text(this.inputName, style: _setStyle(InputItemStyles.regular)));
    } else {
      final hasAdjusted = this.adjustedInputQty != null &&
          this.adjustedInputQty != this.originalInputQty;
      widgets.add(Text(
        "${UnitConverter.qtyWithUnit(this.originalInputQty, this.originalInputUnit)}",
        style: (hasAdjusted)
            ? _setStyle(InputItemStyles.original)
            : _setStyle(InputItemStyles.regular),
      ));
      if (hasAdjusted) {
        widgets.add(Text(
          " ${UnitConverter.qtyWithUnit(this.adjustedInputQty, this.originalInputUnit)}",
          style: _setStyle(InputItemStyles.adjusted),
        ));
      }

      widgets.add(Text(
        " ${this.inputName}",
        style: _setStyle(InputItemStyles.regular),
      ));
    }

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  TextStyle _setStyle(InputItemStyles style) {
    switch (style) {
      case InputItemStyles.original:
        return this.originalQtyStyle ?? Styles.originalQtyStyle;
      case InputItemStyles.adjusted:
        return this.adjustedQtyStyle ?? Styles.adjustedQtyStyle;
      case InputItemStyles.regular:
        return this.regularTextStyle ?? Styles.regularTextStyle;
      default:
        return Styles.textDefault;
    }
  }
}

import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';

enum InputItemStyles { regular, original, adjusted }

class InputWithQuantity extends StatelessWidget {
  final String inputName;
  final double originalInputQty;
  final String inputType;
  final String originalInputUnit;
  final double adjustedInputQty;
  final String adjustedInputUnit;
  final TextStyle regularTextStyle;
  final TextStyle adjustedQtyStyle;
  final TextStyle originalQtyStyle;

  InputWithQuantity(
    this.inputName,
    this.originalInputQty,
    this.inputType,
    this.originalInputUnit, {
    this.regularTextStyle,
    this.adjustedQtyStyle,
    this.originalQtyStyle,
    this.adjustedInputQty,
    this.adjustedInputUnit,
  });

  factory InputWithQuantity.fromStepInput(StepInput input,
      {double adjustedInputQty,
      String adjustedInputUnit,
      TextStyle regularTextStyle,
      TextStyle adjustedQtyStyle,
      TextStyle originalQtyStyle}) {
    return InputWithQuantity(
      input.name,
      input.quantity,
      input.inputableType,
      input.unit,
      regularTextStyle: regularTextStyle,
      adjustedQtyStyle: adjustedQtyStyle,
      originalQtyStyle: originalQtyStyle,
      adjustedInputQty: adjustedInputQty,
      adjustedInputUnit: adjustedInputUnit,
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();

    if (this.inputType == InputType.RecipeStep &&
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
        final qtyWithUnit = UnitConverter.qtyWithUnit(this.adjustedInputQty,
            this.adjustedInputUnit ?? this.originalInputUnit);
        widgets.add(Text(
          " $qtyWithUnit",
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

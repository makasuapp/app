import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';

import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';

void main() {
  Widget _makeTestableWidget(InputWithQuantity child) {
    return MaterialApp(
      home: child,
    );
  }

  final inputName = "recipe step";

  testWidgets(
      'InputWithQuantity with recipe step, qty 1, null unit just shows name',
      (WidgetTester tester) async {
    final qty = 1.0;
    final units = null;

    final widget = _makeTestableWidget(
        InputWithQuantity(inputName, qty, InputType.RecipeStep, units));

    await tester.pumpWidget(widget);

    expect(find.text(inputName), findsOneWidget);
    expect(find.text("$qty"), findsNothing);
  });

  testWidgets(
      'InputWithQuantity with recipe step, qty not 1, null unit shows name and qty',
      (WidgetTester tester) async {
    final qty = 2.0;
    final units = null;

    final widget = _makeTestableWidget(
        InputWithQuantity(inputName, qty, InputType.RecipeStep, units));

    await tester.pumpWidget(widget);

    expect(find.text(UnitConverter.qtyWithUnit(qty, units)), findsOneWidget);
    expect(find.text(" $inputName"), findsOneWidget);
  });

  testWidgets(
      'InputWithQuantity with qty < adjusted qty shows qty and adjusted qty crossed out',
      (WidgetTester tester) async {
    final qty = 1.0;
    final adjustedQty = 2.0;
    final units = null;

    final widget = _makeTestableWidget(InputWithQuantity(
      inputName,
      qty,
      InputType.RecipeStep,
      units,
      adjustedInputQty: adjustedQty,
    ));

    await tester.pumpWidget(widget);

    expect(find.text(" ${UnitConverter.qtyWithUnit(adjustedQty, units)}"),
        findsOneWidget);
    expect(find.text(UnitConverter.qtyWithUnit(qty, units)), findsOneWidget);
    expect(
        ((tester.firstWidget(find.text(UnitConverter.qtyWithUnit(qty, units)))
                    as Text)
                .style)
            .decoration,
        TextDecoration.lineThrough);
  });

  testWidgets(
      'InputWithQuantity with qty > adjusted qty shows qty and adjusted qty crossed out',
      (WidgetTester tester) async {
    final adjustedQty = 1.0;
    final qty = 2.0;
    final units = null;

    final widget = _makeTestableWidget(InputWithQuantity(
      inputName,
      qty,
      InputType.RecipeStep,
      units,
      adjustedInputQty: adjustedQty,
    ));

    await tester.pumpWidget(widget);

    expect(find.text(" ${UnitConverter.qtyWithUnit(adjustedQty, units)}"),
        findsOneWidget);
    expect(find.text(UnitConverter.qtyWithUnit(qty, units)), findsOneWidget);
    expect(
        ((tester.firstWidget(find.text(UnitConverter.qtyWithUnit(qty, units)))
                    as Text)
                .style)
            .decoration,
        TextDecoration.lineThrough);
  });

  testWidgets(
      'InputWithQuantity with qty = adjusted qty just shows uncrossed qty',
      (WidgetTester tester) async {
    final sharedQty = 2.0;
    final units = "g";

    final widget = _makeTestableWidget(InputWithQuantity(
      inputName,
      sharedQty,
      InputType.Ingredient,
      units,
      adjustedInputQty: sharedQty,
      adjustedInputUnit: units,
    ));

    await tester.pumpWidget(widget);

    expect(find.text("${UnitConverter.qtyWithUnit(sharedQty, units)}"),
        findsNWidgets(1));
    expect(
        ((tester.firstWidget(
                find.text(UnitConverter.qtyWithUnit(sharedQty, units))) as Text)
            .style),
        Styles.regularTextStyle);
  });
}

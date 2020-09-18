import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/models/recipe_step.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/prep/components/prep_item.dart';
import 'package:kitchen/screens/prep/prep_styles.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  Widget _makeTestableWidget(PrepItem childWidget, ScopedLookup scopedLookup) {
    return MaterialApp(
      home: ScopedModel<ScopedLookup>(
          model: scopedLookup,
          child: ScopedModelDescendant<ScopedLookup>(
            builder: (BuildContext context, Widget child,
                ScopedLookup scopedLookup) {
              return childWidget;
            },
          )),
    );
  }

  RecipeStep _createRecipeStep(int id, List<StepInput> inputs) {
    return RecipeStep(id, 1, 1, "instruction", null, null, inputs);
  }

  DayPrep _createDayPrep(double expectedQty, int recipeStepId,
      {double madeQty}) {
    return DayPrep(1, expectedQty, recipeStepId, 1000, madeQty: madeQty);
  }

  StepInput _createInput(int inputId, {String unit, double qty}) {
    return StepInput(1, "input", inputId, InputType.Ingredient,
        unit: unit, quantity: qty);
  }

  Recipe _createRecipe() {
    return Recipe(1, "recipe");
  }

  final expectedQty = 4.0;
  final recipeStepId = 1;
  final inputQty = 5.0;

  testWidgets(
      'for each input in prep item, original qty should by input qty * expected qty',
      (WidgetTester tester) async {
    var inputs = List<StepInput>();
    inputs.add(_createInput(recipeStepId, qty: inputQty));

    final prep = _createDayPrep(expectedQty, recipeStepId);
    final recipeStep = _createRecipeStep(recipeStepId, inputs);

    final widget = _makeTestableWidget(PrepItem(prep),
        ScopedLookup(recipeSteps: [recipeStep], recipes: [_createRecipe()]));

    await tester.pumpWidget(widget);

    expect(inputQty * expectedQty, equals(20));
    expect(find.text('20'), findsOneWidget);
  });

  testWidgets(
      'for each input in prep item, remaining qty should be original qty * (expected qty - made qty)/expected qty',
      (WidgetTester tester) async {
    final madeQty = 2.0;

    var inputs = List<StepInput>();
    inputs.add(_createInput(recipeStepId, qty: inputQty));

    final prep = _createDayPrep(expectedQty, recipeStepId, madeQty: madeQty);
    final recipeStep = _createRecipeStep(recipeStepId, inputs);

    final widget = _makeTestableWidget(PrepItem(prep),
        ScopedLookup(recipeSteps: [recipeStep], recipes: [_createRecipe()]));

    await tester.pumpWidget(widget);

    expect((inputQty * expectedQty) * ((expectedQty - madeQty) / expectedQty),
        equals(10));
    expect(find.text(" 10"), findsOneWidget);
    expect((tester.firstWidget(find.text(" 10")) as Text).style,
        PrepStyles.remainingIngredientText);
  });

  testWidgets(
      'prep item should show no remaining qty if made qty > expected qty',
      (WidgetTester tester) async {
    final madeQty = 8.0;

    var inputs = List<StepInput>();
    inputs.add(_createInput(recipeStepId, qty: inputQty));

    final prep = _createDayPrep(expectedQty, recipeStepId, madeQty: madeQty);
    final recipeStep = _createRecipeStep(recipeStepId, inputs);

    final widget = _makeTestableWidget(PrepItem(prep),
        ScopedLookup(recipeSteps: [recipeStep], recipes: [_createRecipe()]));

    await tester.pumpWidget(widget);

    expect((inputQty * expectedQty) * ((expectedQty - madeQty) / expectedQty),
        equals(-20));
    expect(find.text(" -20"), findsNothing);
  });
}

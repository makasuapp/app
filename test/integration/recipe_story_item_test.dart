import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/models/recipe_step.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/screens/prep/components/prep_item.dart';
import 'package:kitchen/screens/prep/prep_styles.dart';
import 'package:kitchen/screens/story/components/recipe_story_item.dart';
import 'package:kitchen/screens/story/components/story_item.dart';
import 'package:kitchen/screens/story/story_styles.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  final recipeId = 1;
  final recipeStepId = 2;
  final inputId = 3;

  Widget _makeTestableWidget(StoryItem childWidget, ScopedLookup scopedLookup) {
    return MaterialApp(
      home: ScopedModel<ScopedStory>(
        model: ScopedStory(childWidget),
        child: ScopedModelDescendant<ScopedStory>(
          builder:
              (BuildContext context, Widget child, ScopedStory scopedStory) {
            return ScopedModel<ScopedLookup>(
                model: scopedLookup,
                child: ScopedModelDescendant<ScopedLookup>(builder:
                    (BuildContext context, Widget child,
                        ScopedLookup scopedLookup) {
                  return Material(
                    child: childWidget,
                  );
                }));
          },
        ),
      ),
    );
  }

  Recipe _createRecipe({double outputQty, String units}) {
    return Recipe(recipeId, "recipe",
        prepStepIds: [recipeStepId], outputQty: outputQty, unit: units);
  }

  RecipeStep _createRecipeStep(List<StepInput> inputs) {
    return RecipeStep(
        recipeStepId, recipeId, "prep", 1, "instruction", null, null, inputs);
  }

  StepInput _createInput({String unit, double qty}) {
    return StepInput(inputId, "input", recipeStepId, InputType.Ingredient,
        unit: unit, quantity: qty);
  }

  testWidgets(
      'recipe story with qty different from original qty should show adjusted qty',
      (WidgetTester tester) async {
    final outputQty = 5.0;
    final qtyOfInput = 2.0;
    final servingSize = 10.0;
    final recipe = _createRecipe(outputQty: outputQty, units: null);
    final input = _createInput(qty: qtyOfInput);
    final recipeStep = _createRecipeStep([input]);

    ScopedLookup scopedLookup = ScopedLookup(recipeSteps: [recipeStep]);

    final widget = _makeTestableWidget(
        RecipeStoryItem(recipe, servingSize: servingSize), scopedLookup);

    await tester.pumpWidget(widget);

    expect(qtyOfInput, equals(2));
    expect(find.text("2"), findsOneWidget);
    expect((tester.firstWidget(find.text("2")) as Text).style,
        StoryStyles.initialQtyText);

    expect((servingSize / outputQty) * qtyOfInput, equals(4));
    expect(find.text(" 4"), findsOneWidget);
    expect((tester.firstWidget(find.text(" 4")) as Text).style,
        StoryStyles.adjustedQtyText);
  });

  testWidgets(
      'recipe story with units different from original units should show adjusted qty',
      (WidgetTester tester) async {
    final outputQty = 3.0;
    final qtyOfInput = 6.0;
    final recipeUnits = "tbsp";
    final displayUnits = "tsp";
    final recipe = _createRecipe(outputQty: outputQty, units: recipeUnits);
    final input = _createInput(qty: qtyOfInput);
    final recipeStep = _createRecipeStep([input]);

    ScopedLookup scopedLookup = ScopedLookup(recipeSteps: [recipeStep]);

    final widget = _makeTestableWidget(
        RecipeStoryItem(recipe, outputUnits: displayUnits), scopedLookup);

    await tester.pumpWidget(widget);

    expect(qtyOfInput, equals(6));
    expect(find.text("6"), findsOneWidget);
    expect((tester.firstWidget(find.text("6")) as Text).style,
        StoryStyles.initialQtyText);

    expect(
        (UnitConverter.convert(outputQty,
                    inputUnit: displayUnits, outputUnit: recipeUnits) /
                outputQty) *
            qtyOfInput,
        equals(2));
    expect(find.text(" 2"), findsOneWidget);
    expect((tester.firstWidget(find.text(" 2")) as Text).style,
        StoryStyles.adjustedQtyText);
  });
}

import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:kitchen/screens/common/components/submit_button.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../../styles.dart';
import '../../../models/recipe.dart';
import '../../../models/recipe_step.dart';
import '../../../models/step_input.dart';
import '../story_styles.dart';
import 'recipe_story_item.dart';
import 'recipe_step_story_item.dart';
import 'cook_story_styles.dart';
import 'story_item.dart';

class CookStoryItem extends StoryItem {
  final Recipe recipe;

  CookStoryItem(this.recipe, {String outputUnits, double servingSize})
      : super(outputUnits ?? recipe.unit, servingSize ?? recipe.outputQty);

  @override
  Widget renderContent() {
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) =>
            ScopedModelDescendant<ScopedLookup>(
                builder: (context, child, scopedLookup) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _renderInfo(scopedLookup, scopedStory));
            }));
  }

  @override
  StoryItem getUpdatedStoryItem(String outputUnits, double servingSize) {
    return CookStoryItem(this.recipe,
        outputUnits: outputUnits, servingSize: servingSize);
  }

  @override
  bool hasVolumeWeightRatio() {
    return (this.recipe.volumeWeightRatio != null);
  }

  List<Widget> _renderInfo(ScopedLookup scopedLookup, ScopedStory scopedStory) {
    return <Widget>[
          _renderTitle(),
          _fullRecipeButton(scopedStory),
          _renderHeader("Ingredients On Order")
        ] +
        _renderCookInputs(scopedLookup, scopedStory) +
        <Widget>[_renderHeader("Cook Steps")] +
        _renderCookSteps(scopedLookup, scopedStory);
  }

  Widget _renderTitle() {
    return Container(
        padding: Styles.spacerPadding,
        child: Text(
          "Order of ${this.recipe.name}",
          style: StoryStyles.storyHeaderLarge,
        ));
  }

  Widget _fullRecipeButton(ScopedStory scopedStory) {
    return SubmitButton(
        () => scopedStory.push(RecipeStoryItem(this.recipe,
            outputUnits: this.displayedUnits, servingSize: this.servingSize)),
        btnText: "View Full Recipe");
  }

  List<Widget> _renderCookInputs(
      ScopedLookup scopedLookup, ScopedStory scopedStory) {
    final cookInputs = this
        .recipe
        .cookStepIds
        .map((id) => scopedLookup.recipeStepsMap[id])
        .expand((step) => step.inputs)
        .where((input) {
      //drop cook steps
      if (input.inputableType == InputType.RecipeStep) {
        final recipeStep = scopedLookup.recipeStepsMap[input.inputableId];
        return recipeStep.stepType == "prep";
      } else
        return true;
    });

    return cookInputs.map((input) {
      if (input.inputableType == InputType.Ingredient) {
        return _renderInput(input);
      } else if (input.inputableType == InputType.Recipe) {
        final recipe = scopedLookup.recipesMap[input.inputableId];
        return InkWell(
            onTap: () {
              scopedStory.push(RecipeStoryItem(recipe,
                  outputUnits: input.unit,
                  servingSize: _getAdjustedQty(input.quantity)));
            },
            child: _renderInput(input));
      } else if (input.inputableType == InputType.RecipeStep) {
        final recipeStep = scopedLookup.recipeStepsMap[input.inputableId];
        return InkWell(
          onTap: () {
            scopedStory.push(RecipeStepStoryItem(recipeStep,
                servingSize: _getAdjustedQty(input.quantity)));
          },
          child: _renderInput(input),
        );
      } else {
        throw Exception("unexpected inputable type ${input.inputableType}");
      }
    }).toList();
  }

  List<Widget> _renderCookSteps(
      ScopedLookup scopedLookup, ScopedStory scopedStory) {
    return this.recipe.cookStepIds.map((id) {
      final recipeStep = scopedLookup.recipeStepsMap[id];
      return InkWell(
          onTap: () {
            scopedStory.push(RecipeStepStoryItem(recipeStep,
                servingSize: _getAdjustedQty(1.0)));
          },
          child: _renderCookStep(recipeStep));
    }).toList();
  }

  Widget _renderCookStep(RecipeStep recipeStep) {
    var widgets = List<Widget>();

    widgets.add(Text("${recipeStep.number}. ${recipeStep.instruction}",
        style: CookStoryStyles.instructionsText));

    if (recipeStep.inputs.length > 0) {
      widgets.add(Container(
          padding: CookStoryStyles.ingredientsHeaderPadding,
          child:
              Text("Ingredients", style: CookStoryStyles.ingredientsHeader)));

      recipeStep.inputs.forEach((input) => widgets
          .add(_renderInput(input, style: CookStoryStyles.ingredientText)));
    }

    return Container(
        padding: CookStoryStyles.instructionsPadding,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: widgets));
  }

  Widget _renderHeader(String text) {
    return Container(
        padding: StoryStyles.headerPadding,
        child: Text(text, style: StoryStyles.storyHeader));
  }

  Widget _renderInput(StepInput input, {TextStyle style}) {
    //don't need crossing out for cook. however many servings is what we expect
    return InputWithQuantity(input.name, _getAdjustedQty(input.quantity),
        input.inputableType, input.unit,
        regularTextStyle: style ?? StoryStyles.storyText);
  }

  double _getAdjustedQty(double inputQty) {
    final servingsInRecipeUnits = UnitConverter.convert(servingSize,
        inputUnit: this.displayedUnits,
        outputUnit: this.recipe.unit,
        volumeWeightRatio: this.recipe.volumeWeightRatio);
    return (inputQty * servingsInRecipeUnits) / recipe.outputQty;
  }
}

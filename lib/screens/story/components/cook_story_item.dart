import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/components/step_input_item.dart';
import 'package:kitchen/screens/common/components/submit_button.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_data.dart';
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
            ScopedModelDescendant<ScopedData>(
                builder: (context, child, scopedData) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _renderInfo(scopedData, scopedStory));
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

  List<Widget> _renderInfo(ScopedData scopedData, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderTitle());
    widgets.add(_fullRecipeButton(scopedStory));
    widgets.add(_renderHeader("Ingredients On Order"));
    widgets.addAll(_renderCookInputs(scopedData, scopedStory));
    widgets.add(_renderHeader("Cook Steps"));
    widgets.addAll(_renderCookSteps(scopedData, scopedStory));

    return widgets;
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
      ScopedData scopedData, ScopedStory scopedStory) {
    final cookInputs = this
        .recipe
        .cookStepIds
        .map((id) => scopedData.recipeStepsMap[id])
        .expand((step) => step.inputs)
        .where((input) {
      //drop cook steps
      if (input.inputableType == InputType.RecipeStep) {
        final recipeStep = scopedData.recipeStepsMap[input.inputableId];
        return recipeStep.stepType == "prep";
      } else
        return true;
    });

    return cookInputs.map((input) {
      if (input.inputableType == InputType.Ingredient) {
        return _renderInput(input);
      } else if (input.inputableType == InputType.Recipe) {
        final recipe = scopedData.recipesMap[input.inputableId];
        return InkWell(
            onTap: () {
              scopedStory.push(RecipeStoryItem(recipe,
                  outputUnits: input.unit,
                  servingSize: _getAdjustedQty(input.quantity)));
            },
            child: _renderInput(input));
      } else if (input.inputableType == InputType.RecipeStep) {
        final recipeStep = scopedData.recipeStepsMap[input.inputableId];
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
      ScopedData scopedData, ScopedStory scopedStory) {
    return this.recipe.cookStepIds.map((id) {
      final recipeStep = scopedData.recipeStepsMap[id];
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
    return StepInputItem(input.name, _getAdjustedQty(input.quantity),
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

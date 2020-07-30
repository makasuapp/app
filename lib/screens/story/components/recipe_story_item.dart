import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/step_input_item.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_data.dart';
import '../../../styles.dart';
import './story_item.dart';
import './recipe_step_story_item.dart';
import '../../../models/recipe.dart';
import '../../../models/step_input.dart';
import '../story_styles.dart';

class RecipeStoryItem extends StoryItem {
  final Recipe recipe;

  RecipeStoryItem(this.recipe, {String outputUnits, double servingSize})
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
    return RecipeStoryItem(this.recipe,
        outputUnits: outputUnits, servingSize: servingSize);
  }

  @override
  bool hasVolumeWeightRatio() {
    return (this.recipe.volumeWeightRatio != null);
  }

  List<Widget> _renderInfo(ScopedData scopedData, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderTitle());
    widgets.addAll(_renderAllInputs(scopedData, scopedStory));
    widgets.addAll(_renderAllSteps(scopedData, scopedStory));

    return widgets;
  }

  Widget _renderTitle() {
    return Container(
        padding: Styles.spacerPadding,
        child: Text(
          "${this.recipe.name}",
          style: StoryStyles.storyHeaderLarge,
        ));
  }

  List<Widget> _renderAllInputs(
      ScopedData scopedData, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderHeader("Ingredients"));
    final steps = (this.recipe.prepStepIds + this.recipe.cookStepIds)
        .map((id) => scopedData.recipeStepsMap[id])
        .toList();
    var inputs = List<StepInput>();
    //TODO: combine ingredients that are the same as a result of subrecipes
    //or list subrecipes as subheaders with their ingredients under
    steps.forEach((step) => step.inputs.forEach((input) {
          if (input.inputableType == InputType.Ingredient ||
              input.inputableType == InputType.Recipe) {
            inputs.add(input);
          }
        }));

    inputs.forEach((input) {
      if (input.inputableType == InputType.Ingredient) {
        widgets.add(_renderInput(scopedData, input));
      } else if (input.inputableType == InputType.Recipe) {
        final recipe = scopedData.recipesMap[input.inputableId];
        widgets.add(InkWell(
            onTap: () {
              scopedStory.push(RecipeStoryItem(
                recipe,
                servingSize: _getAdjustedQty(
                    input.quantity),
                outputUnits: input.unit,
              ));
            },
            child: _renderInput(scopedData, input)));
      }
    });

    return widgets;
  }

  List<Widget> _renderAllSteps(ScopedData scopedData, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    if (this.recipe.prepStepIds.length > 0) {
      widgets.add(_renderHeader("Prep"));
      widgets.addAll(
          _renderSteps(scopedData, scopedStory, this.recipe.prepStepIds));
    }
    if (this.recipe.cookStepIds.length > 0) {
      widgets.add(_renderHeader("Cook"));
      widgets.addAll(
          _renderSteps(scopedData, scopedStory, this.recipe.cookStepIds));
    }

    return widgets;
  }

  Widget _renderHeader(String text) {
    return Container(
        padding: StoryStyles.headerPadding,
        child: Text(text, style: StoryStyles.storyHeader));
  }

  List<Widget> _renderSteps(
      ScopedData scopedData, ScopedStory scopedStory, List<int> ids) {
    return ids.map((id) {
      final recipeStep = scopedData.recipeStepsMap[id];
      return InkWell(
          onTap: () {
            scopedStory.push(RecipeStepStoryItem(recipeStep,
                servingSize: _getAdjustedQty(1.0)));
          },
          child: Text("${recipeStep.number}. ${recipeStep.instruction}",
              style: StoryStyles.storyText));
    }).toList();
  }

  Widget _renderInput(ScopedData scopedData, StepInput input) {
    final servingsInRecipeUnits = UnitConverter.convert(servingSize,
        inputUnit: this.displayedUnits,
        outputUnit: this.recipe.unit,
        volumeWeightRatio: this.recipe.volumeWeightRatio);
    return StepInputItem.fromStepInputItem(
      input,
      adjustedInputQty: (servingsInRecipeUnits
                  .toStringAsPrecision(2) !=
              this.recipe.outputQty.toStringAsPrecision(2))
          ? _getAdjustedQty(input.quantity)
          : null,
      regularTextStyle: StoryStyles.storyText,
      adjustedQtyStyle: StoryStyles.adjustedQtyText,
      originalQtyStyle: StoryStyles.initialQtyText,
    );
  }

  double _getAdjustedQty(double inputQty) {
    double servingsInRecipeUnits = UnitConverter.convert(servingSize,
        inputUnit: this.displayedUnits,
        outputUnit: this.recipe.unit,
        volumeWeightRatio: this.recipe.volumeWeightRatio);
    return (inputQty * servingsInRecipeUnits) / recipe.outputQty;
  }
}

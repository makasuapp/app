import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:kitchen/screens/common/components/submit_button.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../../styles.dart';
import './story_item.dart';
import './order_story_item.dart';
import './recipe_step_story_item.dart';
import '../../../models/recipe.dart';
import '../../../models/step_input.dart';
import '../story_styles.dart';

class RecipeStoryItem extends StoryItem {
  final Recipe recipe;

  RecipeStoryItem(this.recipe, {String outputUnits, double servingSize})
      : super(outputUnits ?? recipe.unit, servingSize ?? recipe.outputQty,
            "Recipe");

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
    return RecipeStoryItem(this.recipe,
        outputUnits: outputUnits, servingSize: servingSize);
  }

  @override
  bool hasVolumeWeightRatio() {
    return (this.recipe.volumeWeightRatio != null);
  }

  List<Widget> _renderInfo(ScopedLookup scopedLookup, ScopedStory scopedStory) {
    return <Widget>[_renderTitle(), _orderRecipeButton(scopedStory)] +
        _renderAllInputs(scopedLookup, scopedStory) +
        _renderAllSteps(scopedLookup, scopedStory);
  }

  Widget _renderTitle() {
    return Container(
        padding: Styles.spacerPadding,
        child: Text(
          "${this.recipe.name}",
          style: StoryStyles.storyHeaderLarge,
        ));
  }

  Widget _orderRecipeButton(ScopedStory scopedStory) {
    return SubmitButton(
        () => scopedStory.push(OrderStoryItem(this.recipe,
            outputUnits: this.displayedUnits, servingSize: this.servingSize)),
        btnText: "View Order Recipe");
  }

  //TODO: aggregate all ingredients across subrecipes
  List<Widget> _renderAllInputs(
      ScopedLookup scopedLookup, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderHeader("Ingredients"));
    final steps = this
        .recipe
        .stepIds
        .map((id) => scopedLookup.getRecipeStep(id))
        .toList();

    var inputs = List<StepInput>();
    steps.forEach((step) => step.inputs.forEach((input) {
          if (input.inputableType == InputType.Ingredient ||
              input.inputableType == InputType.Recipe) {
            inputs.add(input);
          }
        }));

    inputs.forEach((input) {
      if (input.inputableType == InputType.Ingredient) {
        widgets.add(_renderInput(scopedLookup, input));
      } else if (input.inputableType == InputType.Recipe) {
        final recipe = scopedLookup.getRecipe(input.inputableId);
        widgets.add(InkWell(
            onTap: () {
              scopedStory.push(RecipeStoryItem(
                recipe,
                servingSize: _getAdjustedQty(input.quantity),
                outputUnits: input.unit,
              ));
            },
            child: _renderInput(scopedLookup, input)));
      }
    });

    return widgets;
  }

  //TODO: show steps of each subrecipe in sequence
  List<Widget> _renderAllSteps(
      ScopedLookup scopedLookup, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    if (this.recipe.stepIds.length > 0) {
      widgets.add(_renderHeader("Steps"));
      widgets
          .addAll(_renderSteps(scopedLookup, scopedStory, this.recipe.stepIds));
    }

    return widgets;
  }

  Widget _renderHeader(String text) {
    return Container(
        padding: StoryStyles.headerPadding,
        child: Text(text, style: StoryStyles.storyHeader));
  }

  List<Widget> _renderSteps(
      ScopedLookup scopedLookup, ScopedStory scopedStory, List<int> ids) {
    return ids.map((id) {
      final recipeStep = scopedLookup.getRecipeStep(id);
      return InkWell(
          onTap: () {
            scopedStory.push(RecipeStepStoryItem(recipeStep,
                servingSize: _getAdjustedQty(1.0)));
          },
          child: Text("${recipeStep.number}. ${recipeStep.instruction}",
              style: StoryStyles.storyText));
    }).toList();
  }

  Widget _renderInput(ScopedLookup scopedLookup, StepInput input) {
    final servingsInRecipeUnits = UnitConverter.convert(servingSize,
        inputUnit: this.displayedUnits,
        outputUnit: this.recipe.unit,
        volumeWeightRatio: this.recipe.volumeWeightRatio);
    return InputWithQuantity.fromStepInput(
      input,
      adjustedInputQty: (servingsInRecipeUnits.toStringAsFixed(2) !=
              this.recipe.outputQty.toStringAsFixed(2))
          ? _getAdjustedQty(input.quantity)
          : null,
      adjustedInputUnit: input.unit,
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

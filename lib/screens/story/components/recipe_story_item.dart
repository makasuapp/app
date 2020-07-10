import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import './story_item.dart';
import './recipe_step_story_item.dart';
import '../../../models/recipe.dart';
import '../../../models/step_input.dart';
import '../story_styles.dart';
import '../../../services/unit_converter.dart';

class RecipeStoryItem extends StoryItem {
  final Recipe recipe;

  RecipeStoryItem(this.recipe);

  @override
  Widget renderContent() {
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) =>
            ScopedModelDescendant<ScopedOrder>(
                builder: (context, child, scopedOrder) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _renderAllInputs(scopedOrder, scopedStory) +
                        _renderAllSteps(scopedOrder, scopedStory))));
  }

  List<Widget> _renderAllInputs(
      ScopedOrder scopedOrder, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderHeader("Ingredients"));
    final steps = (this.recipe.prepStepIds + this.recipe.cookStepIds)
        .map((id) => scopedOrder.recipeStepsMap[id])
        .toList();
    var inputs = Set<StepInput>();
    //TODO: combine ingredients that are the same
    steps.forEach((step) => step.inputs.forEach((input) {
          if (input.inputableType == InputType.Ingredient ||
              input.inputableType == InputType.Recipe) {
            inputs.add(input);
          }
        }));

    inputs.forEach((input) {
      if (input.inputableType == InputType.Ingredient) {
        widgets.add(_renderInput(input, scopedStory));
      } else if (input.inputableType == InputType.Recipe) {
        final recipe = scopedOrder.recipesMap[input.inputableId];
        widgets.add(InkWell(
            onTap: () => scopedStory.push(RecipeStoryItem(recipe)),
            child: _renderInput(input, scopedStory)));
      }
    });

    return widgets;
  }

  Widget _renderInput(StepInput input, ScopedStory scopedStory) {
    final qty = UnitConverter.qtyWithUnit(input.quantity, input.unit);
    return Text("$qty ${input.name}", style: StoryStyles.storyText);
  }

  List<Widget> _renderAllSteps(
      ScopedOrder scopedOrder, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    if (this.recipe.prepStepIds.length > 0) {
      widgets.add(_renderHeader("Prep"));
      widgets.addAll(
          _renderSteps(scopedOrder, scopedStory, this.recipe.prepStepIds));
    }
    if (this.recipe.cookStepIds.length > 0) {
      widgets.add(_renderHeader("Cook"));
      widgets.addAll(
          _renderSteps(scopedOrder, scopedStory, this.recipe.cookStepIds));
    }

    return widgets;
  }

  Widget _renderHeader(String text) {
    return Container(
        padding: StoryStyles.headerPadding,
        child: Text(text, style: StoryStyles.storyHeader));
  }

  List<Widget> _renderSteps(
      ScopedOrder scopedOrder, ScopedStory scopedStory, List<int> ids) {
    return ids.map((id) {
      final recipeStep = scopedOrder.recipeStepsMap[id];
      return InkWell(
          onTap: () => scopedStory.push(RecipeStepStoryItem(recipeStep)),
          child: Text("${recipeStep.number}. ${recipeStep.instruction}",
              style: StoryStyles.storyText));
    }).toList();
  }
}

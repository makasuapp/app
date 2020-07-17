import 'package:flutter/material.dart';
import 'package:kitchen/screens/common/step_input_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_data.dart';
import './story_item.dart';
import './recipe_step_story_item.dart';
import '../../../models/recipe.dart';
import '../../../models/step_input.dart';
import '../story_styles.dart';

class RecipeStoryItem extends StoryItem {
  final Recipe recipe;

  RecipeStoryItem(this.recipe);

  @override
  Widget renderContent() {
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) =>
            ScopedModelDescendant<ScopedData>(
                builder: (context, child, scopedData) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _renderAllInputs(scopedData, scopedStory) +
                        _renderAllSteps(scopedData, scopedStory))));
  }

  List<Widget> _renderAllInputs(
      ScopedData scopedData, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderHeader("Ingredients"));
    final steps = (this.recipe.prepStepIds + this.recipe.cookStepIds)
        .map((id) => scopedData.recipeStepsMap[id])
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
        widgets
            .add(StepInputItem(input, defaultTextStyle: StoryStyles.storyText));
      } else if (input.inputableType == InputType.Recipe) {
        final recipe = scopedData.recipesMap[input.inputableId];
        widgets.add(InkWell(
            onTap: () {
              scopedStory.push(RecipeStoryItem(recipe));
            },
            child:
                StepInputItem(input, defaultTextStyle: StoryStyles.storyText)));
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
          onTap: () => scopedStory.push(RecipeStepStoryItem(recipeStep)),
          child: Text("${recipeStep.number}. ${recipeStep.instruction}",
              style: StoryStyles.storyText));
    }).toList();
  }
}

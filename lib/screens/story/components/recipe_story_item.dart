import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import './story_item.dart';
import './recipe_step_story_item.dart';
import '../../../models/recipe.dart';

class RecipeStoryItem extends StoryItem {
  final Recipe recipe;

  RecipeStoryItem(this.recipe);

  @override
  Widget renderContent() {
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) =>
            ScopedModelDescendant<ScopedOrder>(
                builder: (context, child, scopedOrder) => Column(
                    children: _renderAllSteps(scopedOrder, scopedStory))));
  }

  //TODO: render all ingredient and recipe inputs

  List<Widget> _renderAllSteps(
      ScopedOrder scopedOrder, ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(Text("Prep"));
    widgets.addAll(
        _renderSteps(scopedOrder, scopedStory, this.recipe.prepStepIds));
    widgets.add(Text("Cook"));
    widgets.addAll(
        _renderSteps(scopedOrder, scopedStory, this.recipe.cookStepIds));

    return widgets;
  }

  List<Widget> _renderSteps(
      ScopedOrder scopedOrder, ScopedStory scopedStory, List<int> ids) {
    return ids.map((id) {
      final recipeStep = scopedOrder.recipeStepsMap[id];
      return InkWell(
          onTap: () => scopedStory.push(RecipeStepStoryItem(recipeStep)),
          child: Text("${recipeStep.number} ${recipeStep.instruction}"));
    }).toList();
  }
}

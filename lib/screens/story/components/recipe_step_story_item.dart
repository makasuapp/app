import 'package:flutter/material.dart';
import './story_item.dart';
import '../../../models/recipe_step.dart';

class RecipeStepStoryItem extends StoryItem {
  final RecipeStep recipeStep;

  RecipeStepStoryItem(this.recipeStep);

  @override
  Widget renderContent() {
    return Text(this.recipeStep.instruction);
  }
}

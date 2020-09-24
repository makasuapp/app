import 'package:flutter/material.dart';
import 'package:kitchen/models/recipe_step.dart';
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
        _renderAllRecipes(scopedLookup, scopedStory);
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

  //TODO: aggregate subrecipes that are the same?
  //list of all subrecipes' step inputs and steps
  List<RecipeData> _getRecipeData(ScopedLookup scopedLookup, Recipe recipe) {
    var recipeData = List<RecipeData>();
    var inputs = List<StepInput>();
    final steps =
        recipe.stepIds.map((id) => scopedLookup.getRecipeStep(id)).toList();
    steps.forEach((step) {
      step.inputs.forEach((input) {
        if (input.inputableType == StepInputType.Ingredient ||
            input.inputableType == StepInputType.Recipe) {
          inputs.add(input);
        }

        if (input.inputableType == StepInputType.Recipe) {
          final childRecipe = scopedLookup.getRecipe(input.inputableId);
          final childRecipeData = _getRecipeData(scopedLookup, childRecipe);
          final numServings =
              childRecipe.servingsProduced(input.quantity, input.unit);
          childRecipeData.forEach((childData) =>
              childData.scaleFactor = childData.scaleFactor * numServings);
          recipeData.addAll(childRecipeData);
        }
      });
    });

    recipeData.add(RecipeData(recipe, inputs, steps));

    return recipeData;
  }

  List<Widget> _renderAllRecipes(
      ScopedLookup scopedLookup, ScopedStory scopedStory) {
    var widgets = List<Widget>();
    var recipeData = _getRecipeData(scopedLookup, this.recipe);

    recipeData.forEach((data) {
      //don't both rendering recipes for single ingredient/step recipes
      if (data.inputs.length > 1 || data.steps.length > 1) {
        widgets.add(_renderHeader(data.recipe.name));
        widgets.addAll(_renderInputs(data, scopedLookup, scopedStory));
        widgets.addAll(_renderSteps(data, scopedLookup, scopedStory));
      }
    });

    return widgets;
  }

  List<Widget> _renderInputs(RecipeData recipeData, ScopedLookup scopedLookup,
      ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderHeader("Ingredients"));

    recipeData.inputs.forEach((input) {
      if (input.inputableType == StepInputType.Ingredient) {
        widgets.add(_renderInput(scopedLookup, input, recipeData.scaleFactor));
      } else if (input.inputableType == StepInputType.Recipe) {
        final recipe = scopedLookup.getRecipe(input.inputableId);
        widgets.add(InkWell(
            onTap: () {
              scopedStory.push(RecipeStoryItem(
                recipe,
                servingSize: _adjustQtyForStoryServings(
                    recipeData.scaleFactor * input.quantity),
                outputUnits: input.unit,
              ));
            },
            child: _renderInput(scopedLookup, input, recipeData.scaleFactor)));
      }
    });

    return widgets;
  }

  List<Widget> _renderSteps(RecipeData recipeData, ScopedLookup scopedLookup,
      ScopedStory scopedStory) {
    var widgets = List<Widget>();

    widgets.add(_renderHeader("Steps"));
    recipeData.steps.forEach((step) {
      widgets.add(InkWell(
          onTap: () {
            scopedStory.push(RecipeStepStoryItem(step,
                servingSize:
                    _adjustQtyForStoryServings(recipeData.scaleFactor)));
          },
          child: Text("${step.number}. ${step.instruction}",
              style: StoryStyles.storyText)));
    });

    return widgets;
  }

  Widget _renderHeader(String text) {
    return Container(
        padding: StoryStyles.headerPadding,
        child: Text(text, style: StoryStyles.storyHeader));
  }

  Widget _renderInput(
      ScopedLookup scopedLookup, StepInput input, double scaleFactor) {
    final inputQty = input.quantity * scaleFactor;
    return InputWithQuantity(
      input.name,
      inputQty,
      input.inputableType,
      input.unit,
      adjustedInputQty: _adjustQtyForStoryServings(inputQty),
      adjustedInputUnit: input.unit,
      regularTextStyle: StoryStyles.storyText,
      adjustedQtyStyle: StoryStyles.adjustedQtyText,
      originalQtyStyle: StoryStyles.initialQtyText,
    );
  }

  double _adjustQtyForStoryServings(double inputQty) {
    double servingsInRecipeUnits = UnitConverter.convert(this.servingSize,
        inputUnit: this.displayedUnits,
        outputUnit: this.recipe.unit,
        volumeWeightRatio: this.recipe.volumeWeightRatio);
    return (inputQty * servingsInRecipeUnits) / recipe.outputQty;
  }
}

class RecipeData {
  final Recipe recipe;
  final List<StepInput> inputs;
  final List<RecipeStep> steps;
  double scaleFactor = 1;

  RecipeData(this.recipe, this.inputs, this.steps);
}

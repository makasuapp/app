import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/models/detailed_instruction.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/models/tool.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:kitchen/screens/common/components/submit_button.dart';
import 'package:kitchen/screens/story/components/recipe_story_item.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import '../story_styles.dart';
import './story_item.dart';
import '../../../models/recipe_step.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';

class RecipeStepStoryItem extends StoryItem {
  final RecipeStep recipeStep;

  RecipeStepStoryItem(this.recipeStep, {double servingSize})
      : super(null, servingSize ?? 1, "Recipe Step");

  @override
  Widget renderContent() {
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) =>
            ScopedModelDescendant<ScopedLookup>(
                builder: (context, child, scopedLookup) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _renderInfo(context, scopedLookup, scopedStory));
            }));
  }

  @override
  StoryItem getUpdatedStoryItem(String outputUnits, double servingSize) {
    return RecipeStepStoryItem(this.recipeStep, servingSize: servingSize);
  }

  @override
  bool hasVolumeWeightRatio() {
    return false;
  }

  static Widget _renderTextBody(String text) {
    return Container(
      child: Text(
        text,
        style: StoryStyles.storyText,
      ),
      padding: StoryStyles.itemPadding,
    );
  }

  Widget _fullRecipeButton(ScopedStory scopedStory, ScopedLookup scopedLookup) {
    final recipe = scopedLookup.getRecipe(this.recipeStep.recipeId);
    final servingSize = this.servingSize * recipe.outputQty;

    return SubmitButton(
        () => scopedStory.push(RecipeStoryItem(recipe,
            outputUnits: recipe.unit, servingSize: servingSize)),
        btnText: "View Full Recipe");
  }

  static Widget _textHeader(String header) {
    return Container(
      child: Text(header, style: StoryStyles.storyHeader),
      padding: StoryStyles.headerPadding,
    );
  }

  List<Widget> _renderInfo(BuildContext context, ScopedLookup scopedLookup,
      ScopedStory scopedStory) {
    return <Widget>[
          _renderInstruction(),
          _fullRecipeButton(scopedStory, scopedLookup)
        ] +
        _renderListDuration() +
        _renderListTools() +
        _renderListDetailedInstructions() +
        _renderInputList(context, scopedStory, scopedLookup);
  }

  Widget _renderInstruction() {
    return new Container(
        padding: Styles.spacerPadding,
        child: Text(
          "${recipeStep.number}) ${recipeStep.instruction}",
          style: StoryStyles.storyHeaderLarge,
        ));
  }

  List<Widget> _renderListDuration() {
    var durationWidgets = List<Widget>();
    if (recipeStep.durationSec != null ||
        recipeStep.minBeforeSec != null ||
        recipeStep.maxBeforeSec != null) {
      durationWidgets.add(_textHeader("Durations"));

      if (recipeStep.durationSec != null) {
        durationWidgets.add(_renderTextBody(
            "Total duration: ${UnitConverter.stringifySec(recipeStep.durationSec)}"));
      }
      if (recipeStep.maxBeforeSec != null) {
        durationWidgets.add(_renderTextBody(
            "Max time in advance to prepare: ${UnitConverter.stringifySec(recipeStep.maxBeforeSec)}"));
      }
      if (recipeStep.minBeforeSec != null) {
        durationWidgets.add(_renderTextBody(
            "Min time in advance to prepare: ${UnitConverter.stringifySec(recipeStep.minBeforeSec)}"));
      }
    }
    return durationWidgets;
  }

  List<Widget> _renderListTools() {
    var toolsList = List<Widget>();
    if (recipeStep.tools.length != 0) {
      toolsList.add(_textHeader("Tools required"));
      for (Tool tool in recipeStep.tools) {
        toolsList.add(_renderTextBody("${tool.name}"));
      }
    }
    return toolsList;
  }

  List<Widget> _renderListDetailedInstructions() {
    var instructions = List<Widget>();
    if (recipeStep.detailedInstructions.length > 0) {
      instructions.add(_textHeader("Detailed Instructions"));

      for (DetailedInstruction detInst in recipeStep.detailedInstructions) {
        instructions.add(_renderTextBody("${detInst.instruction}"));
      }
    }
    return instructions;
  }

  List<Widget> _renderInputList(BuildContext context, ScopedStory scopedStory,
      ScopedLookup scopedLookup) {
    var inputsList = List<Widget>();
    if (recipeStep.inputs.length > 0) {
      inputsList.add(_textHeader("Inputs"));

      for (StepInput input in recipeStep.inputs) {
        if (input.inputableType == StepInputType.Ingredient) {
          inputsList.add(Container(
              child: _renderInput(input), padding: StoryStyles.itemPadding));
        } else if (input.inputableType == StepInputType.Recipe) {
          final recipe = scopedLookup.getRecipe(input.inputableId);
          inputsList.add(Container(
            child: InkWell(
                onTap: () {
                  scopedStory.push(RecipeStoryItem(
                    recipe,
                    servingSize: _getAdjustedQty(input),
                    outputUnits: input.unit,
                  ));
                },
                child: _renderInput(input)),
            padding: StoryStyles.itemPadding,
          ));
        } else if (input.inputableType == StepInputType.RecipeStep) {
          final recipeStep = scopedLookup.getRecipeStep(input.inputableId);
          inputsList.add(Container(
            child: InkWell(
              onTap: () {
                scopedStory.push(RecipeStepStoryItem(recipeStep,
                    servingSize: _getAdjustedQty(input)));
              },
              child: _renderInput(input),
            ),
            padding: StoryStyles.itemPadding,
          ));
        }
      }
    }
    return inputsList;
  }

  Widget _renderInput(StepInput input) {
    return InputWithQuantity.fromStepInput(
      input,
      adjustedInputQty:
          (this.servingSize.toStringAsFixed(2) != 1.toStringAsFixed(2))
              ? _getAdjustedQty(input)
              : null,
      adjustedInputUnit: input.unit,
      regularTextStyle: StoryStyles.storyText,
      adjustedQtyStyle: StoryStyles.adjustedQtyText,
      originalQtyStyle: StoryStyles.initialQtyText,
    );
  }

  double _getAdjustedQty(StepInput input) {
    return this.servingSize * input.quantity;
  }
}

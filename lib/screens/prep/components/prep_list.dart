import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/models/recipe_step.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';
import './prep_item.dart';
import '../../story/components/recipe_step_story_item.dart';
import '../../story/story.dart';
import '../../common/components/swipable.dart';
import '../adjust_done.dart';

enum PrepQtyTypes { madeQty, expectedQty, nullQty }

class PrepList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayPrep>(
        builder: (context, child, scopedPrep) =>
            ScopedModelDescendant<ScopedLookup>(
                builder: (context, child, scopedLookup) =>
                    SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _renderView(
                                context, scopedPrep, scopedLookup)))));
  }

  List<Widget> _renderView(BuildContext context, ScopedDayPrep scopedPrep,
      ScopedLookup scopedLookup) {
    var notDoneItems = List();
    var doneItems = List();

    var subrecipeDataMap = Map<int, SubrecipeData>();
    var prepsMap = Map<int, bool>();
    var orderedItems = List();

    scopedPrep.prep.forEach((prep) {
      final recipeStep = scopedLookup.recipeStepsMap[prep.recipeStepId];
      final recipe = scopedLookup.recipesMap[recipeStep.recipeId];

      final done = prep.madeQty != null && prep.expectedQty <= prep.madeQty;
      if(prep.id == 270){
        print(done);
      }

      if (recipe.publish) {
        prepsMap[prep.id] = done;
        orderedItems.add(prep);
      } else if (subrecipeDataMap[recipe.id] == null) {
        subrecipeDataMap[recipe.id] =
            _getSubrecipeData(prep, recipeStep, recipe);
        subrecipeDataMap[recipe.id].updateDone(done);
        orderedItems.add(subrecipeDataMap[recipe.id].recipe);
      } else {
        subrecipeDataMap[recipe.id].addPrep(prep);
        subrecipeDataMap[recipe.id].addInputs(recipeStep.inputs, prep);
        subrecipeDataMap[recipe.id].updateDone(done);
      }
    });

    orderedItems.forEach((element) {
      if (element is DayPrep) {
        (prepsMap[element.id])
            ? doneItems.add(element)
            : notDoneItems.add(element);
      } else if (element is Recipe) {
        (subrecipeDataMap[element.id].isDone)
            ? doneItems.add(element)
            : notDoneItems.add(element);
      }
    });

    return <Widget>[_headerText("Not done")] +
        notDoneItems
            .map((e) => _renderItem(
                e, false, context, scopedPrep, scopedLookup, subrecipeDataMap))
            .toList() +
        <Widget>[_headerText("Done")] +
        doneItems
            .map((e) => _renderItem(
                e, true, context, scopedPrep, scopedLookup, subrecipeDataMap))
            .toList();
  }

  Widget _headerText(String text) {
    return Container(
        padding: PrepStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: PrepStyles.listHeader));
  }

  Widget _renderListItem(BuildContext context, DayPrep prep,
      ScopedDayPrep scopedPrep, ScopedLookup scopedLookup) {
    final originalQty = prep.madeQty;
    return Swipable(
        canSwipeLeft: () => Future.value(prep.madeQty != null),
        canSwipeRight: () => Future.value(
            prep.madeQty == null || prep.madeQty < prep.expectedQty),
        onSwipeLeft: (context) {
          scopedPrep.updatePrepQty(prep, null);
          _notifyQtyUpdate("Prep not done", context, () {
            scopedPrep.updatePrepQty(prep, originalQty);
          });
        },
        onSwipeRight: (context) {
          print("swiped");
          print(prep.id);
          scopedPrep.updatePrepQty(prep, prep.expectedQty);
          _notifyQtyUpdate("Prep done", context, () {
            scopedPrep.updatePrepQty(prep, originalQty);
          });
        },
        child: InkWell(
            onTap: () {
              StoryView.render(
                  context,
                  RecipeStepStoryItem(ScopedDayPrep.recipeStepFor(prep),
                      servingSize: prep.expectedQty - (prep.madeQty ?? 0)));
            },
            child: PrepItem(prep, onEdit: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AdjustPrepDonePage(prep,
                    onSubmit: (double setQty, BuildContext qtyViewContext) {
                  final originalQty = prep.madeQty;
                  scopedPrep.updatePrepQty(prep, setQty);
                  Navigator.pop(qtyViewContext);
                  _notifyQtyUpdate("Prep updated", context, () {
                    scopedPrep.updatePrepQty(prep, originalQty);
                  });
                });
              }));
            })));
  }

  Widget _renderSubrecipe(
      bool prepsDone,
      BuildContext context,
      ScopedDayPrep scopedPrep,
      ScopedLookup scopedLookup,
      SubrecipeData subrecipeData) {
    return Swipable(
        canSwipeLeft: () => Future.value(prepsDone),
        canSwipeRight: () => Future.value(!prepsDone),
        onSwipeLeft: (context) {
          final prepWithQty =
              _getPrepIdWithQtyMap(subrecipeData.preps, PrepQtyTypes.nullQty);
          scopedPrep.updatePrepQtys(prepWithQty);
          _notifyQtyUpdate("Recipe not done", context, () {
            final prepWithQty =
                _getPrepIdWithQtyMap(subrecipeData.preps, PrepQtyTypes.madeQty);
            scopedPrep.updatePrepQtys(prepWithQty);
          });
        },
        onSwipeRight: (context) {
          final prepWithQty = _getPrepIdWithQtyMap(
              subrecipeData.preps, PrepQtyTypes.expectedQty);
          scopedPrep.updatePrepQtys(prepWithQty);
          _notifyQtyUpdate("Recipe done", context, () {
            final prepWithQty =
                _getPrepIdWithQtyMap(subrecipeData.preps, PrepQtyTypes.madeQty);
            scopedPrep.updatePrepQtys(prepWithQty);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: (prepsDone)
              ? PrepStyles.listItemBorderDoneItems
              : PrepStyles.listItemBorder,
          child: ListTileTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ExpansionTile(
                  title: Text(
                    "Prepare ${subrecipeData.recipe.name}",
                    style: PrepStyles.listItemText,
                  ),
                  subtitle: _renderSubRecipeIngredients(
                      subrecipeData.inputs, subrecipeData.prepQtyForInput),
                  backgroundColor:
                      (!prepsDone) ? PrepStyles.subrecipeItemColor : null,
                  children: subrecipeData.preps
                      .map((e) =>
                          _renderListItem(context, e, scopedPrep, scopedLookup))
                      .toList())),
        ));
  }

  void _notifyQtyUpdate(
      String notificationText, BuildContext context, onTap()) {
    Flushbar flush;
    flush = Flushbar(
        message: notificationText,
        duration: Duration(seconds: 3),
        isDismissible: true,
        mainButton: InkWell(
            onTap: () {
              onTap();
              flush.dismiss();
            },
            child: Text("Undo", style: Styles.textHyperlink)))
      ..show(context);
  }

  Widget _renderItem(
      element,
      bool prepsDone,
      BuildContext context,
      ScopedDayPrep scopedPrep,
      ScopedLookup scopedLookup,
      Map<int, SubrecipeData> subrecipeDataMap) {
    if (element is DayPrep) {
      final prep = element;
      return _renderListItem(context, prep, scopedPrep, scopedLookup);
    } else if (element is Recipe) {
      final recipe = element;
      return _renderSubrecipe(prepsDone, context, scopedPrep, scopedLookup,
          subrecipeDataMap[recipe.id]);
    } else {
      return Container();
    }
  }

  Widget _renderSubRecipeIngredients(
      Set<StepInput> inputs, Map<String, double> qtys) {
    if (inputs.length > 0) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Container(
                  padding: PrepStyles.ingredientsHeaderPadding,
                  child: Text(
                    "Ingredients",
                    style: PrepStyles.ingredientsHeader,
                  ),
                )
              ] +
              inputs.map((input) {
                return InputWithQuantity(input.name, qtys[input.name],
                    input.inputableType, input.unit,
                    regularTextStyle: PrepStyles.ingredientText,
                    adjustedQtyStyle: PrepStyles.remainingIngredientText,
                    originalQtyStyle: PrepStyles.totalIngredientText);
              }).toList());
    } else {
      return Container(height: 0, width: 0);
    }
  }

  SubrecipeData _getSubrecipeData(
      DayPrep prep, RecipeStep recipeStep, Recipe recipe) {
    final data = SubrecipeData(recipe, preps: [prep], inputs: Set<StepInput>());

    data.addInputs(recipeStep.inputs, prep);
    return data;
  }

  Map<int, double> _getPrepIdWithQtyMap(
      List<DayPrep> preps, PrepQtyTypes qtyType) {
    var prepWithQtys = Map<int, double>();
    preps.forEach((prep) {
      prepWithQtys[prep.id] = _getPrepQtyFromQtyTypes(prep, qtyType);
    });
    return prepWithQtys;
  }

  double _getPrepQtyFromQtyTypes(DayPrep prep, PrepQtyTypes qtyType) {
    switch (qtyType) {
      case PrepQtyTypes.expectedQty:
        return prep.expectedQty;
      case PrepQtyTypes.madeQty:
        return prep.madeQty;
      case PrepQtyTypes.nullQty:
        return null;
      default:
        return null;
    }
  }
}

class SubrecipeData {
  final recipe;
  bool isDone;
  var inputs = Set<StepInput>();
  var preps = List<DayPrep>();
  var prepQtyForInput = Map<String, double>();
  var initialInputUnits = Map<String, String>();

  SubrecipeData(this.recipe,
      {this.inputs, this.preps, this.prepQtyForInput, this.initialInputUnits});

  addPrep(DayPrep prep) {
    this.preps.add(prep);
  }

  updateDone(bool done) {
    this.isDone = (isDone != null) ? isDone && done : done;
  }

  addInputs(List<StepInput> inputs, DayPrep prep) {
    inputs
        .where((element) => element.inputableType != InputType.RecipeStep)
        .forEach((element) {
      final originalQty = prep.expectedQty * element.quantity;
      if (this.prepQtyForInput == null ||
          this.prepQtyForInput[element.name] == null) {
        this.inputs.add(element);
        this.prepQtyForInput = this.prepQtyForInput ?? Map<String, double>();
        this.initialInputUnits =
            this.initialInputUnits ?? Map<String, String>();
        this.prepQtyForInput[element.name] = originalQty;
        this.initialInputUnits[element.name] = element.unit;
      } else {
        this.prepQtyForInput[element.name] += UnitConverter.convert(originalQty,
            inputUnit: element.unit,
            outputUnit: this.initialInputUnits[element.name],
            volumeWeightRatio: recipe.volumeWeightRatio);
      }
    });
  }
}

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/models/recipe_step.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/prep/components/swipable_subrecipe_item.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';

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

  //TODO: don't re-generate subrecipeDataMap every time, pretty intense
  List<Widget> _renderView(BuildContext context, ScopedDayPrep scopedPrep,
      ScopedLookup scopedLookup) {
    var subrecipeDataMap = Map<int, SubrecipeData>();

    //aggregate subrecipe data
    scopedPrep.getPrep().asMap().forEach((idx, prep) {
      final recipeStep = scopedLookup.getRecipeStep(prep.recipeStepId);
      final recipe = scopedLookup.getRecipe(recipeStep.recipeId);

      var subrecipeData = subrecipeDataMap[recipe.id];
      if (subrecipeData == null) {
        subrecipeData = _mkSubrecipeData(idx, prep, recipeStep, recipe);
      } else {
        subrecipeData.addPrep(prep);
        subrecipeData.addInputs(recipeStep.inputs, prep);
      }

      subrecipeDataMap[recipe.id] = subrecipeData;
    });

    var doneItems = List<SubrecipeData>();
    var notDoneItemsByTime = Map<int, List<SubrecipeData>>();
    subrecipeDataMap.values.forEach((subrecipeData) {
      if (subrecipeData.isDone) {
        doneItems.add(subrecipeData);
      } else {
        if (notDoneItemsByTime[subrecipeData.minNeededAtSec] == null) {
          notDoneItemsByTime[subrecipeData.minNeededAtSec] =
              List<SubrecipeData>();
        }
        notDoneItemsByTime[subrecipeData.minNeededAtSec].add(subrecipeData);
      }
    });

    var widgets = List<Widget>();

    var times = notDoneItemsByTime.keys.toList();
    times.sort();
    //show not done by time
    times.forEach((time) {
      final timeDate = DateTime.fromMillisecondsSinceEpoch(time * 1000);
      final timeStr = DateFormat('h:mm a').format(timeDate);
      widgets.add(_headerText("By $timeStr"));

      var items = notDoneItemsByTime[time];
      items.sort((a, b) => a.order - b.order);
      widgets.addAll(
          items.map((i) => SwipableSubrecipeItem(false, i, _notifyQtyUpdate)));
    });

    widgets.add(_headerText("Done"));
    widgets.addAll(
        doneItems.map((e) => SwipableSubrecipeItem(true, e, _notifyQtyUpdate)));
    return widgets;
  }

  Widget _headerText(String text) {
    return Container(
        padding: PrepStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: PrepStyles.listHeader));
  }

  void _notifyQtyUpdate(
      String notificationText, BuildContext context, Function() onTap) {
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

  SubrecipeData _mkSubrecipeData(
      int order, DayPrep prep, RecipeStep recipeStep, Recipe recipe) {
    final data = SubrecipeData(order, recipe);
    data.addPrep(prep);
    data.addInputs(recipeStep.inputs, prep);
    return data;
  }
}

class SubrecipeData {
  final int order;
  final Recipe recipe;
  int minNeededAtSec;
  bool isDone = true;
  var inputs = Set<StepInput>();
  var preps = List<DayPrep>();
  var prepQtyForInput = Map<String, double>();
  var initialInputUnits = Map<String, String>();

  SubrecipeData(this.order, this.recipe);

  addPrep(DayPrep prep) {
    final done = prep.madeQty != null && prep.expectedQty <= prep.madeQty;

    //this is the first step that's not done, minNeededAtSec is that
    //TODO: might be good to round to nearest 30 min, don't need so precise
    if (this.isDone && !done) {
      this.minNeededAtSec = prep.minNeededAtSec;
    }

    this.preps.add(prep);
    this.isDone = isDone && done;
  }

  addInputs(List<StepInput> inputs, DayPrep prep) {
    inputs
        .where((element) => element.inputableType != StepInputType.RecipeStep)
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

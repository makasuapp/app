import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';
import './prep_item.dart';
import '../../story/components/recipe_step_story_item.dart';
import '../../story/story.dart';

class PrepList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayPrep>(
        builder: (context, child, scopedPrep) => SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _renderView(context, scopedPrep))));
  }

  List<Widget> _renderView(BuildContext context, ScopedDayPrep scopedPrep) {
    var notStartedPrep = List<DayPrep>();
    var unfinishedPrep = List<DayPrep>();
    var donePrep = List<DayPrep>();

    scopedPrep.prep.forEach((prep) => {
          if (prep.madeQty == null)
            {notStartedPrep.add(prep)}
          else if (prep.expectedQty != prep.madeQty)
            {unfinishedPrep.add(prep)}
          else
            {donePrep.add(prep)}
        });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Not Started"));
    viewItems.addAll(notStartedPrep
        .map((i) => _renderListItem(context, i, scopedPrep))
        .toList());

    if (unfinishedPrep.length > 0) {
      viewItems.add(_headerText("Unfinished"));
      viewItems.addAll(unfinishedPrep
          .map((i) => _renderListItem(context, i, scopedPrep))
          .toList());
    }

    if (donePrep.length > 0) {
      viewItems.add(_headerText("Done"));
      viewItems.addAll(donePrep
          .map((i) => _renderListItem(context, i, scopedPrep))
          .toList());
    }

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
        padding: PrepStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: PrepStyles.listHeader));
  }

  Widget _renderListItem(
      BuildContext context, DayPrep prep, ScopedDayPrep scopedPrep) {
    return Dismissible(
        background: Container(color: Styles.swipeRightColor),
        secondaryBackground: Container(color: Styles.swipeLeftColor),
        confirmDismiss: (direction) => _canDismissItem(direction, prep),
        key: UniqueKey(),
        onDismissed: (direction) =>
            _onItemDismissed(direction, context, prep, scopedPrep),
        child: InkWell(
            onTap: () => StoryView.render(context,
                RecipeStepStoryItem(ScopedDayPrep.recipeStepFor(prep))),
            child: PrepItem(prep)));
  }

  Future<bool> _canDismissItem(DismissDirection direction, DayPrep prep) {
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      final isNotDone = prep.madeQty == null || prep.madeQty < prep.expectedQty;
      return Future.value(isNotDone);
      //swipe left
    } else if (direction == DismissDirection.endToStart) {
      final isStarted = prep.madeQty != null;
      return Future.value(isStarted);
    } else {
      return Future.value(false);
    }
  }

  void _onItemDismissed(DismissDirection direction, BuildContext context,
      DayPrep prep, ScopedDayPrep scopedPrep) {
    final originalQty = prep.madeQty;
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      //TODO: update to done
      _notifyQtyUpdate("Prep done", context, prep, scopedPrep, originalQty);
      //swipe right
    } else if (direction == DismissDirection.endToStart) {
      //TODO: update to not started
      _notifyQtyUpdate(
          "Prep not started", context, prep, scopedPrep, originalQty);
    }
  }

  void _notifyQtyUpdate(String notificationText, BuildContext context,
      DayPrep prep, ScopedDayPrep scopedPrep, double originalQty) {
    Flushbar flush;
    flush = Flushbar(
        message: notificationText,
        duration: Duration(seconds: 3),
        isDismissible: true,
        mainButton: InkWell(
            onTap: () {
              //TODO: update back to original
              flush.dismiss();
            },
            child: Text("Undo", style: Styles.textHyperlink)))
      ..show(context);
  }
}

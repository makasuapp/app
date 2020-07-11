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
import '../../common/swipable.dart';
import '../adjust_quantity.dart';

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
    final originalQty = prep.madeQty;
    return Swipable(
        canSwipeLeft: () => Future.value(prep.madeQty != null),
        canSwipeRight: () => Future.value(
            prep.madeQty == null || prep.madeQty < prep.expectedQty),
        onSwipeLeft: (context) {
          //TODO(swipe): update madeQty to null
          _notifyQtyUpdate(
              "Prep not started", context, prep, scopedPrep, originalQty);
        },
        onSwipeRight: (context) {
          //TODO(swipe): update madeQty to expectedQty
          _notifyQtyUpdate("Prep done", context, prep, scopedPrep, originalQty);
        },
        child: InkWell(
            onTap: () => StoryView.render(context,
                RecipeStepStoryItem(ScopedDayPrep.recipeStepFor(prep))),
            child: PrepItem(prep, onEdit: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return PrepAdjustQuantityPage(prep,
                    onSubmit: (double setQty, BuildContext qtyViewContext) {
                  final originalQty = prep.madeQty;
                  //TODO(swipe): update madeQty to setQty
                  Navigator.pop(qtyViewContext);
                  _notifyQtyUpdate(
                      "Prep updated", context, prep, scopedPrep, originalQty);
                });
              }));
            })));
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
              //TODO(swipe): update back to original
              flush.dismiss();
            },
            child: Text("Undo", style: Styles.textHyperlink)))
      ..show(context);
  }
}

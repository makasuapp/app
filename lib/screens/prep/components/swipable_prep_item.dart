import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import '../../../models/day_prep.dart';
import './prep_item.dart';
import '../../story/components/recipe_step_story_item.dart';
import '../../story/story.dart';
import '../../common/components/swipable.dart';
import '../adjust_done.dart';

class SwipablePrepItem extends StatelessWidget {
  final DayPrep prep;
  final Function(
          String notificationText, BuildContext context, Function() onTap)
      notifyQtyUpdate;

  SwipablePrepItem(this.prep, this.notifyQtyUpdate);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayPrep>(
        builder: (context, child, scopedPrep) =>
            _renderListItem(context, scopedPrep));
  }

  Widget _renderListItem(BuildContext context, ScopedDayPrep scopedPrep) {
    final originalQty = prep.madeQty;
    return Swipable(
        canSwipeLeft: () => Future.value(prep.madeQty != null),
        canSwipeRight: () => Future.value(
            prep.madeQty == null || prep.madeQty < prep.expectedQty),
        onSwipeLeft: (context) {
          scopedPrep.updatePrepQty(prep, null);
          this.notifyQtyUpdate("Prep not done", context, () {
            scopedPrep.updatePrepQty(prep, originalQty);
          });
        },
        onSwipeRight: (context) {
          scopedPrep.updatePrepQty(prep, prep.expectedQty);
          this.notifyQtyUpdate("Prep done", context, () {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: "Adjust Prep Done"),
                      builder: (_) {
                        return AdjustPrepDonePage(prep, onSubmit:
                            (double setQty, BuildContext qtyViewContext) {
                          final originalQty = prep.madeQty;
                          scopedPrep.updatePrepQty(prep, setQty);
                          Navigator.pop(qtyViewContext);
                          this.notifyQtyUpdate("Prep updated", context, () {
                            scopedPrep.updatePrepQty(prep, originalQty);
                          });
                        });
                      }));
            })));
  }
}

import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_op_day.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';

class PrepList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOpDay>(
      builder: (context, child, scopedOpDay) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _renderView(context, scopedOpDay)
        )
      )
    );
  }

  List<Widget> _renderView(BuildContext context, ScopedOpDay scopedOpDay) {
    var notStartedPrep = List<DayPrep>();
    var unfinishedPrep = List<DayPrep>();
    var donePrep = List<DayPrep>();

    scopedOpDay.prep.forEach((prep) => {
      if (prep.madeQty == null) {
        notStartedPrep.add(prep)
      } else if (prep.expectedQty != prep.madeQty) {
        unfinishedPrep.add(prep)
      } else {
        donePrep.add(prep)
      }
    });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Not Started"));
    viewItems.addAll(notStartedPrep.map((i) => 
      _renderListItem(context, i, scopedOpDay)).toList());

    if (unfinishedPrep.length > 0) {
      viewItems.add(_headerText("Unfinished"));
      viewItems.addAll(unfinishedPrep.map((i) => 
        _renderListItem(context, i, scopedOpDay)).toList());
    }

    if (donePrep.length > 0) {
      viewItems.add(_headerText("Done"));
      viewItems.addAll(donePrep.map((i) => 
        _renderListItem(context, i, scopedOpDay)).toList());
    }

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
      padding: PrepStyles.listHeaderPadding,
      child: Text(text.toUpperCase(), style: PrepStyles.listHeader)
    );
  }

  Widget _renderListItem(BuildContext context, DayPrep prep, ScopedOpDay scopedOpDay) {
    return Dismissible(
      background: Container(color: Styles.swipeRightColor),
      secondaryBackground: Container(color: Styles.swipeLeftColor),
      confirmDismiss: (direction) => _canDismissItem(direction, prep),
      key: UniqueKey(),
      onDismissed: (direction) => _onItemDismissed(direction, context, prep, scopedOpDay),
      child: InkWell(
        onTap: () {
          //TODO: on tap
        },
        child: _renderItemContent(prep)
      )
    );
  }

  Widget _renderItemContent(DayPrep prep) {
    List<Widget> textWidgets = List();

    //TODO: populate content - instructions, inputs, tools
    textWidgets.add(Text(prep.recipeStep.instruction));

    return Container(
      padding: PrepStyles.listItemPadding,
      child: Wrap(
        children: textWidgets
      )
    );
  }

  Future<bool> _canDismissItem(DismissDirection direction, DayPrep prep) {
    //swipe right 
    if (direction == DismissDirection.startToEnd) {
      final isNotDone = prep.madeQty == null || 
        prep.madeQty < prep.expectedQty;
      return Future.value(isNotDone);
    //swipe left
    } else if (direction == DismissDirection.endToStart) {
      final isStarted = prep.madeQty != null;
      return Future.value(isStarted);
    } else {
      return Future.value(false);
    }
  }

  void _onItemDismissed(DismissDirection direction, BuildContext context, DayPrep prep, ScopedOpDay scopedOpDay) {
    final originalQty = prep.madeQty;
    //swipe right 
    if (direction == DismissDirection.startToEnd) {
      //TODO: update to done
      _notifyQtyUpdate("Prep done", context, prep, scopedOpDay, originalQty);
    //swipe right
    } else if (direction == DismissDirection.endToStart) {
      //TODO: update to not started
      _notifyQtyUpdate("Prep not started", context, prep, scopedOpDay, originalQty);
    } 
  }

  void _notifyQtyUpdate(String notificationText, BuildContext context, DayPrep prep,
    ScopedOpDay scopedOpDay, double originalQty) {
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
        child: Text("Undo", style: Styles.textHyperlink)
      )
    )..show(context);
  }
}
import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

/// makes the child able to swipe left and right
///
/// child and onSwipeRight required
class Swipable extends StatelessWidget {
  final Future<bool> Function() canSwipeLeft;
  final Future<bool> Function() canSwipeRight;
  final void Function(BuildContext context) onSwipeLeft;
  final void Function(BuildContext context) onSwipeRight;
  final Color swipeLeftColor;
  final Color swipeRightColor;

  final Widget child;

  Swipable(
      {this.canSwipeLeft,
      this.canSwipeRight,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.swipeLeftColor,
      this.swipeRightColor,
      this.child})
      : assert(onSwipeRight != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background:
            Container(color: this.swipeRightColor ?? Styles.swipeRightColor),
        secondaryBackground: this.onSwipeLeft != null
            ? Container(color: this.swipeLeftColor ?? Styles.swipeLeftColor)
            : null,
        confirmDismiss: (direction) => _canDismissItem(direction),
        key: UniqueKey(),
        onDismissed: (direction) => _onItemDismissed(direction, context),
        child: this.child);
  }

  Future<bool> _canDismissItem(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      if (this.canSwipeRight != null) {
        return this.canSwipeRight();
      } else {
        return Future.value(true);
      }
    } else if (direction == DismissDirection.endToStart) {
      if (this.canSwipeLeft != null) {
        return this.canSwipeLeft();
      } else if (this.onSwipeLeft != null) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } else {
      return Future.value(false);
    }
  }

  void _onItemDismissed(DismissDirection direction, BuildContext context) {
    if (direction == DismissDirection.startToEnd) {
      this.onSwipeRight(context);
    } else if (direction == DismissDirection.endToStart &&
        this.onSwipeLeft != null) {
      this.onSwipeLeft(context);
    }
  }
}

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kitchen/screens/story/components/story_item.dart';
import '../story_styles.dart';

class StoryItemsIndicator extends StatelessWidget {
  final List<StoryItem> items;

  StoryItemsIndicator(this.items);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((it) {
        return Expanded(
          child: Container(
              padding: EdgeInsets.only(
                  right: items.last == it ? 0 : StoryStyles.indicatorSpacing),
              child: _renderBar(context, it)),
        );
      }).toList(),
    );
  }

  Widget _renderBar(BuildContext context, StoryItem it) {
    return Container(
      height: StoryStyles.indicatorHeightPageBar,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StoryStyles.indicatorEdgeRadius),
        shape: BoxShape.rectangle,
        color: items.last == it
            ? StoryStyles.currentPageBarColor
            : StoryStyles.defaultPageBarColor,
      ),
    );
  }
}

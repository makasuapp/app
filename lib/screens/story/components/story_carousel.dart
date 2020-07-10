import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/screens/story/components/story_items_indicator.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';

import '../story_styles.dart';

class StoryCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _renderView(context, scopedStory)));
  }

  Widget _renderView(BuildContext context, ScopedStory scopedStory) {
    return Stack(children: [
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderIndicatorBars(scopedStory),
            Expanded(child: _renderContent(scopedStory))
          ]),
      _renderBackTap(scopedStory),
    ]);
  }

  Widget _renderContent(ScopedStory scopedStory) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: scopedStory.currentItem)]),
        padding: Styles.spacerPadding);
  }

  Widget _renderBackTap(ScopedStory scopedStory) {
    return Align(
        alignment: Alignment.centerLeft,
        heightFactor: 1,
        child: SizedBox(
            width: 70, child: GestureDetector(onTap: () => scopedStory.pop())));
  }

  Widget _renderIndicatorBars(ScopedStory scopedStory) {
    return Container(
      child: StoryItemsIndicator(scopedStory.storyItems),
      padding: StoryStyles.paddingProgressBar,
    );
  }
}

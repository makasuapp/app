import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';

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
    return Stack(
        children: [_renderContent(scopedStory), _renderBackTap(scopedStory)]);
  }

  Widget _renderContent(ScopedStory scopedStory) {
    return Column(children: [
      _renderBackIndicator(scopedStory),
      Expanded(child: scopedStory.currentItem)
    ]);
  }

  //we can make this a bar like instagram instead
  Widget _renderBackIndicator(ScopedStory scopedStory) {
    if (scopedStory.storyItems.length > 1) {
      return Row(children: [
        Icon(Icons.arrow_back_ios),
        Text((scopedStory.storyItems.length - 1).toString())
      ]);
    } else {
      return Container();
    }
  }

  Widget _renderBackTap(ScopedStory scopedStory) {
    return Align(
        alignment: Alignment.centerLeft,
        heightFactor: 1,
        child: SizedBox(
            width: 70, child: GestureDetector(onTap: () => scopedStory.pop())));
  }
}

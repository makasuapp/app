import 'package:flutter/material.dart';
import '../story_styles.dart';

abstract class StoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //common layouting for stories goes here
    return SingleChildScrollView(
        child: Container(
            padding: StoryStyles.itemPadding, child: renderContent()));
  }

  Widget renderContent();
}

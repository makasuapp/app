import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:scoped_model/scoped_model.dart';
import '../story_styles.dart';

abstract class StoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //common layouting for stories goes here
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) => SingleChildScrollView(
              child: Container(
                padding: StoryStyles.itemPadding,
                child: renderContent(),
              ),
            ));
  }

  Widget renderContent();
}

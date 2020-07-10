import 'package:flutter/material.dart';

abstract class StoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //common layouting for stories goes here
    return SingleChildScrollView(child: renderContent());
  }

  Widget renderContent();
}

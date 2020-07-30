import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../common/adjust_quantity.dart';
import '../story_styles.dart';

abstract class StoryItem extends StatelessWidget {
  final String displayedUnits;
  final double servingSize;

  StoryItem(this.displayedUnits, this.servingSize);

  Widget renderContent();

  StoryItem getUpdatedStoryItem(String outputUnits, double servingSize);

  bool hasVolumeWeightRatio();

  @override
  Widget build(BuildContext context) {
    //common layouting for stories goes here
    return ScopedModelDescendant<ScopedStory>(
        builder: (context, child, scopedStory) {
      return SingleChildScrollView(
        child: Container(
          padding: StoryStyles.itemPadding,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderServings(context, scopedStory),
                this.renderContent()
              ]),
        ),
      );
    });
  }

  _renderServings(BuildContext context, ScopedStory scopedStory) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AdjustQuantityPage(
                      title: "Adjust Servings",
                      canConvertAllUnits: this.hasVolumeWeightRatio(),
                      initQty: this.servingSize,
                      initUnit: this.displayedUnits,
                      onSubmit: (double newQty, String newUnits,
                          BuildContext qtyViewContext) {
                        scopedStory.updateStory(
                            this.getUpdatedStoryItem(newUnits, newQty));
                        Navigator.pop(qtyViewContext);
                      });
                }));
              },
              child: Text(
                "Serving Size: ${UnitConverter.qtyWithUnit(this.servingSize, this.displayedUnits, convertUp: false)}",
                style: StoryStyles.storyText,
              ),
            )
          ]),
    );
  }
}

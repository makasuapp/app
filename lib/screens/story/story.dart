import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_story.dart';
import 'package:kitchen/scoped_models/scoped_data.dart';
import 'components/story_item.dart';
import 'components/story_carousel.dart';
import '../common/transparent_route.dart';
import '../../service_locator.dart';
import './story_styles.dart';

class StoryView extends StatelessWidget {
  final StoryItem initStory;

  StoryView(this.initStory);

  //TODO: why isn't the pulldown showing the previous page?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScopedModel<ScopedStory>(
            model: ScopedStory(this.initStory),
            child: ScopedModel<ScopedData>(
                model: locator<ScopedData>(),
                child: SafeArea(
                    child: Dismissible(
                        background:
                            Container(color: StoryStyles.pulldownBackground),
                        key: Key('Story'),
                        direction: DismissDirection.down,
                        onDismissed: (_) => Navigator.pop(context),
                        child: Column(children: [
                          _renderClose(context),
                          Expanded(child: StoryCarousel())
                        ]))))));
  }

  Widget _renderClose(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.close, color: Colors.black)));
  }

  static render(BuildContext context, StoryItem initStory) {
    return Navigator.of(context)
        .push(TransparentRoute(builder: (_) => StoryView(initStory)));
  }
}

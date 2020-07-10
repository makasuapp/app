import 'package:scoped_model/scoped_model.dart';
import '../screens/story/components/story_item.dart';

class ScopedStory extends Model {
  List<StoryItem> storyItems = [];
  StoryItem currentItem;

  ScopedStory(StoryItem initItem) {
    push(initItem);
  }

  void push(StoryItem nextItem) {
    this.storyItems.add(nextItem);
    this.currentItem = nextItem;
    notifyListeners();
  }

  void pop() {
    if (this.storyItems.length > 1) {
      this.storyItems.removeLast();
      this.currentItem = this.storyItems.last;
      notifyListeners();
    }
  }
}

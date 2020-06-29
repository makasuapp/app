import 'package:flutter/material.dart';
import '../morning/morning.dart';
import '../prep/prep.dart';
import 'package:kitchen/styles.dart';

class Action {
  final int id;
  final String title;
  final Widget Function() createPage;

  Action(this.title, this.createPage, this.id);
}

class ActionsPage extends StatelessWidget {
  static final List<Action> actions = [
    Action("Morning Checklist", () => MorningChecklistPage(0), 0),
    Action("Prep Checklist", () => PrepChecklistPage(1), 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Actions")),
        body: ListView.builder(
            itemCount: ActionsPage.actions.length,
            itemBuilder: _actionListBuilder));
  }

  Widget _actionListBuilder(BuildContext context, int index) {
    final action = actions[index];
    return ListTile(
        title: _actionTitle(action),
        onTap: () => _navToActionPage(context, action));
  }

  Widget _actionTitle(Action action) {
    return Text(action.title, style: Styles.headerLarge);
  }

  void _navToActionPage(BuildContext context, Action action) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => action.createPage()));
  }
}

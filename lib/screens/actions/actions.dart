import 'package:flutter/material.dart';
import 'package:kitchen/firebase_messaging/firebase_messaging_handler.dart';
import '../morning/morning.dart';
import '../prep/prep.dart';
import '../orders/upcoming_orders.dart';
import '../procurement/shopping.dart';
import 'package:kitchen/styles.dart';

class Action {
  final int id;
  final String title;
  final Widget Function(int, String) createPageFunc;

  Action(this.id, this.title, this.createPageFunc);

  Widget createPage() {
    return this.createPageFunc(this.id, this.title);
  }
}

class ActionsPage extends StatelessWidget {
  static final List<Action> actions = [
    Action(0, "Morning Checklist", (id, t) => MorningChecklistPage(id, t)),
    Action(1, "Prep Checklist", (id, t) => PrepChecklistPage(id, t)),
    Action(2, "Upcoming Orders", (id, t) => UpcomingOrdersPage(id, t)),
    Action(3, "Shopping Lists", (id, t) => ShoppingListsPage(id, t))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Actions")),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: ActionsPage.actions.length,
                  itemBuilder: _actionListBuilder)),
          FirebaseMessagingHandler(context)
        ]));
  }

  Widget _actionListBuilder(BuildContext context, int index) {
    final action = ActionsPage.actions[index];
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

import 'package:flutter/material.dart';
import 'package:kitchen/screens/ingredients/ingredients.dart';
import 'package:kitchen/screens/orders/upcoming_orders.dart';
import 'package:kitchen/screens/prep/prep.dart';
import 'package:kitchen/screens/procurement/shopping.dart';
import 'package:kitchen/styles.dart';

class Action {
  final String title;
  final String route;

  Action(this.title, this.route);
}

final List<Action> actionsList = [
  Action("Ingredients Checklist", IngredientsChecklistPage.routeName),
  Action("Prep Checklist", PrepChecklistPage.routeName),
  Action("Upcoming Orders", UpcomingOrdersPage.routeName),
  Action("Shopping Lists", ShoppingListsPage.routeName)
];

class ActionsPage extends StatelessWidget {
  static const routeName = '/actions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Actions")),
        body: ListView.builder(
            itemCount: actionsList.length, itemBuilder: _actionListBuilder));
  }

  Widget _actionListBuilder(BuildContext context, int index) {
    final action = actionsList[index];
    return ListTile(
        title: _actionTitle(action),
        onTap: () => _navToActionPage(context, action));
  }

  Widget _actionTitle(Action action) {
    return Text(action.title, style: Styles.headerLarge);
  }

  void _navToActionPage(BuildContext context, Action action) {
    Navigator.pushNamed(context, action.route);
  }
}

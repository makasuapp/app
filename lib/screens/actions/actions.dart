import 'package:flutter/material.dart';
import '../inventory/inventory.dart';
import 'package:kitchen/styles.dart';

class Action {
  final String title;
  final Widget Function() createPage;
  Action(this.title, this.createPage);
}

class ActionsPage extends StatelessWidget {
  final List<Action> actions = [
    Action("Inventory Checklist", () => InventoryPage())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Actions")),
      body: ListView.builder(
        itemCount: this.actions.length,
        itemBuilder: _actionListBuilder
      )
    );
  }

  Widget _actionListBuilder(BuildContext context, int index) {
    final action = this.actions[index];
    return ListTile(
      title: _actionTitle(action),
      onTap: () => _navToActionPage(context, action)
    );
  }

  Widget _actionTitle(Action action) {
    return Text(action.title, style: Styles.headerLarge);
  }

  void _navToActionPage(BuildContext context, Action action) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => action.createPage()
      )
    );
  }
}
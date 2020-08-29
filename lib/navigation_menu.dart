import 'package:flutter/material.dart';
import 'package:kitchen/screens/actions/actions.dart';
import 'package:kitchen/styles.dart';

class NavigationMenu extends StatelessWidget {
  static final actions = ActionsPage.actions;
  final int pageSelected;

  NavigationMenu(this.pageSelected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView.builder(
      itemCount: actions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text(actions[index].title,
                style: (this.pageSelected == actions[index].id)
                    ? Styles.textDefaultHighlighted
                    : Styles.textDefault),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: actions[index].title),
                      builder: (context) => actions[index].createPage()));
            });
      },
    ));
  }
}

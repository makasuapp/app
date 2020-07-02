import 'package:flutter/material.dart';
import 'package:kitchen/screens/actions/actions.dart';
import 'package:kitchen/styles.dart';

class NavigationMenu {
  static final actions = ActionsPage.actions;

  static Drawer navigationDrawer(int pageSelected) {
    return new Drawer(
        child: ListView.builder(
      itemCount: actions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text(actions[index].title,
                style: (pageSelected == actions[index].id)
                    ? Styles.textDefaultHighlighted
                    : Styles.textDefault),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => actions[index].createPage()));
            });
      },
    ));
  }
}

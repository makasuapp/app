import 'package:flutter/material.dart';
import 'package:kitchen/screens/dashboard/actions.dart';
import 'package:kitchen/styles.dart';

class NavigationMenu extends StatelessWidget {
  final String pageSelected;

  NavigationMenu(this.pageSelected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView.builder(
      itemCount: actionsList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text(actionsList[index].title,
                style: (this.pageSelected == actionsList[index].route)
                    ? Styles.textDefaultHighlighted
                    : Styles.textDefault),
            onTap: () =>
                Navigator.pushNamed(context, actionsList[index].route));
      },
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';
import '../common/components/link_text.dart';

class UnauthorizedPage extends StatelessWidget {
  static const routeName = '/unauthorized';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: Styles.defaultPaddings,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          "Unauthorized. Please launch the app with a valid link or visit ",
                      style: Styles.textDefault),
                  LinkText("www.makasu.co", "https://www.makasu.co").build(),
                  TextSpan(text: " to learn more.", style: Styles.textDefault)
                ])))));
  }
}

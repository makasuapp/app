import 'package:flutter/material.dart';
import 'package:kitchen/screens/dashboard/auth.dart';
import 'package:kitchen/services/dynamic_links.dart';
import 'package:kitchen/services/firebase_messaging/firebase_messaging_handler.dart';
import 'package:kitchen/styles.dart';

class LaunchPage extends StatefulWidget {
  static const routeName = '/launch';

  @override
  State<StatefulWidget> createState() {
    return _LaunchPageState();
  }
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();

    FirebaseMessagingHandler.init(context);

    //links has to get initialized last since it might redirect the page..?
    DynamicLinks.init(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, AuthPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    //swap with a splash screen?
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          CircularProgressIndicator(),
          Text("Loading...", style: Styles.textDefault)
        ])));
  }
}

import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'package:kitchen/screens/dashboard/unauthorized.dart';
import 'package:kitchen/service_locator.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:kitchen/services/firebase_messaging/firebase_messaging_handler.dart';
import 'package:kitchen/styles.dart';
import 'actions.dart';

//if ever unauthorized request, should come back to this page
class AuthPage extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    checkCredentials();
  }

  void checkCredentials() async {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    final scopedUser = locator<ScopedUser>();

    String token;
    int kitchenId;

    //initialize from args
    if (args != null && args['kitchen'] != null) {
      token = args['token'];
      kitchenId = int.parse(args['kitchen']);
    }

    if (kitchenId == null) {
      kitchenId = await scopedUser.getKitchenId();
      token = await scopedUser.getKitchenToken();
    }

    if (kitchenId == null) {
      this.setUnauthorized();
    } else {
      final api = locator<WebApi>();
      try {
        final resp = await api.postVerifyUser(kitchenId, token);

        scopedUser.setFromResponse(resp);
        await scopedUser.setKitchenId(kitchenId);
        await scopedUser.setKitchenToken(token);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FirebaseMessagingHandler.subscribeToTopics(kitchenId);
          Navigator.pushNamed(context, ActionsPage.routeName);
        });
      } catch (_) {
        this.setUnauthorized();
      }
    }
  }

  void setUnauthorized() async {
    final scopedUser = locator<ScopedUser>();
    await scopedUser.clear();

    Navigator.pushNamed(this.context, UnauthorizedPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          CircularProgressIndicator(),
          Text("Authorizing...", style: Styles.textDefault)
        ])));
  }
}

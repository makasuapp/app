import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
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
    await scopedUser.initDb();

    String token;
    int kitchenId;

    //initialize from args
    if (args != null && args['kitchen'] != null) {
      token = args['token'];
      kitchenId = int.parse(args['kitchen']);
    }

    if (kitchenId == null) {
      kitchenId = scopedUser.getKitchenId();
      token = scopedUser.getKitchenToken();
    }

    if (kitchenId == null) {
      this.setUnauthorized();
    } else {
      final api = locator<WebApi>();
      try {
        final resp = await api.postVerifyUser(kitchenId, token);

        scopedUser.setFromResponse(resp);
        scopedUser.setKitchenId(kitchenId);
        scopedUser.setKitchenToken(token);

        //can now load orders for the authed kitchen
        final scopedOrder = locator<ScopedOrder>();
        await scopedOrder.loadOrders(kitchenId);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FirebaseMessagingHandler.subscribeToTopics(kitchenId);
          Navigator.pushNamed(context, ActionsPage.routeName);
        });
      } catch (_) {
        this.setUnauthorized();
      }
    }
  }

  void setUnauthorized() {
    final scopedUser = locator<ScopedUser>();
    scopedUser.clear();

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

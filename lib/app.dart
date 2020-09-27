import 'package:flutter/material.dart';
import 'package:kitchen/screens/dashboard/auth.dart';
import 'package:kitchen/screens/dashboard/unauthorized.dart';
import 'package:kitchen/screens/morning/morning.dart';
import 'package:kitchen/screens/orders/order_details.dart';
import 'package:kitchen/screens/orders/upcoming_orders.dart';
import 'package:kitchen/screens/prep/prep.dart';
import 'package:kitchen/screens/procurement/shopping.dart';
import 'package:kitchen/screens/procurement/shopping_list.dart';
import 'screens/dashboard/actions.dart';
import 'screens/dashboard/launch.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'service_locator.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LaunchPage.routeName,
      routes: {
        LaunchPage.routeName: (_) => LaunchPage(),
        AuthPage.routeName: (_) => AuthPage(),
        UnauthorizedPage.routeName: (_) => UnauthorizedPage(),
        ActionsPage.routeName: (_) => ActionsPage(),
        MorningChecklistPage.routeName: (_) => MorningChecklistPage(),
        PrepChecklistPage.routeName: (_) => PrepChecklistPage(),
        UpcomingOrdersPage.routeName: (_) => UpcomingOrdersPage(),
        OrderDetailsPage.routeName: (context) {
          final OrderDetailsArguments args =
              ModalRoute.of(context).settings.arguments;
          return OrderDetailsPage(args.orderId);
        },
        ShoppingListsPage.routeName: (_) => ShoppingListsPage(),
        ShoppingListPage.routeName: (context) {
          final ShoppingListArguments args =
              ModalRoute.of(context).settings.arguments;
          return ShoppingListPage(args.orderId);
        }
      },
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: locator<FirebaseAnalytics>()),
      ],
    );
  }
}

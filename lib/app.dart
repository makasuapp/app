import 'package:flutter/material.dart';
import 'screens/actions/actions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'service_locator.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ActionsPage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: locator<FirebaseAnalytics>()),
      ],
    );
  }
}

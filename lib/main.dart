import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app.dart';
import './service_locator.dart';
import './scoped_models/scoped_order.dart';

Future<dynamic> handleBackgroundMessage(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }

  return Future.value();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  //throw this in a splash screen?
  final scopedOrder = locator<ScopedOrder>();
  await scopedOrder.loadOrders();

  //how should this be organized?
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions();
  _firebaseMessaging.configure(
      onMessage: (message) {
        print("onMessage: $message");
        return Future.value();
      },
      onBackgroundMessage: handleBackgroundMessage,
      onResume: (message) {
        print("onResume: $message");
        return Future.value();
      },
      onLaunch: (message) {
        print("onLaunch: $message");
        return Future.value();
      });
  //when we move to multi-kitchen, this will subscribe to just the kitchen's topic
  _firebaseMessaging.subscribeToTopic("orders");

  runApp(App());
}

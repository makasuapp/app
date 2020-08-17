import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kitchen/models/order.dart';
import 'app.dart';
import './service_locator.dart';
import './scoped_models/scoped_order.dart';
import 'firebase_messaging/firebase_messaging_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  //throw this in a splash screen?
  final scopedOrder = locator<ScopedOrder>();
  await scopedOrder.loadOrders();

  FirebaseMessagingHandler.handleMessages();

  runApp(App());
}

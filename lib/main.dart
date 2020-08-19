import 'dart:convert';

import 'package:flutter/material.dart';
import 'app.dart';
import './service_locator.dart';
import './scoped_models/scoped_order.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //throw this in a splash screen?
  setupLocator();
  final scopedOrder = locator<ScopedOrder>();
  await scopedOrder.loadOrders();

  runApp(App());
}

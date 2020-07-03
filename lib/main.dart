import 'package:flutter/material.dart';
import 'app.dart';
import './service_locator.dart';
import './scoped_models/scoped_order.dart';

void main() async {
  setupLocator();

  //throw this in a splash screen?
  final scopedOrder = locator<ScopedOrder>();
  await scopedOrder.loadOrders();

  runApp(App());
}

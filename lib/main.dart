import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import './service_locator.dart';
import './scoped_models/scoped_order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //throw these in launch.dart initState? how do these when there's await?
  setupLocator();
  final scopedOrder = locator<ScopedOrder>();
  await scopedOrder.loadOrders();

  await Hive.initFlutter();

  runApp(App());
}

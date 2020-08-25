import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kitchen/api/ingredient_update.dart';
import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kitchen/services/hive_db_helper.dart';
import 'app.dart';
import './service_locator.dart';
import './scoped_models/scoped_order.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //throw this in a splash screen?
  setupLocator();
  final scopedOrder = locator<ScopedOrder>();
  await scopedOrder.loadOrders();

  await Hive.initFlutter();
  (await Hive.openBox(HiveDbValues.unsavedIngredientUpdates)).put(HiveDbValues.unsavedIngredientUpdates, List<Map<String, dynamic>>());
  var box = await Hive.openBox("trial");
  box.putAll({"kitchen_id": 1, "name":"fake_name", "key":"secret_key"});

  print("kitchen id: ${box.get("kitchen_id")} name: ${box.get("name")} key: ${box.get("key")}");

  runApp(App());
}

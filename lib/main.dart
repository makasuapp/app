import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  //throw this in launch.dart initState? how do when there's await?
  await Hive.initFlutter();

  runApp(App());
}

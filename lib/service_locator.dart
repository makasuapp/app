import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'services/web_api.dart';
import 'scoped_models/scoped_day_input.dart';
import 'scoped_models/scoped_day_prep.dart';
import 'scoped_models/scoped_op_day.dart';
import 'scoped_models/scoped_order.dart';
import 'scoped_models/scoped_lookup.dart';
import 'scoped_models/scoped_procurement.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<WebApi>(() => WebApi());
  locator.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics());
  locator.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging());

  locator.registerLazySingleton<ScopedDayInput>(() => ScopedDayInput());
  locator.registerLazySingleton<ScopedDayPrep>(() => ScopedDayPrep());
  locator.registerLazySingleton<ScopedOpDay>(() => ScopedOpDay());
  locator.registerLazySingleton<ScopedOrder>(() => ScopedOrder());
  locator.registerLazySingleton<ScopedLookup>(() => ScopedLookup());
  locator.registerLazySingleton<ScopedProcurement>(() => ScopedProcurement());
  locator.registerLazySingleton<ScopedUser>(() => ScopedUser());
}

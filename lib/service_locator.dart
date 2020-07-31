import 'package:get_it/get_it.dart';
import 'services/web_api.dart';
import 'scoped_models/scoped_day_ingredient.dart';
import 'scoped_models/scoped_day_prep.dart';
import 'scoped_models/scoped_op_day.dart';
import 'scoped_models/scoped_order.dart';
import 'scoped_models/scoped_lookup.dart';
import 'scoped_models/scoped_procurement.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<WebApi>(() => WebApi());

  locator
      .registerLazySingleton<ScopedDayIngredient>(() => ScopedDayIngredient());
  locator.registerLazySingleton<ScopedDayPrep>(() => ScopedDayPrep());
  locator.registerLazySingleton<ScopedOpDay>(() => ScopedOpDay());
  locator.registerLazySingleton<ScopedOrder>(() => ScopedOrder());
  locator.registerLazySingleton<ScopedLookup>(() => ScopedLookup());
  locator.registerLazySingleton<ScopedProcurement>(() => ScopedProcurement());
}

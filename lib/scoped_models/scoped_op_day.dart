import 'dart:convert';
import 'scoped_api_model.dart';
import './scoped_day_ingredient.dart';
import './scoped_day_prep.dart';
import '../models/op_day.dart';
import '../services/web_api.dart';
import '../service_locator.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedOpDay extends ScopedApiModel {
  ScopedDayIngredient scopedDayIngredient;
  ScopedDayPrep scopedDayPrep;

  ScopedOpDay(
      {ScopedDayIngredient scopedDayIngredient,
      ScopedDayPrep scopedDayPrep,
      WebApi api})
      : super(api: api) {
    this.scopedDayIngredient =
        scopedDayIngredient ?? locator<ScopedDayIngredient>();
    this.scopedDayPrep = scopedDayPrep ?? locator<ScopedDayPrep>();
  }

  Future<void> loadOpDay({forceLoad = false}) async {
    loadData(() async {
      final opDay = await _fetchOpDay();

      this.scopedDayIngredient.addFetched(opDay.ingredients);
      this.scopedDayPrep.addFetched(opDay.prep);
    }, forceLoad: forceLoad);
  }

  Future<OpDay> _fetchOpDay() async {
    final opDayJson = await this.api.fetchOpDayJson();

    return OpDay.fromJson(json.decode(opDayJson));
  }
}

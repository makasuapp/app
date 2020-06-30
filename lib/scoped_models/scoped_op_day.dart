import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import './scoped_day_ingredient.dart';
import './scoped_day_prep.dart';
import '../models/op_day.dart';
import '../services/web_api.dart';
import '../service_locator.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedOpDay extends Model {
  ScopedDayIngredient scopedDayIngredient;
  ScopedDayPrep scopedDayPrep;
  bool isLoading = false;
  WebApi api;

  DateTime _lastLoaded;

  ScopedOpDay({scopedDayIngredient, scopedDayPrep, api}) {
    this.api = api ?? locator<WebApi>();
    this.scopedDayIngredient = scopedDayIngredient ?? locator<ScopedDayIngredient>();
    this.scopedDayPrep = scopedDayPrep ?? locator<ScopedDayPrep>();
  }

  Future<void> loadOpDay({forceLoad = false}) async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    if (forceLoad || this._lastLoaded == null ||
      this._lastLoaded.millisecondsSinceEpoch < lastMidnight.millisecondsSinceEpoch
    ) {
      this.isLoading = true;
      notifyListeners();

      final opDay = await _fetchOpDay();

      this.scopedDayIngredient.addFetched(opDay.ingredients);
      this.scopedDayPrep.addFetched(opDay.prep);
      this.isLoading = false;
      notifyListeners();

      this._lastLoaded = now;
    }
  }

  Future<OpDay> _fetchOpDay() async {
    final opDayJson = await this.api.fetchOpDayJson();

    return OpDay.fromJson(json.decode(opDayJson));
  }
}
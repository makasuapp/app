import 'dart:convert';
import 'scoped_api_model.dart';
import 'scoped_day_input.dart';
import './scoped_day_prep.dart';
import '../models/op_day.dart';
import '../services/web_api.dart';
import '../service_locator.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedOpDay extends ScopedApiModel {
  ScopedDayInput scopedDayInput;
  ScopedDayPrep scopedDayPrep;

  ScopedOpDay(
      {ScopedDayInput scopedDayInput, ScopedDayPrep scopedDayPrep, WebApi api})
      : super(api: api) {
    this.scopedDayInput = scopedDayInput ?? locator<ScopedDayInput>();
    this.scopedDayPrep = scopedDayPrep ?? locator<ScopedDayPrep>();
  }

  Future<void> loadOpDay(int kitchenId, {forceLoad = false}) async {
    loadData(() async {
      final opDay = await _fetchOpDay(kitchenId);

      this.scopedDayInput.addFetched(opDay.inputs);
      this.scopedDayPrep.addFetched(opDay.prep);
    }, forceLoad: forceLoad);
  }

  Future<OpDay> _fetchOpDay(int kitchenId) async {
    final opDayJson = await this.api.fetchOpDayJson(kitchenId);

    return OpDay.fromJson(json.decode(opDayJson));
  }
}

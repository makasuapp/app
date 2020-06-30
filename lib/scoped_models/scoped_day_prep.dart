import 'package:scoped_model/scoped_model.dart';
import '../models/day_prep.dart';
import '../services/web_api.dart';
import '../models/prep_update.dart';
import 'package:meta/meta.dart';
import '../service_locator.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedDayPrep extends Model {
  List<DayPrep> prep; 
  WebApi api;

  @visibleForTesting
  List<PrepUpdate> unsavedUpdates; 
  @visibleForTesting
  int savingAtSec;
  @visibleForTesting
  int retryCount = 0;

  ScopedDayPrep({ingredients, prep, api, unsavedUpdates}) {
    this.unsavedUpdates = unsavedUpdates ?? []; 
    this.prep = prep ?? [];
    this.api = api ?? locator<WebApi>();
  }

  Future<void> addFetched(List<DayPrep> fetchedPrep) async {
    this.prep = _mergePrep(fetchedPrep);
    notifyListeners();
  }

  //if we want to persist to db, then we'll also want to merge db entries here
  List<DayPrep> _mergePrep(List<DayPrep> newPrep) {
    if (this.unsavedUpdates.length == 0) {
      return newPrep;
    }

    var prepMap = Map<int, DayPrep>();
    newPrep.forEach((p) { 
      prepMap[p.id] = p;
    });

    this.unsavedUpdates.forEach((update) {
      final prep = prepMap[update.dayPrepId];
      if (prep.qtyUpdatedAtSec == null || update.timeSec > prep.qtyUpdatedAtSec) {
        prep.madeQty = update.madeQty;
        prep.qtyUpdatedAtSec = update.timeSec;
      }

      prepMap[prep.id] = prep;
    });

    return prepMap.values.toList();
  }
}
import 'package:scoped_model/scoped_model.dart';
import '../models/day_input.dart';
import '../services/web_api.dart';
import '../api/input_update.dart';
import 'package:meta/meta.dart';
import '../service_locator.dart';
import '../services/logger.dart';
import 'scoped_lookup.dart';

const SAVE_BUFFER_SECONDS = 15;
const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedDayInput extends Model {
  List<DayInput> inputs;
  WebApi api;
  static ScopedLookup _scopedLookup = locator<ScopedLookup>();

  @visibleForTesting
  List<InputUpdate> unsavedUpdates;
  @visibleForTesting
  int savingAtSec;
  @visibleForTesting
  int retryCount = 0;
  int _lastUpdateAtSec;

  ScopedDayInput(
      {List<DayInput> inputs,
      WebApi api,
      List<InputUpdate> unsavedUpdates,
      ScopedLookup scopedLookup}) {
    this.unsavedUpdates = unsavedUpdates ?? [];
    this.inputs = inputs ?? [];
    this.api = api ?? locator<WebApi>();

    if (scopedLookup != null) {
      _scopedLookup = scopedLookup;
    }
  }

  void clear() {
    this.inputs = List<DayInput>();
    notifyListeners();
  }

  Future<void> addFetched(List<DayInput> fetchedInputs) async {
    this.inputs = _mergeInputs(fetchedInputs);
    notifyListeners();
  }

  static DayInputable inputableFor(DayInput input) {
    if (input.inputableType == DayInputType.Recipe) {
      return _scopedLookup.getRecipe(input.inputableId);
    } else if (input.inputableType == DayInputType.Ingredient) {
      return _scopedLookup.getIngredient(input.inputableId);
    } else {
      throw Exception("Unexpected inputable type ${input.inputableType}");
    }
  }

  Future<void> updateInputQty(DayInput input, double qty, {int bufferMs}) {
    final updatedInput = DayInput.clone(input, qty, DateTime.now());
    final updatedInputs =
        this.inputs.map((i) => i.id == input.id ? updatedInput : i).toList();

    this.inputs = updatedInputs;
    notifyListeners();

    //want it to happen right away for recipe so we can refresh
    if (input.inputableType == DayInputType.Recipe) {
      return this.saveUnsavedQty();
    } else {
      _asyncPersistInput(updatedInput, bufferMs: bufferMs);
      return Future.value();
    }
  }

  @visibleForTesting
  Future<void> saveUnsavedQty() async {
    if (this.savingAtSec == null) {
      final savingAtSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      this.savingAtSec = savingAtSec;

      try {
        if (this.unsavedUpdates.length > 0) {
          await this.api.postOpDaySaveInputsQty(this.unsavedUpdates);
        }

        this.savingAtSec = null;
        this.retryCount = 0;
        this.unsavedUpdates = this.unsavedUpdates.where((u) {
          return u.timeSec > savingAtSec;
        }).toList();
      } catch (err) {
        Logger.error(err);
        this.savingAtSec = null;
        this._retryLater();
      }
    } else {
      this._retryLater();
    }
  }

  //TODO: should there be a mechanism to end the retries if it's not needed anymore?
  //currently it's okay if it retries unnecessarily, no harm done
  Future<void> _retryLater() async {
    final retryCount = this.retryCount + 1;
    this.retryCount = retryCount;

    final waitTime = RETRY_WAIT_SECONDS * retryCount;
    await Future.delayed(Duration(seconds: waitTime));

    if (retryCount <= NUM_RETRIES) {
      this.saveUnsavedQty();
    } else {
      Logger.error("hit max retries in scoped_day_input");
    }
  }

  //if we want to persist to db, then we'll also want to merge db entries here
  List<DayInput> _mergeInputs(List<DayInput> inputs) {
    if (this.unsavedUpdates.length == 0) {
      return inputs;
    }

    var inputsMap = Map<int, DayInput>();
    inputs.forEach((i) {
      inputsMap[i.id] = i;
    });

    this.unsavedUpdates.forEach((update) {
      final input = inputsMap[update.dayInputId];
      if (input.qtyUpdatedAtSec == null ||
          update.timeSec > input.qtyUpdatedAtSec) {
        input.hadQty = update.hadQty;
        input.qtyUpdatedAtSec = update.timeSec;
      }

      inputsMap[input.id] = input;
    });

    return inputsMap.values.toList();
  }

  void _asyncPersistInput(DayInput input, {int bufferMs}) async {
    this
        .unsavedUpdates
        .add(InputUpdate(input.id, input.hadQty, input.qtyUpdatedAtSec));
    this._lastUpdateAtSec = input.qtyUpdatedAtSec;

    final buffer = bufferMs ?? SAVE_BUFFER_SECONDS * 1000;
    await Future.delayed(Duration(milliseconds: buffer));

    if (this.unsavedUpdates.length > 0 &&
        this.unsavedUpdates.last.timeSec != this._lastUpdateAtSec) {
      return;
    }

    await this.saveUnsavedQty();
  }
}

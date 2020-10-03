import 'package:kitchen/api/input_update.dart';
import 'package:kitchen/models/day_input.dart';
import 'package:kitchen/scoped_models/scoped_day_input.dart';
import 'package:kitchen/services/date_converter.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  test('save qty API', () async {
    final now = DateTime.now();
    var updates = List<InputUpdate>();
    updates.add(InputUpdate.withDate(1, 2.1, now));

    final scopedInput = ScopedDayInput(unsavedUpdates: updates);
    await scopedInput.saveUnsavedQty();
  }, skip: 'run manually for sanity checks');

  test(
      'loadOpDay merges unsavedUpdates with data from API call based on what is updated later',
      () async {
    final now = DateTime.now();
    final hourAgo = now.subtract(Duration(hours: 1));
    final dayAgo = now.subtract(Duration(days: 1));

    var updates = List<InputUpdate>();
    updates.add(InputUpdate.withDate(1, 1.2, hourAgo));
    updates.add(InputUpdate.withDate(1, 0.9, dayAgo));
    updates.add(InputUpdate.withDate(1, 1.4, now));
    updates.add(InputUpdate.withDate(2, 1.5, dayAgo));

    var fetched = List<DayInput>();
    fetched.add(DayInput(1, 1, DayInputType.Ingredient, 2));
    fetched.add(DayInput(2, 2, DayInputType.Ingredient, 2,
        hadQty: 1.8, qtyUpdatedAtSec: DateConverter.toServer(hourAgo)));

    final scopedInput = ScopedDayInput(unsavedUpdates: updates);

    await scopedInput.addFetched(fetched);
    final loaded = scopedInput.inputs;
    expect(loaded[0].id, equals(1));
    expect(loaded[0].hadQty, equals(1.4));
    expect(loaded[0].qtyUpdatedAtSec, equals(DateConverter.toServer(now)));
    expect(loaded[1].id, equals(2));
    expect(loaded[1].hadQty, equals(1.8));
    expect(loaded[1].qtyUpdatedAtSec, equals(DateConverter.toServer(hourAgo)));
  });

  group('updateInputQty', () {
    final input = DayInput(1, 1, DayInputType.Ingredient, 2);
    var init = List<DayInput>();
    init.add(input);
    final api = MockApi();

    test('changes quantity and makes API call to save it after delay',
        () async {
      final scopedInput = ScopedDayInput(api: api, inputs: init);
      expect(scopedInput.inputs[0].hadQty, isNull);
      expect(scopedInput.inputs[0].qtyUpdatedAtSec, isNull);

      var updated = false;
      when(api.postOpDaySaveInputsQty(any)).thenAnswer((_) async {
        expect(scopedInput.savingAtSec, isNotNull);
        updated = true;
      });

      scopedInput.updateInputQty(input, 1.5, bufferMs: 100);
      expect(updated, isFalse);
      await Future.delayed(Duration(milliseconds: 120));

      expect(updated, isTrue);
      expect(scopedInput.inputs[0].hadQty, equals(1.5));
      expect(scopedInput.inputs[0].qtyUpdatedAtSec, isNotNull);
      expect(scopedInput.unsavedUpdates.length, equals(0));
      expect(scopedInput.savingAtSec, isNull);
    });

    test("doesn't make API call if a later update request came in", () async {
      final now = DateTime.now();
      final scopedInput = ScopedDayInput(api: api, inputs: init);

      var updated = false;
      when(api.postOpDaySaveInputsQty(any)).thenAnswer((_) async {
        updated = true;
      });

      scopedInput.updateInputQty(input, 1.5, bufferMs: 100);
      expect(updated, isFalse);
      scopedInput.unsavedUpdates
          .add(InputUpdate.withDate(1, 1.5, now.add(Duration(hours: 1))));
      await Future.delayed(Duration(milliseconds: 120));

      expect(updated, isFalse);
      expect(scopedInput.inputs[0].hadQty, equals(1.5));
      expect(scopedInput.unsavedUpdates.length, equals(2));
      expect(scopedInput.savingAtSec, isNull);
    });

    test("clears unsavedUpdates that have been saved from call", () async {
      final now = DateTime.now();
      final hourAgo = now.subtract(Duration(hours: 1));
      var updates = List<InputUpdate>();
      updates.add(InputUpdate.withDate(1, 1.2, hourAgo));
      updates.add(InputUpdate.withDate(1, 0.9, hourAgo));

      final scopedInput =
          ScopedDayInput(api: api, inputs: init, unsavedUpdates: updates);
      expect(scopedInput.unsavedUpdates.length, equals(2));

      when(api.postOpDaySaveInputsQty(any)).thenAnswer((_) async {
        //after delay async finishes, new request came in before save async finishes
        scopedInput.unsavedUpdates
            .add(InputUpdate.withDate(1, 1.5, now.add(Duration(hours: 1))));
      });

      scopedInput.updateInputQty(input, 1.5, bufferMs: 100);
      await Future.delayed(Duration(milliseconds: 120));

      expect(scopedInput.unsavedUpdates.length, equals(1));
      expect(scopedInput.savingAtSec, isNull);
      expect(scopedInput.unsavedUpdates[0].hadQty, equals(1.5));
    });

    test(
        "doesn't clear unsaved updates if unsuccessful API call (e.g. bad internet connection)",
        () async {
      final now = DateTime.now();
      final hourAgo = now.subtract(Duration(hours: 1));
      var updates = List<InputUpdate>();
      updates.add(InputUpdate.withDate(1, 1.2, hourAgo));
      updates.add(InputUpdate.withDate(1, 0.9, hourAgo));

      final scopedInput =
          ScopedDayInput(api: api, inputs: init, unsavedUpdates: updates);
      expect(scopedInput.unsavedUpdates.length, equals(2));
      expect(scopedInput.retryCount, equals(0));

      when(api.postOpDaySaveInputsQty(any)).thenThrow(Exception("test"));

      scopedInput.updateInputQty(input, 1.5, bufferMs: 100);
      await Future.delayed(Duration(milliseconds: 120));

      expect(scopedInput.unsavedUpdates.length, equals(3));
      expect(scopedInput.savingAtSec, isNull);
      expect(scopedInput.retryCount, equals(1));
    });

    //TODO: test saving when already mid-save - should not run and retry later
  });
}

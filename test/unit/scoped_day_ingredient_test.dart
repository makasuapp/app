import 'package:kitchen/api/ingredient_update.dart';
import 'package:kitchen/models/day_ingredient.dart';
import 'package:kitchen/scoped_models/scoped_day_ingredient.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  test('save qty API', () async {
    final now = DateTime.now();
    var updates = List<IngredientUpdate>();
    updates.add(IngredientUpdate.withDate(1, 2.1, now));

    final scopedIngredient = ScopedDayIngredient(unsavedUpdates: updates);
    await scopedIngredient.saveUnsavedQty();
  }, skip: 'run manually for sanity checks');

  test(
      'loadOpDay merges unsavedUpdates with data from API call based on what is updated later',
      () async {
    final now = DateTime.now();
    final hourAgo = now.subtract(Duration(hours: 1));
    final dayAgo = now.subtract(Duration(days: 1));

    var updates = List<IngredientUpdate>();
    updates.add(IngredientUpdate.withDate(1, 1.2, hourAgo));
    updates.add(IngredientUpdate.withDate(1, 0.9, dayAgo));
    updates.add(IngredientUpdate.withDate(1, 1.4, now));
    updates.add(IngredientUpdate.withDate(2, 1.5, dayAgo));

    var fetched = List<DayIngredient>();
    fetched.add(DayIngredient(1, "test", 2));
    fetched.add(DayIngredient(2, "test", 2,
        hadQty: 1.8, qtyUpdatedAtSec: hourAgo.millisecondsSinceEpoch ~/ 1000));

    final scopedIngredient = ScopedDayIngredient(unsavedUpdates: updates);

    await scopedIngredient.addFetched(fetched);
    final loaded = scopedIngredient.ingredients;
    expect(loaded[0].id, equals(1));
    expect(loaded[0].hadQty, equals(1.4));
    expect(
        loaded[0].qtyUpdatedAtSec, equals(now.millisecondsSinceEpoch ~/ 1000));
    expect(loaded[1].id, equals(2));
    expect(loaded[1].hadQty, equals(1.8));
    expect(loaded[1].qtyUpdatedAtSec,
        equals(hourAgo.millisecondsSinceEpoch ~/ 1000));
  });

  group('updateIngredientQty', () {
    final ingredient = DayIngredient(1, "test", 2);
    var init = List<DayIngredient>();
    init.add(ingredient);
    final api = MockApi();

    test('changes quantity and makes API call to save it after delay',
        () async {
      final scopedIngredient = ScopedDayIngredient(api: api, ingredients: init);
      expect(scopedIngredient.ingredients[0].hadQty, isNull);
      expect(scopedIngredient.ingredients[0].qtyUpdatedAtSec, isNull);

      var updated = false;
      when(api.postOpDaySaveIngredientsQty(any)).thenAnswer((_) async {
        expect(scopedIngredient.savingAtSec, isNotNull);
        updated = true;
      });

      scopedIngredient.updateIngredientQty(ingredient, 1.5, bufferMs: 100);
      expect(updated, isFalse);
      await Future.delayed(Duration(milliseconds: 120));

      expect(updated, isTrue);
      expect(scopedIngredient.ingredients[0].hadQty, equals(1.5));
      expect(scopedIngredient.ingredients[0].qtyUpdatedAtSec, isNotNull);
      expect(scopedIngredient.unsavedUpdates.length, equals(0));
      expect(scopedIngredient.savingAtSec, isNull);
    });

    test("doesn't make API call if a later update request came in", () async {
      final now = DateTime.now();
      final scopedIngredient = ScopedDayIngredient(api: api, ingredients: init);

      var updated = false;
      when(api.postOpDaySaveIngredientsQty(any)).thenAnswer((_) async {
        updated = true;
      });

      scopedIngredient.updateIngredientQty(ingredient, 1.5, bufferMs: 100);
      expect(updated, isFalse);
      scopedIngredient.unsavedUpdates
          .add(IngredientUpdate.withDate(1, 1.5, now.add(Duration(hours: 1))));
      await Future.delayed(Duration(milliseconds: 120));

      expect(updated, isFalse);
      expect(scopedIngredient.ingredients[0].hadQty, equals(1.5));
      expect(scopedIngredient.unsavedUpdates.length, equals(2));
      expect(scopedIngredient.savingAtSec, isNull);
    });

    test("clears unsavedUpdates that have been saved from call", () async {
      final now = DateTime.now();
      final hourAgo = now.subtract(Duration(hours: 1));
      var updates = List<IngredientUpdate>();
      updates.add(IngredientUpdate.withDate(1, 1.2, hourAgo));
      updates.add(IngredientUpdate.withDate(1, 0.9, hourAgo));

      final scopedIngredient = ScopedDayIngredient(
          api: api, ingredients: init, unsavedUpdates: updates);
      expect(scopedIngredient.unsavedUpdates.length, equals(2));

      when(api.postOpDaySaveIngredientsQty(any)).thenAnswer((_) async {
        //after delay async finishes, new request came in before save async finishes
        scopedIngredient.unsavedUpdates.add(
            IngredientUpdate.withDate(1, 1.5, now.add(Duration(hours: 1))));
      });

      scopedIngredient.updateIngredientQty(ingredient, 1.5, bufferMs: 100);
      await Future.delayed(Duration(milliseconds: 120));

      expect(scopedIngredient.unsavedUpdates.length, equals(1));
      expect(scopedIngredient.savingAtSec, isNull);
      expect(scopedIngredient.unsavedUpdates[0].hadQty, equals(1.5));
    });

    test(
        "doesn't clear unsaved updates if unsuccessful API call (e.g. bad internet connection)",
        () async {
      final now = DateTime.now();
      final hourAgo = now.subtract(Duration(hours: 1));
      var updates = List<IngredientUpdate>();
      updates.add(IngredientUpdate.withDate(1, 1.2, hourAgo));
      updates.add(IngredientUpdate.withDate(1, 0.9, hourAgo));

      final scopedIngredient = ScopedDayIngredient(
          api: api, ingredients: init, unsavedUpdates: updates);
      expect(scopedIngredient.unsavedUpdates.length, equals(2));
      expect(scopedIngredient.retryCount, equals(0));

      when(api.postOpDaySaveIngredientsQty(any)).thenThrow(Exception("test"));

      scopedIngredient.updateIngredientQty(ingredient, 1.5, bufferMs: 100);
      await Future.delayed(Duration(milliseconds: 120));

      expect(scopedIngredient.unsavedUpdates.length, equals(3));
      expect(scopedIngredient.savingAtSec, isNull);
      expect(scopedIngredient.retryCount, equals(1));
    });

    //TODO: test saving when already mid-save - should not run and retry later
  });
}

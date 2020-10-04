import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_day_input.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  test('fetch op day API', () async {
    final opDay = locator<ScopedOpDay>();
    final scopedDayInput = locator<ScopedDayInput>();
    final scopedDayPrep = locator<ScopedDayPrep>();
    final scopedLookup = locator<ScopedLookup>();

    expect(scopedDayInput.inputs.length, equals(0));
    expect(scopedDayPrep.getPrep().length, equals(0));
    expect(scopedLookup.getRecipes().length, equals(0));

    await opDay.loadOpDay(1);

    expect(scopedDayInput.inputs.length, greaterThan(0));
    expect(scopedDayPrep.getPrep().length, greaterThan(0));
    expect(scopedLookup.getRecipes().length, greaterThan(0));

    final input = scopedDayInput.inputs[0];
    expect(input.inputableId, isNotNull);

    final prep = scopedDayPrep.getPrep()[0];
    expect(prep.recipeStepId, isNotNull);

    final recipe = scopedLookup.getRecipes()[0];
    expect(recipe.id, isNotNull);
  }, skip: 'run manually for sanity checks');

  //TODO: tests on refreshing / re-loading
}

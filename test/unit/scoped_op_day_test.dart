import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  test('fetch op day API', () async {
    final opDay = ScopedOpDay();
    expect(opDay.scopedDayInput.inputs.length, equals(0));
    expect(opDay.scopedDayPrep.prep.length, equals(0));
    await opDay.loadOpDay(1);
    expect(opDay.scopedDayInput.inputs.length, greaterThan(0));
    expect(opDay.scopedDayPrep.prep.length, greaterThan(0));

    final input = opDay.scopedDayInput.inputs[0];
    expect(input.inputableId, isNotNull);

    final prep = opDay.scopedDayPrep.prep[0];
    expect(prep.recipeStepId, isNotNull);
  }, skip: 'run manually for sanity checks');

  //TODO: tests on refreshing / re-loading
}

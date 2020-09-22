import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/models/recipe_step.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/api/prep_update.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  RecipeStep _createRecipeStep(
      int recipeStepId, int recipeId, List<StepInput> inputs,
      {int number}) {
    number = number ?? 1;

    return new RecipeStep(
        recipeStepId, recipeId, number, "mock instruction", null, null, inputs);
  }

  StepInput _createStepInput(String inputableType, {int inputableId}) {
    inputableId = inputableId ?? 20;
    return new StepInput(10, "mock name", inputableId, inputableType);
  }

  DayPrep _createDayPrep(int recipeStepId,
      {int prepId, double madeQty, int qtyUpdatedAtSec}) {
    prepId = prepId ?? 11;
    return new DayPrep(prepId, 2.5, recipeStepId, 1000,
        madeQty: madeQty, qtyUpdatedAtSec: qtyUpdatedAtSec);
  }

  group('test buildDependencyMap', () {
    List<StepInput> inputs;
    setUp(() {
      inputs = new List<StepInput>();
    });

    const recipeStepId = 1;
    const recipeStepRecipeId = 2;

    const dayPrepId = 3;
    const dayPrep1Id = 3;
    const dayPrep2Id = 6;

    const inputTypeRecipe1Id = 11;
    const inputTypeRecipe2Id = 31;

    const recipe1StepId = 1;
    const recipe2StepId = 4;

    test('a recipe step with 2 inputs should result in a map[id] with length 2',
        () {
      inputs.add(_createStepInput("Recipe", inputableId: inputTypeRecipe1Id));
      inputs.add(_createStepInput("Prep"));
      inputs.add(_createStepInput("Recipe", inputableId: inputTypeRecipe2Id));

      List<DayPrep> dayPrepList = [
        _createDayPrep(
          recipeStepId,
          prepId: dayPrepId,
        )
      ];

      final scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipeStepId, recipeStepRecipeId, inputs)
      ]);
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(recipeStepRecipeId), equals(true));
      expect(map[recipeStepRecipeId].length, equals(2));
      expect(map[recipeStepRecipeId].elementAt(0), equals(inputTypeRecipe1Id));
      expect(map[recipeStepRecipeId].elementAt(1), equals(inputTypeRecipe2Id));
    });

    test('a recipe step with no dependencies should result in map[id] length 0',
        () {
      List<DayPrep> dayPrepList = [
        _createDayPrep(
          recipeStepId,
          prepId: dayPrepId,
        )
      ];

      final scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipeStepId, recipeStepRecipeId, inputs)
      ]);
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(recipeStepRecipeId), equals(true));
      expect(map[recipeStepRecipeId].length, equals(0));
    });

    test(
        '2 recipe steps belonging to 1 recipe, not sharing the same inputable id, should result in map with 1 key, 2 values',
        () {
      const sharedStepRecipeId = 2;

      List<StepInput> inputs1 = [];
      List<StepInput> inputs2 = [];

      inputs1.add(_createStepInput("Recipe", inputableId: inputTypeRecipe1Id));
      inputs2.add(_createStepInput("Recipe", inputableId: inputTypeRecipe2Id));

      List<DayPrep> dayPrepList = [];
      dayPrepList.add(_createDayPrep(
        recipe1StepId,
        prepId: dayPrep1Id,
      ));
      dayPrepList.add(_createDayPrep(recipe2StepId, prepId: dayPrep2Id));

      final scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipe1StepId, sharedStepRecipeId, inputs1),
        _createRecipeStep(recipe2StepId, sharedStepRecipeId, inputs2)
      ]);
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(sharedStepRecipeId), equals(true));
      expect(map[sharedStepRecipeId].length, equals(2));
      expect(map[sharedStepRecipeId].elementAt(0), equals(inputTypeRecipe1Id));
      expect(map[sharedStepRecipeId].elementAt(1), equals(inputTypeRecipe2Id));
    });

    test(
        '2 recipe steps belonging to 1 recipe, where the steps share the same inputable id, should result in a map with 1 key, 1 value',
        () {
      const sharedStepRecipeId = 2;
      const inputTypeRecipeId = 11;

      inputs.add(_createStepInput("Recipe", inputableId: inputTypeRecipeId));

      List<DayPrep> dayPrepList = [];
      dayPrepList.add(_createDayPrep(
        recipe1StepId,
        prepId: dayPrep1Id,
      ));
      dayPrepList.add(_createDayPrep(recipe2StepId, prepId: dayPrep2Id));

      final scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipe1StepId, sharedStepRecipeId, inputs),
        _createRecipeStep(recipe2StepId, sharedStepRecipeId, inputs)
      ]);
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(sharedStepRecipeId), equals(true));
      expect(map[sharedStepRecipeId].length, equals(1));
      expect(map[sharedStepRecipeId].elementAt(0), equals(inputTypeRecipeId));
    });

    test(
        '2 recipe steps belonging to 2 different recipes should result in map having 2 keys',
        () {
      const recipe1RecipeId = 2;
      const recipe2RecipeId = 5;

      const sharedInputRecipeId = 11;

      inputs.add(_createStepInput("Recipe", inputableId: sharedInputRecipeId));

      List<DayPrep> dayPrepList = [];
      dayPrepList.add(_createDayPrep(
        recipe1StepId,
        prepId: dayPrep1Id,
      ));
      dayPrepList.add(_createDayPrep(recipe2StepId, prepId: dayPrep2Id));

      final scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipe1StepId, recipe1RecipeId, inputs),
        _createRecipeStep(recipe2StepId, recipe2RecipeId, inputs)
      ]);
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(2));
      expect(map.containsKey(recipe1RecipeId), equals(true));
      expect(map[recipe1RecipeId].length, equals(1));
      expect(map[recipe1RecipeId].elementAt(0), sharedInputRecipeId);

      expect(map.length, equals(2));
      expect(map.containsKey(recipe2RecipeId), equals(true));
      expect(map[recipe2RecipeId].length, equals(1));
      expect(map[recipe2RecipeId].elementAt(0), sharedInputRecipeId);
    });

    test(
        'if rA depends on rB, and rB depends on rC, map[raId]contains rB, and map[rBId] contains rC',
        () {
      const recipeStep1Id = 1;
      const recipeStep2Id = 2;
      const input1Id = 3;
      const input2Id = 4;
      const recipeStep1RecipeId = 5;
      const recipeStep2RecipeId = 3;

      List<StepInput> inputs1 = [];
      inputs1.add(_createStepInput("Recipe", inputableId: input1Id));

      List<StepInput> inputs2 = [];
      inputs2.add(_createStepInput("Recipe", inputableId: input2Id));

      List<DayPrep> preps = [];
      preps.add(_createDayPrep(recipeStep1Id));
      preps.add(_createDayPrep(recipeStep2Id));

      final ScopedLookup scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipeStep1Id, recipeStep1RecipeId, inputs1),
        _createRecipeStep(recipeStep2Id, recipeStep2RecipeId, inputs2)
      ]);
      final ScopedDayPrep scopedDayPrep =
          new ScopedDayPrep(prep: preps, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.containsKey(recipeStep1RecipeId), equals(true));
      expect(map.containsKey(recipeStep2RecipeId), equals(true));
      expect(map[recipeStep1RecipeId].length, equals(1));
      expect(map[recipeStep1RecipeId].elementAt(0), equals(input1Id));
      expect(map[recipeStep2RecipeId].length, equals(1));
      expect(map[recipeStep2RecipeId].elementAt(0), equals(input2Id));
    });

    test('if inputs dont have type recipe, the map should not contain their id',
        () {
      inputs.add(_createStepInput("Prep", inputableId: inputTypeRecipe1Id));
      inputs.add(
          _createStepInput("Recipe Step", inputableId: inputTypeRecipe2Id));

      final dayPrep = _createDayPrep(
        recipeStepId,
        prepId: dayPrepId,
      );
      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep);

      final scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipeStepId, recipeStepRecipeId, inputs)
      ]);

      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedLookup: scopedLookup);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.containsKey(recipeStepRecipeId), equals(true));
      expect(map[recipeStepRecipeId].length, equals(0));
    });
  });

  group('test sortPrepList', () {
    Map<int, RecipeStep> recipeStepsMap;

    setUp(() {
      recipeStepsMap = new Map<int, RecipeStep>();
    });

    const recipeStepIdForA = 1;
    const recipeStepIdForB = 2;
    const sharedRecipeId = 1;
    const recipeIdA = 3;
    const recipeIdB = 4;

    test('if recipe is equal, the earlier step is lower', () {
      const numberForA = 1;
      const numberForB = 2;

      final rsForA = _createRecipeStep(recipeStepIdForA, sharedRecipeId, null,
          number: numberForA);

      final rsForB = _createRecipeStep(recipeStepIdForB, sharedRecipeId, null,
          number: numberForB);

      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      ScopedLookup scopedLookup =
          new ScopedLookup(recipeSteps: [rsForA, rsForB]);

      ScopedDayPrep scopedDayPrep =
          new ScopedDayPrep(scopedLookup: scopedLookup);

      final result = scopedDayPrep.compareForPrepList(prepA, prepB);

      expect(result, equals(-1));
    });

    test(
        'if recipe ids are different and neither depends on each other, the lower recipe id should come first',
        () async {
      const numberForA = 1;
      const numberForB = 2;

      List<StepInput> inputsForA = [];
      inputsForA.add(_createStepInput("Recipe"));

      List<StepInput> inputsForB = [];
      inputsForB.add(_createStepInput("Recipe"));

      final rsForA = _createRecipeStep(recipeStepIdForA, recipeIdA, inputsForA,
          number: numberForA);

      final rsForB = _createRecipeStep(recipeStepIdForB, recipeIdB, inputsForB,
          number: numberForB);

      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      List<DayPrep> preps = [];
      preps.add(prepA);
      preps.add(prepB);

      ScopedLookup scopedLookup =
          new ScopedLookup(recipeSteps: [rsForA, rsForB]);
      final scopedDayPrep = ScopedDayPrep(scopedLookup: scopedLookup);

      await scopedDayPrep.addFetched(preps);

      final result = scopedDayPrep.compareForPrepList(prepA, prepB);

      expect(result, equals(-1));
    });

    test(
        'if recipe ids are different and if A depends on B, B should come first',
        () async {
      const numberForA = 1;
      const numberForB = 2;

      List<StepInput> inputsForA = [];
      inputsForA.add(_createStepInput("Recipe", inputableId: recipeIdB));

      List<StepInput> inputsForB = [];
      inputsForB.add(_createStepInput("Recipe"));

      final rsForA = _createRecipeStep(recipeStepIdForA, recipeIdA, inputsForA,
          number: numberForA);

      final rsForB = _createRecipeStep(recipeStepIdForB, recipeIdB, inputsForB,
          number: numberForB);

      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      List<DayPrep> preps = [];
      preps.add(prepA);
      preps.add(prepB);

      ScopedLookup scopedLookup =
          new ScopedLookup(recipeSteps: [rsForA, rsForB]);
      final scopedDayPrep = ScopedDayPrep(scopedLookup: scopedLookup);

      await scopedDayPrep.addFetched(preps);

      final result = scopedDayPrep.compareForPrepList(prepA, prepB);

      expect(result, equals(1));
    });

    test(
        'if recipe ids are different and if B depends on A, A should come first',
        () async {
      const numberForA = 2;
      const numberForB = 1;

      List<StepInput> inputsForA = [];
      inputsForA.add(_createStepInput("Recipe"));

      List<StepInput> inputsForB = [];
      inputsForB.add(_createStepInput("Recipe", inputableId: recipeIdA));

      final RecipeStep rsForA = _createRecipeStep(
          recipeStepIdForA, recipeIdA, inputsForA,
          number: numberForA);

      final RecipeStep rsForB = _createRecipeStep(
          recipeStepIdForB, recipeIdB, inputsForB,
          number: numberForB);

      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      List<DayPrep> preps = [];
      preps.add(prepA);
      preps.add(prepB);

      ScopedLookup scopedLookup =
          new ScopedLookup(recipeSteps: [rsForA, rsForB]);
      final scopedDayPrep = ScopedDayPrep(scopedLookup: scopedLookup);

      await scopedDayPrep.addFetched(preps);

      final result = scopedDayPrep.compareForPrepList(prepA, prepB);

      expect(result, equals(-1));
    });
  });

  group('updatePrepQty', () {
    const recipeStepId = 1;
    const recipeStepRecipeId = 2;
    ScopedLookup scopedLookup;
    List<DayPrep> dayPrepList;
    final api = MockApi();

    setUp(() {
      scopedLookup = new ScopedLookup(recipeSteps: [
        _createRecipeStep(recipeStepId, recipeStepRecipeId, [])
      ]);

      dayPrepList = [];
    });

    test('changes quantity and makes API call to save it after delay',
        () async {
      final prep = _createDayPrep(recipeStepId);
      dayPrepList.add(prep);

      final scopedPrep = ScopedDayPrep(
          prep: dayPrepList, scopedLookup: scopedLookup, api: api);

      final preps = scopedPrep.getPrep();
      expect(preps[0].madeQty, isNull);
      expect(preps[0].qtyUpdatedAtSec, isNull);

      var updated = false;
      when(api.postOpDaySavePrepQty(any)).thenAnswer((_) async {
        updated = true;
      });

      await scopedPrep.updatePrepQty(prep, 1.5);
      final newPreps = scopedPrep.getPrep();
      expect(updated, isTrue);
      expect(newPreps[0].madeQty, equals(1.5));
      expect(newPreps[0].qtyUpdatedAtSec, isNotNull);
      expect(scopedPrep.unsavedUpdates.length, equals(0));
    });

    test("makes call with all unsavedUpdates and clears those", () async {
      final now = DateTime.now();
      final hourAgo = now.subtract(Duration(hours: 1));
      final prep = _createDayPrep(recipeStepId);
      dayPrepList.add(prep);
      var updates = List<PrepUpdate>();
      updates.add(PrepUpdate.withDate(1, 1.2, hourAgo));
      updates.add(PrepUpdate.withDate(1, 0.9, hourAgo));

      final scopedPrep =
          ScopedDayPrep(api: api, prep: dayPrepList, unsavedUpdates: updates);
      expect(scopedPrep.unsavedUpdates.length, equals(2));

      when(api.postOpDaySavePrepQty(any)).thenAnswer((invocation) async {
        List<PrepUpdate> calledUpdates = invocation.positionalArguments[0];
        expect(calledUpdates.length, equals(3));
        expect(calledUpdates.last.madeQty, equals(1.5));

        //new request came in before save async finishes
        scopedPrep.unsavedUpdates
            .add(PrepUpdate.withDate(1, 1.8, now.add(Duration(hours: 1))));
      });

      await scopedPrep.updatePrepQty(prep, 1.5);

      expect(scopedPrep.unsavedUpdates.length, equals(1));
      expect(scopedPrep.unsavedUpdates[0].madeQty, equals(1.8));
    });

    test(
        "doesn't clear unsaved updates if unsuccessful API call (e.g. bad internet connection)",
        () async {
      final now = DateTime.now();
      final hourAgo = now.subtract(Duration(hours: 1));
      final prep = _createDayPrep(recipeStepId);
      dayPrepList.add(prep);
      var updates = List<PrepUpdate>();
      updates.add(PrepUpdate.withDate(1, 1.2, hourAgo));
      updates.add(PrepUpdate.withDate(1, 0.9, hourAgo));

      final scopedPrep =
          ScopedDayPrep(api: api, prep: dayPrepList, unsavedUpdates: updates);
      expect(scopedPrep.unsavedUpdates.length, equals(2));
      expect(scopedPrep.retryCount, equals(0));

      when(api.postOpDaySavePrepQty(any)).thenThrow(Exception("test"));

      await scopedPrep.updatePrepQty(prep, 1.5);

      expect(scopedPrep.unsavedUpdates.length, equals(3));
      expect(scopedPrep.retryCount, equals(1));
    });

    //TODO: test retry
  });
}

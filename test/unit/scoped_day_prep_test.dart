import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/models/recipe_step.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  RecipeStep _createRecipeStep(
      int recipeStepId, int recipeId, List<StepInput> inputs,
      {String stepType, int number}) {
    stepType = stepType ?? "cook";
    number = number ?? 1;

    return new RecipeStep(recipeStepId, recipeId, stepType, number,
        "mock instruction", null, null, inputs);
  }

  StepInput _createStepInput(String inputableType, {int inputableId}) {
    inputableId = inputableId ?? 20;
    return new StepInput(10, "mock name", inputableId, inputableType);
  }

  DayPrep _createDayPrep(int recipeStepId, {int prepId}) {
    prepId = prepId ?? 11;
    return new DayPrep(prepId, 2.5, recipeStepId);
  }

  group('test buildDependencyMap', () {
    Map<int, RecipeStep> recipeStepsMap;
    List<StepInput> inputs;
    setUp(() {
      recipeStepsMap = new Map<int, RecipeStep>();
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
      inputs.add(_createStepInput("Ingredient"));
      inputs.add(_createStepInput("Recipe", inputableId: inputTypeRecipe2Id));

      recipeStepsMap[recipeStepId] =
          _createRecipeStep(recipeStepId, recipeStepRecipeId, inputs);

      final dayPrep = _createDayPrep(
        recipeStepId,
        prepId: dayPrepId,
      );
      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep);

      final scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(recipeStepRecipeId), equals(true));
      expect(map[recipeStepRecipeId].length, equals(2));
      expect(map[recipeStepRecipeId].elementAt(0), equals(inputTypeRecipe1Id));
      expect(map[recipeStepRecipeId].elementAt(1), equals(inputTypeRecipe2Id));
    });

    test('a recipe step with no dependencies should result in map[id] length 0',
        () {
      recipeStepsMap[recipeStepId] =
          _createRecipeStep(recipeStepId, recipeStepRecipeId, inputs);

      final dayPrep = _createDayPrep(
        recipeStepId,
        prepId: dayPrepId,
      );
      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep);

      final scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(recipeStepRecipeId), equals(true));
      expect(map[recipeStepRecipeId].length, equals(0));
    });

    test(
        '2 recipe steps belonging to 1 recipe with 2 day preps, not sharing the same inputable id, should result in map with 1 key, 2 values',
        () {
      const sharedStepRecipeId = 2;

      List<StepInput> inputs1 = [];
      List<StepInput> inputs2 = [];

      inputs1.add(_createStepInput("Recipe", inputableId: inputTypeRecipe1Id));
      inputs2.add(_createStepInput("Recipe", inputableId: inputTypeRecipe2Id));

      recipeStepsMap[recipe1StepId] =
          _createRecipeStep(recipe1StepId, sharedStepRecipeId, inputs1);

      recipeStepsMap[recipe2StepId] =
          _createRecipeStep(recipe2StepId, sharedStepRecipeId, inputs2);

      var dayPrep1 = _createDayPrep(
        recipe1StepId,
        prepId: dayPrep1Id,
      );
      var dayPrep2 = _createDayPrep(recipe2StepId, prepId: dayPrep2Id);

      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep1);
      dayPrepList.add(dayPrep2);

      final scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(sharedStepRecipeId), equals(true));
      expect(map[sharedStepRecipeId].length, equals(2));
      expect(map[sharedStepRecipeId].elementAt(0), equals(inputTypeRecipe1Id));
      expect(map[sharedStepRecipeId].elementAt(1), equals(inputTypeRecipe2Id));
    });

    test(
        '2 recipe steps belonging to 1 recipe with 2 day preps,where the steps share the same inputable id, should result in a map with 1 key, 1 value',
        () {
      const sharedStepRecipeId = 2;
      const inputTypeRecipeId = 11;

      inputs.add(_createStepInput("Recipe", inputableId: inputTypeRecipeId));

      recipeStepsMap[recipe1StepId] =
          _createRecipeStep(recipe1StepId, sharedStepRecipeId, inputs);

      recipeStepsMap[recipe2StepId] =
          _createRecipeStep(recipe2StepId, sharedStepRecipeId, inputs);

      var dayPrep1 = _createDayPrep(
        recipe1StepId,
        prepId: dayPrep1Id,
      );
      var dayPrep2 = _createDayPrep(recipe2StepId, prepId: dayPrep2Id);

      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep1);
      dayPrepList.add(dayPrep2);

      final scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(1));
      expect(map.containsKey(sharedStepRecipeId), equals(true));
      expect(map[sharedStepRecipeId].length, equals(1));
      expect(map[sharedStepRecipeId].elementAt(0), equals(inputTypeRecipeId));
    });

    test(
        '2 recipe steps belonging to 2 different recipes with 2 day preps should result in map having 2 keys',
        () {
      const recipeStep1RecipeId = 2;
      const recipeStep2RecipeId = 5;

      const inputTypeRecipeId = 11;

      inputs.add(_createStepInput("Recipe", inputableId: inputTypeRecipeId));

      recipeStepsMap[recipe1StepId] =
          _createRecipeStep(recipe1StepId, recipeStep1RecipeId, inputs);

      recipeStepsMap[recipe2StepId] =
          _createRecipeStep(recipe2StepId, recipeStep2RecipeId, inputs);

      var dayPrep1 = _createDayPrep(
        recipe1StepId,
        prepId: dayPrep1Id,
      );
      var dayPrep2 = _createDayPrep(recipe2StepId, prepId: dayPrep2Id);

      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep1);
      dayPrepList.add(dayPrep2);

      final scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.length, equals(2));
      expect(map.containsKey(recipeStep1RecipeId), equals(true));
      expect(map[recipeStep1RecipeId].length, equals(1));
      expect(map[recipeStep1RecipeId].elementAt(0), inputTypeRecipeId);

      expect(map.length, equals(2));
      expect(map.containsKey(recipeStep2RecipeId), equals(true));
      expect(map[recipeStep2RecipeId].length, equals(1));
      expect(map[recipeStep2RecipeId].elementAt(0), inputTypeRecipeId);
    });

    test(
        'if rA depends on rB, and rB depends on rC, map[raId]contains rB, and map[rBId] contains rC',
        () {
      const recipeStep1Id = 1;
      const recipeStep2Id = 2;
      const input1AndRecipe2Id = 3;
      const input2Id = 4;
      const recipeStep1RecipeId = 5;

      List<StepInput> inputs1 = [];
      inputs1.add(_createStepInput("Recipe", inputableId: input1AndRecipe2Id));

      List<StepInput> inputs2 = [];
      inputs2.add(_createStepInput("Recipe", inputableId: input2Id));

      recipeStepsMap[recipeStep1Id] =
          _createRecipeStep(recipeStep1Id, recipeStep1RecipeId, inputs1);
      recipeStepsMap[recipeStep2Id] =
          _createRecipeStep(recipeStep2Id, input1AndRecipe2Id, inputs2);

      List<DayPrep> preps = [];
      preps.add(_createDayPrep(recipeStep1Id));
      preps.add(_createDayPrep(recipeStep2Id));

      final ScopedOrder scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final ScopedDayPrep scopedDayPrep =
          new ScopedDayPrep(prep: preps, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.containsKey(recipeStep1RecipeId), equals(true));
      expect(map.containsKey(input1AndRecipe2Id), equals(true));
      expect(map[recipeStep1RecipeId].length, equals(1));
      expect(map[recipeStep1RecipeId].elementAt(0), equals(input1AndRecipe2Id));
      expect(map[input1AndRecipe2Id].length, equals(1));
      expect(map[input1AndRecipe2Id].elementAt(0), equals(input2Id));
    });

    test('if inputs dont have type recipe, the map should not contain their id',
        () {
      inputs
          .add(_createStepInput("Ingredient", inputableId: inputTypeRecipe1Id));
      inputs.add(
          _createStepInput("Recipe Step", inputableId: inputTypeRecipe2Id));

      recipeStepsMap[recipeStepId] =
          _createRecipeStep(recipeStepId, recipeStepRecipeId, inputs);

      final dayPrep = _createDayPrep(
        recipeStepId,
        prepId: dayPrepId,
      );
      List<DayPrep> dayPrepList = [];
      dayPrepList.add(dayPrep);

      final scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;

      final scopedDayPrep =
          ScopedDayPrep(prep: dayPrepList, scopedOrder: scopedOrder);

      var map = scopedDayPrep.mkRecipeDependencyMap();

      expect(map.containsKey(recipeStepRecipeId), equals(true));
      expect(map[recipeStepRecipeId].length, equals(0));
    });
  });

  group('test sortPrepList', () {
    var recipeStepsMap = Map<int, RecipeStep>();

    const recipeStepIdForA = 1;
    const recipeStepIdForB = 2;
    const sharedRecipeId = 1;
    const sharedStepType = "cook";
    const recipeIdA = 3;
    const recipeIdB = 4;

    test('if recipe and recipe step are equal, the earlier step is lower', () {
      const numberForA = 1;
      const numberForB = 2;

      final rsForA = _createRecipeStep(recipeStepIdForA, sharedRecipeId, null,
          number: numberForA, stepType: sharedStepType);

      final rsForB = _createRecipeStep(recipeStepIdForB, sharedRecipeId, null,
          number: numberForB, stepType: sharedStepType);

      recipeStepsMap.clear();
      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      ScopedOrder scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;

      ScopedDayPrep scopedDayPrep = new ScopedDayPrep(scopedOrder: scopedOrder);

      final result = scopedDayPrep.compareForPrepList(prepA, prepB);

      expect(result, equals(-1));
    });

    test('prep should come before cook if recipe ids are equal', () {
      const stepTypeA = "prep";
      const stepTypeB = "cook";
      const numberA = 2;
      const numberB = 1;

      final rsForA = _createRecipeStep(recipeStepIdForA, sharedRecipeId, null,
          stepType: stepTypeA, number: numberA);
      final rsForB = _createRecipeStep(recipeStepIdForB, sharedRecipeId, null,
          stepType: stepTypeB, number: numberB);

      recipeStepsMap.clear();
      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      ScopedOrder scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      ScopedDayPrep scopedDayPrep = new ScopedDayPrep(scopedOrder: scopedOrder);

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
          stepType: sharedStepType, number: numberForA);

      final rsForB = _createRecipeStep(recipeStepIdForB, recipeIdB, inputsForB,
          stepType: sharedStepType, number: numberForB);

      recipeStepsMap.clear();
      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      List<DayPrep> preps = [];
      preps.add(prepA);
      preps.add(prepB);

      ScopedOrder scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep = ScopedDayPrep(scopedOrder: scopedOrder);

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
          stepType: sharedStepType, number: numberForA);

      final rsForB = _createRecipeStep(recipeStepIdForB, recipeIdB, inputsForB,
          stepType: sharedStepType, number: numberForB);

      recipeStepsMap.clear();
      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      List<DayPrep> preps = [];
      preps.add(prepA);
      preps.add(prepB);

      ScopedOrder scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep = ScopedDayPrep(scopedOrder: scopedOrder);

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
          stepType: sharedStepType, number: numberForA);

      final RecipeStep rsForB = _createRecipeStep(
          recipeStepIdForB, recipeIdB, inputsForB,
          stepType: sharedStepType, number: numberForB);

      recipeStepsMap.clear();
      recipeStepsMap[recipeStepIdForA] = rsForA;
      recipeStepsMap[recipeStepIdForB] = rsForB;

      final prepA = _createDayPrep(recipeStepIdForA);
      final prepB = _createDayPrep(recipeStepIdForB);

      List<DayPrep> preps = [];
      preps.add(prepA);
      preps.add(prepB);

      ScopedOrder scopedOrder = new ScopedOrder();
      scopedOrder.recipeStepsMap = recipeStepsMap;
      final scopedDayPrep = ScopedDayPrep(scopedOrder: scopedOrder);

      await scopedDayPrep.addFetched(preps);

      final result = scopedDayPrep.compareForPrepList(prepA, prepB);

      expect(result, equals(-1));
    });
  });
}

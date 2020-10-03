import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/screens/common/components/submit_button.dart';
import 'package:kitchen/service_locator.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'package:kitchen/scoped_models/scoped_day_input.dart';
import '../add_recipe.dart';
import '../../../models/day_input.dart';
import '../ingredients_styles.dart';
import 'ingredient_item.dart';

class IngredientsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOpDay>(
        builder: (context, child, scopedOpDay) =>
            ScopedModelDescendant<ScopedDayInput>(
                builder: (context, child, scopedDayInput) =>
                    _renderView(context, scopedDayInput, scopedOpDay)));
  }

  Widget _renderView(BuildContext context, ScopedDayInput scopedDayInput,
      ScopedOpDay scopedOpDay) {
    if (scopedOpDay.isLoading) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            CircularProgressIndicator(),
            Text("Regenerating List...", style: Styles.textDefault)
          ]));
    } else {
      return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _renderList(context, scopedDayInput, scopedOpDay)));
    }
  }

  List<Widget> _renderList(BuildContext context, ScopedDayInput scopedDayInput,
      ScopedOpDay scopedOpDay) {
    var uncheckedRecipes = List<DayInput>();
    var missingRecipes = List<DayInput>();
    var checkedRecipes = List<DayInput>();

    var uncheckedIngredients = List<DayInput>();
    var missingIngredients = List<DayInput>();
    var checkedIngredients = List<DayInput>();

    scopedDayInput.inputs.forEach((input) {
      if (input.hadQty == null) {
        if (input.inputableType == DayInputType.Ingredient) {
          uncheckedIngredients.add(input);
        } else {
          uncheckedRecipes.add(input);
        }
      } else if (input.expectedQty > input.hadQty) {
        if (input.inputableType == DayInputType.Ingredient) {
          missingIngredients.add(input);
        } else {
          missingRecipes.add(input);
        }
      } else {
        if (input.inputableType == DayInputType.Ingredient) {
          checkedIngredients.add(input);
        } else {
          checkedRecipes.add(input);
        }
      }
    });

    var viewItems = List<Widget>();

    viewItems.addAll(
        _inputSection("Unchecked Recipes", uncheckedRecipes, scopedOpDay));
    viewItems
        .addAll(_inputSection("Missing Recipes", missingRecipes, scopedOpDay));
    viewItems
        .addAll(_inputSection("Checked Recipes", checkedRecipes, scopedOpDay));
    viewItems.add(_addRecipeButton(context));
    viewItems.addAll(_inputSection(
        "Unchecked Ingredients", uncheckedIngredients, scopedOpDay));
    viewItems.addAll(
        _inputSection("Missing Ingredients", missingIngredients, scopedOpDay));
    viewItems.addAll(
        _inputSection("Checked Ingredients", checkedIngredients, scopedOpDay));

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _addRecipeButton(BuildContext context) {
    return SubmitButton(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "Add Recipe"),
              builder: (_) => AddRecipePage()));
    }, btnText: "Add Recipe In Inventory");
  }

  List<Widget> _inputSection(
      String headerText, List<DayInput> inputList, ScopedOpDay scopedOpDay) {
    if (inputList.length > 0) {
      return <Widget>[_headerText(headerText)] +
          inputList
              .map((i) => IngredientsItem(i, refreshList: () {
                    final user = locator<ScopedUser>();
                    scopedOpDay.loadOpDay(user.getKitchenId(), forceLoad: true);
                  }))
              .toList();
    } else
      return [];
  }

  void refreshList() {}

  Widget _headerText(String text) {
    return Container(
        padding: IngredientsStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: IngredientsStyles.listHeader));
  }
}

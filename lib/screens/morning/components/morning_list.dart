import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/screens/common/components/submit_button.dart';
import 'package:kitchen/screens/morning/add_recipe.dart';
import 'package:kitchen/service_locator.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'package:kitchen/scoped_models/scoped_day_input.dart';
import '../../../models/day_input.dart';
import '../morning_styles.dart';
import './morning_item.dart';

class MorningList extends StatelessWidget {
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
    var uncheckedIngredients = List<DayInput>();
    var missingIngredients = List<DayInput>();
    var checkedInputs = List<DayInput>();

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
        checkedInputs.add(input);
      }
    });

    var viewItems = List<Widget>();

    viewItems.addAll(
        _inputSection("Unchecked Recipes", uncheckedRecipes, scopedOpDay));
    viewItems
        .addAll(_inputSection("Missing Recipes", missingRecipes, scopedOpDay));
    viewItems.add(SubmitButton(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "Add Recipe"),
              builder: (_) => AddRecipePage()));
    }, btnText: "Add Recipe In Inventory"));
    viewItems.addAll(_inputSection(
        "Unchecked Ingredients", uncheckedIngredients, scopedOpDay));
    viewItems.addAll(
        _inputSection("Missing Ingredients", missingIngredients, scopedOpDay));
    viewItems.addAll(_inputSection("Checked", checkedInputs, scopedOpDay));

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  List<Widget> _inputSection(
      String headerText, List<DayInput> inputList, ScopedOpDay scopedOpDay) {
    if (inputList.length > 0) {
      return <Widget>[_headerText(headerText)] +
          inputList
              .map((i) => MorningItem(i, refreshList: () {
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
        padding: MorningStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: MorningStyles.listHeader));
  }
}

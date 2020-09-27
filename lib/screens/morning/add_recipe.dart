import 'package:flutter/material.dart';
import 'package:kitchen/api/new_input.dart';
import 'package:kitchen/models/day_input.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/screens/morning/components/recipe_form.dart';
import 'package:kitchen/styles.dart';
import '../common/components/submit_button.dart';
import '../../service_locator.dart';
import '../../scoped_models/scoped_lookup.dart';
import '../../scoped_models/scoped_op_day.dart';
import '../../scoped_models/scoped_user.dart';

class AddRecipePage extends StatefulWidget {
  AddRecipePage();

  @override
  createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final scopedLookup = locator<ScopedLookup>();
  final scopedOpDay = locator<ScopedOpDay>();
  final scopedUser = locator<ScopedUser>();

  Map<String, Recipe> recipesMap;
  List<RecipeForm> recipeInputs = List();

  @override
  void initState() {
    super.initState();
    this.recipesMap = Map.fromIterable(scopedLookup.getRecipes(),
        key: (r) => r.name, value: (r) => r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Add Recipes"), actions: [_renderSaveButton(context)]),
        body: Container(
            padding: Styles.spacerPadding,
            child: Container(
                child: this.recipeInputs.length <= 0
                    ? Center(
                        child: Text('Add recipes by tapping add button below'))
                    : ListView.builder(
                        addAutomaticKeepAlives: true,
                        itemCount: this.recipeInputs.length,
                        itemBuilder: (_, i) => this.recipeInputs[i]))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add), onPressed: _onAddForm));
  }

  void _onAddForm() {
    this.setState(() {
      var _input = NewInput(DayInputType.Recipe);
      this.recipeInputs.add(RecipeForm(
          recipeInput: _input,
          onDelete: () => onDelete(_input),
          recipesMap: this.recipesMap));
    });
  }

  void onDelete(NewInput recipeInput) {
    this.setState(() {
      final found = this.recipeInputs.firstWhere(
          (ri) => ri.recipeInput == recipeInput,
          orElse: () => null);
      if (found != null)
        this.recipeInputs.removeAt(this.recipeInputs.indexOf(found));
    });
  }

  Widget _renderSaveButton(BuildContext context) {
    return SubmitButton(() async {
      final kitchenId = this.scopedUser.getKitchenId();
      await this.scopedOpDay.addInputs(
          kitchenId, this.recipeInputs.map((ri) => ri.recipeInput).toList());
      Navigator.pop(context);
    });
  }
}

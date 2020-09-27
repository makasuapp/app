import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitchen/api/new_input.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/screens/common/components/list_picker.dart';
import 'package:kitchen/screens/common/components/unit_picker.dart';
import 'package:kitchen/styles.dart';
import 'package:kitchen/services/unit_converter.dart';

class RecipeForm extends StatefulWidget {
  final NewInput recipeInput;
  final Function() onDelete;
  final state = _RecipeFormState();
  final Map<String, Recipe> recipesMap;

  RecipeForm({this.recipeInput, this.onDelete, this.recipesMap});

  @override
  createState() => state;
}

class _RecipeFormState extends State<RecipeForm> {
  Recipe selectedRecipe;

  @override
  void initState() {
    super.initState();
    this.selectedRecipe = this.widget.recipesMap.values.first;
    this.widget.recipeInput.inputableId = this.selectedRecipe.id;
    this.widget.recipeInput.unit = this.selectedRecipe.unit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Styles.textColorFaint))),
        padding: Styles.spacerPadding,
        child: Column(children: [
          _renderTopBar(),
          _renderRecipePicker(),
          _renderQtyPickers()
        ]));
  }

  //we can make this prettier with an AppBar + some padding instead
  Widget _renderTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(icon: Icon(Icons.delete), onPressed: this.widget.onDelete)
      ],
    );
  }

  Widget _renderRecipePicker() {
    return ListPicker(this.selectedRecipe.name, onPick: (selectedRecipeName) {
      this.setState(() {
        this.selectedRecipe = this.widget.recipesMap[selectedRecipeName];
        this.widget.recipeInput.inputableId = this.selectedRecipe.id;
        this.widget.recipeInput.qty = null;
        this.widget.recipeInput.unit = this.selectedRecipe.unit;
      });
    }, list: this.widget.recipesMap.keys.toList());
  }

  Widget _renderQtyPickers() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[_renderQtyPicker(), _renderUnitPicker()],
    );
  }

  Widget _renderUnitPicker() {
    final _setUnit = this.widget.recipeInput.unit;
    if (this.selectedRecipe != null && this.selectedRecipe.unit != null) {
      final unitInGroups = weightUnits.containsKey(_setUnit) ||
          volumeUnits.containsKey(_setUnit);
      return unitInGroups
          ? UnitPicker(_setUnit,
              canConvertAllUnits: this.selectedRecipe != null &&
                  this.selectedRecipe.volumeWeightRatio != null,
              onPick: (input) =>
                  setState(() => this.widget.recipeInput.unit = input))
          : Text(_setUnit);
    } else
      return Container();
  }

  Widget _renderQtyPicker() {
    return Container(
        width: 100,
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (input) {
            setState(() {
              this.widget.recipeInput.qty = double.tryParse(input);
            });
          },
        ));
  }
}

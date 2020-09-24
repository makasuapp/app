import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitchen/api/new_input.dart';
import 'package:kitchen/models/day_input.dart';
import 'package:kitchen/models/recipe.dart';
import 'package:kitchen/screens/common/components/list_picker.dart';
import 'package:kitchen/screens/common/components/unit_picker.dart';
import 'package:kitchen/styles.dart';
import '../common/components/cancel_button.dart';
import '../common/components/submit_button.dart';
import '../../service_locator.dart';
import '../../scoped_models/scoped_lookup.dart';
import '../../scoped_models/scoped_op_day.dart';
import '../../scoped_models/scoped_user.dart';
import 'package:kitchen/services/unit_converter.dart';

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
  double _setQty;
  String _setUnit;
  Recipe selectedRecipe;

  @override
  void initState() {
    super.initState();
    this.recipesMap = Map.fromIterable(scopedLookup.getRecipes(),
        key: (r) => r.name, value: (r) => r);
    this.selectedRecipe = this.recipesMap.values.first;
    this._setUnit = this.selectedRecipe.unit;
  }

  //TODO: multi-form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add Recipe")),
        body: Container(
            padding: Styles.spacerPadding,
            child: Column(children: [
              _renderRecipePicker(),
              _renderQtyPickers(),
              _renderButtons(context)
            ])));
  }

  Widget _renderRecipePicker() {
    return ListPicker(this.selectedRecipe.name, onPick: (selectedRecipeName) {
      this.setState(() {
        this.selectedRecipe = this.recipesMap[selectedRecipeName];
        this._setQty = null;
        this._setUnit = this.selectedRecipe.unit;
      });
    }, list: this.recipesMap.keys.toList());
  }

  Widget _renderQtyPickers() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[_renderQtyPicker(), _renderUnitPicker()],
    );
  }

  Widget _renderUnitPicker() {
    if (this.selectedRecipe != null && this.selectedRecipe.unit != null) {
      final unitInGroups = weightUnits.containsKey(this._setUnit) ||
          volumeUnits.containsKey(this._setUnit);
      return unitInGroups
          ? UnitPicker(this._setUnit,
              canConvertAllUnits: this.selectedRecipe != null &&
                  this.selectedRecipe.volumeWeightRatio != null,
              onPick: (input) => setState(() => this._setUnit = input))
          : Text("${this._setUnit}");
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
              this._setQty = double.tryParse(input);
            });
          },
        ));
  }

  Widget _renderButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CancelButton(() => Navigator.pop(context)),
      SubmitButton(() async {
        //TODO: handle error
        final kitchenId = this.scopedUser.getKitchenId();
        await this.scopedOpDay.addInputs(kitchenId, [
          NewInput(DayInputType.Recipe, this.selectedRecipe.id, this._setQty,
              this._setUnit)
        ]);
        Navigator.pop(context);
      })
    ]);
  }
}

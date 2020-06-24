import 'package:flutter/material.dart';
import './components/quantity_picker.dart';
import '../common/cancel_button.dart';
import '../common/submit_button.dart';
import '../../models/day_ingredient.dart';
import './inventory_styles.dart';

class AdjustQuantityPage extends StatefulWidget {
  final DayIngredient ingredient;
  final void Function(double qty, BuildContext qtyViewContext) onSubmit;

  AdjustQuantityPage(this.ingredient, this.onSubmit);

  @override
  createState() => _AdjustQuantityPageState();
}

class _AdjustQuantityPageState extends State<AdjustQuantityPage> {
  double _setQty; 

  @override
  void initState() {
    super.initState();
    final ingredient = this.widget.ingredient;
    if (ingredient.hadQty != null) {
      this._setQty = ingredient.hadQty;
    } else {
      this._setQty = ingredient.expectedQty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adjust Quantity")),
      body: Container(
        padding: InventoryStyles.quantityPickerPadding,
        child: Column(
          children: [
            Text(this.widget.ingredient.name, style: InventoryStyles.inventoryItemText),
            _renderPickers(),
            _renderButtons(context)
          ]
        )
      )
    );
  }

  Widget _renderPickers() {
    final ingredient = this.widget.ingredient;
    List<Widget> pickers = List();

    pickers.add(QuantityPicker(this._setQty, (double newQty) => setState(() => this._setQty = newQty), 
      maxQty: ingredient.expectedQty.toInt()));

    if (ingredient.unit != null) {
      //TODO(unit_conversion): convert to picker
      pickers.add(Text(" ${ingredient.unit}", style: InventoryStyles.quantityPickerText));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pickers 
    );
  }

  Widget _renderButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CancelButton(() => Navigator.pop(context)),
        SubmitButton(() => this.widget.onSubmit(this._setQty, context))
      ]
    );
  }
}
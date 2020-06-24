import 'package:flutter/material.dart';
import '../../common/cancel_button.dart';
import '../../common/submit_button.dart';
import '../../../models/day_ingredient.dart';
import '../inventory_styles.dart';

class AdjustQuantityView extends StatefulWidget {
  final DayIngredient ingredient;
  final void Function(double qty, BuildContext qtyViewContext) onSubmit;

  AdjustQuantityView(this.ingredient, this.onSubmit);

  @override
  createState() => _AdjustQuantityView();
}

class _AdjustQuantityView extends State<AdjustQuantityView> {
  double setQty; 

  @override
  void initState() {
    super.initState();
    this.setQty = this.widget.ingredient.hadQty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adjust Quantity")),
      body: Column(
        children: [
          Text(this.widget.ingredient.name, style: InventoryStyles.inventoryItemText),
          //TODO: render adjuster here
          _renderButtons(context)
        ]
      )
    );
  }

  Widget _renderButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CancelButton(() => Navigator.pop(context)),
        SubmitButton(() => this.widget.onSubmit(this.setQty, context))
      ]
    );
  }
}
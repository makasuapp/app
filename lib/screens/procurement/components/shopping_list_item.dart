import 'package:flutter/material.dart';
import 'package:kitchen/models/procurement_item.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/models/ingredient.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:scoped_model/scoped_model.dart';
import '../shopping_styles.dart';

class ShoppingListItem extends StatelessWidget {
  final ProcurementItem item;
  final Function(bool) onChecked;

  ShoppingListItem(this.item, this.onChecked);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedLookup>(
        builder: (context, child, scopedLookup) {
      final ingredient = scopedLookup.getIngredient(item.ingredientId);
      return Container(
          padding: ShoppingStyles.listItemPadding,
          width: MediaQuery.of(context).size.width,
          child: Wrap(children: [
            _renderCheckbox(ingredient),
            _renderText(ingredient),
            _renderPrice()
          ]));
    });
  }

  Widget _renderCheckbox(Ingredient ingredient) {
    return SizedBox(
        height: 24,
        width: 30,
        child: Checkbox(
            value: item.gotten(volumeWeightRatio: ingredient.volumeWeightRatio),
            onChanged: this.onChecked));
  }

  //TODO: how should we render it if not yet gotten enough? crossed out is a bit confusing
  Widget _renderText(Ingredient ingredient) {
    return InputWithQuantity(ingredient.name, this.item.quantity,
        StepInputType.Ingredient, this.item.unit,
        adjustedInputQty: this.item.gotQty,
        adjustedInputUnit: this.item.gotUnit);
  }

  Widget _renderPrice() {
    if (this.item.priceCents != null) {
      final price = (this.item.priceCents.toDouble() / 100).toStringAsFixed(2);
      if (this.item.priceUnit != null) {
        return Text(" - \$$price / ${this.item.priceUnit}");
      } else {
        return Text(" - \$$price");
      }
    } else
      return Container();
  }
}

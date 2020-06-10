import 'package:flutter/material.dart';
import '../../../models/ingredient.dart';

class InventoryList extends StatelessWidget {
  final List<Ingredient> ingredients;

  InventoryList(this.ingredients);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.ingredients.length,
      itemBuilder: _inventoryListBuilder,
    );
  }

  Widget _inventoryListBuilder(BuildContext context, int index) {
    final ingredient = this.ingredients[index];
    return Container(
      child: Text(ingredient.name)
    );
  }
}
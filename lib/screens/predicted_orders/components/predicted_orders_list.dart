import 'package:flutter/material.dart';
import 'package:kitchen/models/predicted_order.dart';
import 'package:kitchen/screens/predicted_orders/predicted_order_styles.dart';
import 'package:kitchen/screens/story/components/recipe_story_item.dart';
import 'package:kitchen/screens/story/story.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';

class PredictedOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOpDay>(
        builder: (context, child, scopedOpDay) =>
            ScopedModelDescendant<ScopedLookup>(
                builder: (context, child, scopedLookup) => ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children:
                        _renderView(context, scopedOpDay, scopedLookup))));
  }

  List<Widget> _renderView(BuildContext context, ScopedOpDay scopedOpDay,
      ScopedLookup scopedLookup) {
    return scopedOpDay.predictedOrders
        .map<Widget>((o) => _renderPredictedOrder(context, o, scopedLookup))
        .toList();
  }

  Widget _renderPredictedOrder(
      BuildContext context, PredictedOrder order, ScopedLookup scopedLookup) {
    final recipe = scopedLookup.getRecipe(order.recipeId);

    return InkWell(
        onTap: () => StoryView.render(context,
            RecipeStoryItem(recipe, servingSize: order.quantity.toDouble())),
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: PredictedOrderStyles.predictedOrderPadding,
            child: Text("${order.quantity} ${recipe.name}",
                style: PredictedOrderStyles.orderItemText)));
  }
}

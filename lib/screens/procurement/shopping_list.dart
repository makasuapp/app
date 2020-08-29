import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../service_locator.dart';
import './components/shopping_list_top.dart';
import './components/swipable_shopping_item.dart';
import './shopping_styles.dart';

class ShoppingListArguments {
  final int orderId;

  ShoppingListArguments(this.orderId);
}

class ShoppingListPage extends StatelessWidget {
  static const routeName = '/shopping_list';

  final int orderId;
  final scopedProcurement = locator<ScopedProcurement>();
  final scopedLookup = locator<ScopedLookup>();

  ShoppingListPage(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Order ${this.orderId}")),
        body: ScopedModel<ScopedProcurement>(
            model: this.scopedProcurement,
            child: ScopedModel<ScopedLookup>(
                model: this.scopedLookup,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: _renderContent()))));
  }

  Widget _renderContent() {
    return ScopedModelDescendant<ScopedProcurement>(
        builder: (_, __, scopedProcurement) {
      final order = scopedProcurement.orders
          .where((o) => o.id == this.orderId)
          .toList()
          .first;
      return Container(
          padding: ShoppingStyles.listCardPadding,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    ShoppingListTop(order),
                    Container(padding: ShoppingStyles.listItemsTopPadding),
                  ] +
                  //TODO: group items that are the same ingredient
                  order.items
                      .map(
                        (item) => SwipableShoppingItem(item),
                      )
                      .toList()));
    });
  }
}

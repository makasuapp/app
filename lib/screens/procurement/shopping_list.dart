import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../models/procurement_order.dart';
import '../../service_locator.dart';
import './components/shopping_list_top.dart';
import './components/swipable_shopping_item.dart';
import './shopping_styles.dart';

class ShoppingListPage extends StatelessWidget {
  final ProcurementOrder order;
  final scopedProcurement = locator<ScopedProcurement>();
  final scopedLookup = locator<ScopedLookup>();

  ShoppingListPage(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Order ${this.order.id}")),
        body: ScopedModel<ScopedProcurement>(
            model: this.scopedProcurement,
            child: ScopedModel<ScopedLookup>(
                model: this.scopedLookup,
                child: Container(child: _renderContent()))));
  }

  Widget _renderContent() {
    return Container(
        padding: ShoppingStyles.listCardPadding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  ShoppingListTop(this.order),
                  Container(padding: ShoppingStyles.listItemsTopPadding),
                ] +
                this
                    .order
                    .items
                    .map(
                      (item) => SwipableShoppingItem(item),
                    )
                    .toList()));
  }
}

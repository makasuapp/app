import 'package:flutter/material.dart';
import 'package:kitchen/models/procurement_order.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';
import '../shopping_styles.dart';
import '../shopping_list.dart';
import 'shopping_list_item.dart';
import 'shopping_list_top.dart';

class ShoppingLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedProcurement>(
        builder: (context, child, scopedProcurement) =>
            ScopedModelDescendant<ScopedLookup>(
                builder: (context, child, scopedLookup) => ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: _renderListCards(
                        context, scopedProcurement, scopedLookup))));
  }

  List<Widget> _renderListCards(BuildContext context,
      ScopedProcurement scopedProcurement, ScopedLookup scopedLookup) {
    return scopedProcurement.orders.map((order) {
      return Container(
          padding: ShoppingStyles.betweenCardPadding,
          child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ShoppingListPage(order)));
              },
              child: _renderListCard(context, order, scopedLookup)));
    }).toList();
  }

  Widget _renderListCard(
      BuildContext context, ProcurementOrder order, ScopedLookup scopedLookup) {
    return Container(
        padding: ShoppingStyles.listCardPadding,
        decoration: BoxDecoration(
            border: Border.all(
          color: ShoppingStyles.listCardBorder,
          width: 1,
        )),
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _listCardContent(order, scopedLookup)));
  }

  List<Widget> _listCardContent(
      ProcurementOrder order, ScopedLookup scopedLookup) {
    const previewAmount = 3;
    return <Widget>[
          ShoppingListTop(order),
          Container(padding: ShoppingStyles.listItemsTopPadding)
        ] +
        order.items.take(previewAmount).toList().asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;

          //last item and there's more - show ...
          if (order.items.length > previewAmount && idx == previewAmount - 1) {
            return Wrap(children: [
              ShoppingListItem(item),
              Text("...", style: ShoppingStyles.listItemText)
            ]);
          } else {
            return ShoppingListItem(item);
          }
        }).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';

class ShoppingLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedProcurement>(
        builder: (context, child, scopedProcurement) => ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: _renderListCards(context, scopedProcurement)));
  }

  List<Widget> _renderListCards(
      BuildContext context, ScopedProcurement scopedProcurement) {
    return scopedProcurement.orders.map((order) {
      return Text(order.vendorName);
    }).toList();
  }
}

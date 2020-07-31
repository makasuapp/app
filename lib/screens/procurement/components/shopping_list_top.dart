import 'package:flutter/material.dart';
import 'package:kitchen/models/procurement_order.dart';
import 'package:intl/intl.dart';
import '../shopping_styles.dart';

class ShoppingListTop extends StatelessWidget {
  final ProcurementOrder order;

  ShoppingListTop(this.order);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Text(order.vendorName, style: ShoppingStyles.listTitleText),
      Text(" - ${DateFormat('M/dd').format(order.forDate())}",
          style: ShoppingStyles.listDateText)
    ]);
  }
}

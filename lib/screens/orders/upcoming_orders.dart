import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../service_locator.dart';
import './components/order_list.dart';

class UpcomingOrdersPage extends StatelessWidget {
  final int pageId;
  final String title;
  final scopedOrder = locator<ScopedOrder>();

  UpcomingOrdersPage(this.pageId, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(this.title)),
        drawer: NavigationMenu.navigationDrawer(this.pageId),
        body: ScopedModel<ScopedOrder>(
            model: this.scopedOrder, child: OrderList()));
  }
}

import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../service_locator.dart';
import './components/order_list.dart';
import './components/current_orders.dart';

class UpcomingOrdersPage extends StatelessWidget {
  static const routeName = '/upcoming_orders';

  final scopedOrder = locator<ScopedOrder>();
  final scopedLookup = locator<ScopedLookup>();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ScopedOrder>(
        model: this.scopedOrder,
        child: ScopedModel<ScopedLookup>(
            model: this.scopedLookup,
            child: Scaffold(
                appBar: AppBar(title: Text("Upcoming Orders")),
                drawer: NavigationMenu(routeName),
                bottomSheet: CurrentOrders(),
                body: RefreshIndicator(
                    onRefresh: () =>
                        this.scopedOrder.loadOrders(forceLoad: true),
                    child: OrderList()))));
  }
}

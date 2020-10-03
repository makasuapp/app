import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:kitchen/screens/common/components/op_day_selector.dart';
import 'package:kitchen/screens/predicted_orders/components/predicted_orders_list.dart';
import 'package:scoped_model/scoped_model.dart';
import '../common/components/scoped_progress_bar.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../service_locator.dart';

class PredictedOrdersPage extends StatefulWidget {
  static const routeName = '/predicted_orders';

  @override
  createState() => _PredictedOrdersPageState();
}

class _PredictedOrdersPageState extends State<PredictedOrdersPage> {
  final opDay = locator<ScopedOpDay>();
  final user = locator<ScopedUser>();
  final scopedLookup = locator<ScopedLookup>();

  _PredictedOrdersPageState();

  //TODO: show alert if couldn't load
  @override
  void initState() {
    super.initState();
    opDay.loadOpDay(user.getKitchenId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Expected Orders")),
        drawer: NavigationMenu(PredictedOrdersPage.routeName),
        body: ScopedModel<ScopedOpDay>(
            model: this.opDay,
            child: ScopedModel<ScopedLookup>(
                model: this.scopedLookup,
                child: RefreshIndicator(
                    onRefresh: () =>
                        opDay.loadOpDay(user.getKitchenId(), forceLoad: true),
                    child: Column(children: [
                      ScopedProgressBar<ScopedOpDay>(),
                      OpDaySelector(),
                      Expanded(child: PredictedOrdersList())
                    ])))));
  }
}

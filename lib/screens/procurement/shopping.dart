import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:kitchen/screens/common/components/scoped_progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../service_locator.dart';
import './components/shopping_lists.dart';

class ShoppingListsPage extends StatefulWidget {
  static const routeName = '/shopping_lists';

  @override
  createState() => _ShoppingListsPageState();
}

class _ShoppingListsPageState extends State<ShoppingListsPage> {
  final procurement = locator<ScopedProcurement>();
  final data = locator<ScopedLookup>();

  _ShoppingListsPageState();

  //TODO: show alert if couldn't load
  @override
  void initState() {
    super.initState();
    procurement.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Shopping Lists")),
        drawer: NavigationMenu(ShoppingListsPage.routeName),
        body: ScopedModel<ScopedProcurement>(
            model: this.procurement,
            child: ScopedModel<ScopedLookup>(
                model: this.data,
                child: RefreshIndicator(
                    onRefresh: () => procurement.loadOrders(forceLoad: true),
                    child: Column(children: [
                      ScopedProgressBar<ScopedProcurement>(),
                      Expanded(child: ShoppingLists())
                    ])))));
  }
}

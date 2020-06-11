import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/inventory_list.dart';
import './components/inventory_progress_bar.dart';
import '../../scoped_models/scoped_inventory.dart';

class InventoryPage extends StatefulWidget {
  @override
  createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final inventory = ScopedInventory();

  @override
  void initState() {
    super.initState();
    inventory.loadInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventory Checklist")),
      body: ScopedModel<ScopedInventory>(
        model: this.inventory,
        child: RefreshIndicator(
          onRefresh: inventory.loadInventory,
          child: Column(children: [
            InventoryProgressBar(),
            Expanded(child: InventoryList())
          ])
        )
      )
    );
  }
}
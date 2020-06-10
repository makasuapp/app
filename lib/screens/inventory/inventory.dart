import 'package:flutter/material.dart';
import './components/inventory_list.dart';
import '../../models/ingredient.dart';

//TODO: change this to scoped_model
class InventoryPage extends StatefulWidget {
  @override
  createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Ingredient> ingredients = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventory Checklist")),
      body: InventoryList(this.ingredients)
    );
  }

  loadData() async {
    final ingredients = await Ingredient.fetchAll();
    setState(() {
      this.ingredients = ingredients;
    });
  }
}
import 'package:flutter/material.dart';
import '../../../screens/common/progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_inventory.dart';

class InventoryProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedInventory>(
      builder: (context, child, scopedInventory) => 
        ProgressBar(scopedInventory.isLoading)
    );
  }
}
import 'package:flutter/material.dart';
import 'package:kitchen/models/procurement_item.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';
import '../../common/components/swipable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'shopping_list_item.dart';
import 'got_dialog.dart';

class SwipableShoppingItem extends StatelessWidget {
  final ProcurementItem item;

  SwipableShoppingItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedLookup>(
        builder: (_, __, scopedLookup) =>
            ScopedModelDescendant<ScopedProcurement>(
                builder: (_, __, scopedProcurement) {
              return _renderItem(context, scopedLookup, scopedProcurement);
            }));
  }

  void _undoGotten(ScopedProcurement scopedProcurement) {
    scopedProcurement.updateItem(item);
  }

  void _updateGotten(
      ScopedProcurement scopedProcurement, BuildContext context) {
    showDialog(
        context: context,
        child: GotDialog(
            initQty: this.item.quantity,
            initUnit: this.item.unit,
            onCancel: (dialogContext) {
              //bring back the item as is so it doesn't get dismissed
              scopedProcurement.updateItem(item,
                  gotQty: item.gotQty,
                  gotUnit: item.gotUnit,
                  priceCents: item.priceCents);
              Navigator.of(dialogContext).pop();
            },
            onSubmit: (gotQty, gotUnit, priceCents, dialogContext) {
              scopedProcurement.updateItem(item,
                  gotQty: gotQty, gotUnit: gotUnit, priceCents: priceCents);
              Navigator.of(dialogContext).pop();
            }));
  }

  Widget _renderItem(BuildContext context, ScopedLookup scopedLookup,
      ScopedProcurement scopedProcurement) {
    return Swipable(
        canSwipeLeft: () => Future.value(true),
        canSwipeRight: () => Future.value(
            this.item.gotQty == null || this.item.gotQty < this.item.quantity),
        onSwipeRight: (_) => _updateGotten(scopedProcurement, context),
        onSwipeLeft: (_) {
          if (this.item.gotQty != null) {
            _undoGotten(scopedProcurement);
          } else {
            //don't prompt dialog, we don't actually need this
            scopedProcurement.updateItem(
              item,
              gotQty: item.quantity,
              gotUnit: item.unit,
            );
          }
        },
        child: InkWell(
            onTap: () => _updateGotten(scopedProcurement, context),
            child: ShoppingListItem(this.item, (bool nowChecked) {
              if (nowChecked) {
                _updateGotten(scopedProcurement, context);
              } else {
                _undoGotten(scopedProcurement);
              }
            })));
  }
}

import 'package:flutter/material.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:kitchen/screens/prep/components/prep_list.dart';
import 'package:kitchen/screens/prep/components/swipable_prep_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';
import '../../common/components/swipable.dart';

enum PrepQtyTypes { madeQty, expectedQty, nullQty }

class SwipableSubrecipeItem extends StatelessWidget {
  final bool prepsDone;
  final SubrecipeData subrecipeData;
  final Function(
          String notificationText, BuildContext context, Function() onTap)
      notifyQtyUpdate;

  SwipableSubrecipeItem(
      this.prepsDone, this.subrecipeData, this.notifyQtyUpdate);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayPrep>(
        builder: (context, child, scopedPrep) =>
            _renderSubrecipe(context, scopedPrep));
  }

  Widget _renderSubrecipe(
    BuildContext context,
    ScopedDayPrep scopedPrep,
  ) {
    return Swipable(
        canSwipeLeft: () => Future.value(prepsDone),
        canSwipeRight: () => Future.value(!prepsDone),
        onSwipeLeft: (context) {
          final prepWithQty =
              _getPrepIdWithQtyMap(subrecipeData.preps, PrepQtyTypes.nullQty);
          scopedPrep.updatePrepQtys(prepWithQty);
          this.notifyQtyUpdate("Recipe not done", context, () {
            final prepWithQty =
                _getPrepIdWithQtyMap(subrecipeData.preps, PrepQtyTypes.madeQty);
            scopedPrep.updatePrepQtys(prepWithQty);
          });
        },
        onSwipeRight: (context) {
          final prepWithQty = _getPrepIdWithQtyMap(
              subrecipeData.preps, PrepQtyTypes.expectedQty);
          scopedPrep.updatePrepQtys(prepWithQty);
          this.notifyQtyUpdate("Recipe done", context, () {
            final prepWithQty =
                _getPrepIdWithQtyMap(subrecipeData.preps, PrepQtyTypes.madeQty);
            scopedPrep.updatePrepQtys(prepWithQty);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: (prepsDone)
              ? PrepStyles.listItemBorderDoneItems
              : PrepStyles.listItemBorder,
          child: ListTileTheme(
              contentPadding: PrepStyles.subrecipeTilePadding,
              child: ExpansionTile(
                  title: Text(
                    "Prepare ${subrecipeData.recipe.name}",
                    style: PrepStyles.listItemText,
                  ),
                  subtitle: _renderSubRecipeIngredients(
                      subrecipeData.inputs, subrecipeData.prepQtyForInput),
                  backgroundColor:
                      (!prepsDone) ? PrepStyles.subrecipeItemColor : null,
                  children: subrecipeData.preps
                      .map((e) => SwipablePrepItem(e, this.notifyQtyUpdate))
                      .toList())),
        ));
  }

  Widget _renderSubRecipeIngredients(
      Set<StepInput> inputs, Map<String, double> qtys) {
    if (inputs.length > 0) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Container(
                  padding: PrepStyles.ingredientsHeaderPadding,
                  child: Text(
                    "Ingredients",
                    style: PrepStyles.ingredientsHeader,
                  ),
                )
              ] +
              inputs.map((input) {
                return InputWithQuantity(input.name, qtys[input.name],
                    input.inputableType, input.unit,
                    regularTextStyle: PrepStyles.ingredientText,
                    adjustedQtyStyle: PrepStyles.remainingIngredientText,
                    originalQtyStyle: PrepStyles.totalIngredientText);
              }).toList());
    } else {
      return Container(height: 0, width: 0);
    }
  }

  Map<int, double> _getPrepIdWithQtyMap(
      List<DayPrep> preps, PrepQtyTypes qtyType) {
    var prepWithQtys = Map<int, double>();
    preps.forEach((prep) {
      prepWithQtys[prep.id] = _getPrepQtyFromQtyTypes(prep, qtyType);
    });
    return prepWithQtys;
  }

  double _getPrepQtyFromQtyTypes(DayPrep prep, PrepQtyTypes qtyType) {
    switch (qtyType) {
      case PrepQtyTypes.expectedQty:
        return prep.expectedQty;
      case PrepQtyTypes.madeQty:
        return prep.madeQty;
      case PrepQtyTypes.nullQty:
        return null;
      default:
        return null;
    }
  }
}

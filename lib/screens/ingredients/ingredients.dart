import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:kitchen/screens/common/components/op_day_selector.dart';
import 'package:scoped_model/scoped_model.dart';
import 'components/ingredients_list.dart';
import '../common/components/scoped_progress_bar.dart';
import 'package:kitchen/scoped_models/scoped_day_input.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import '../../service_locator.dart';

class IngredientsChecklistPage extends StatefulWidget {
  static const routeName = '/ingredients';

  @override
  createState() => _IngredientsChecklistPageState();
}

class _IngredientsChecklistPageState extends State<IngredientsChecklistPage> {
  final opDay = locator<ScopedOpDay>();
  final user = locator<ScopedUser>();
  final scopedDayInput = locator<ScopedDayInput>();

  _IngredientsChecklistPageState();

  //TODO: show alert if couldn't load
  @override
  void initState() {
    super.initState();
    opDay.loadOpDay(user.getKitchenId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Ingredients Checklist")),
        drawer: NavigationMenu(IngredientsChecklistPage.routeName),
        body: ScopedModel<ScopedOpDay>(
            model: this.opDay,
            child: ScopedModel<ScopedDayInput>(
                model: this.scopedDayInput,
                child: RefreshIndicator(
                    onRefresh: () =>
                        opDay.loadOpDay(user.getKitchenId(), forceLoad: true),
                    child: Column(children: [
                      ScopedProgressBar<ScopedOpDay>(),
                      OpDaySelector(),
                      Expanded(child: IngredientsList())
                    ])))));
  }
}

import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/morning_list.dart';
import '../common/components/scoped_progress_bar.dart';
import 'package:kitchen/scoped_models/scoped_day_ingredient.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import '../../service_locator.dart';

class MorningChecklistPage extends StatefulWidget {
  static const routeName = '/morning';

  @override
  createState() => _MorningChecklistPageState();
}

class _MorningChecklistPageState extends State<MorningChecklistPage> {
  final opDay = locator<ScopedOpDay>();
  final user = locator<ScopedUser>();

  _MorningChecklistPageState();

  //TODO: show alert if couldn't load
  @override
  void initState() {
    super.initState();
    opDay.loadOpDay(user.getKitchenId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Morning Checklist")),
        drawer: NavigationMenu(MorningChecklistPage.routeName),
        body: ScopedModel<ScopedOpDay>(
            model: this.opDay,
            child: ScopedModel<ScopedDayIngredient>(
                model: this.opDay.scopedDayIngredient,
                child: RefreshIndicator(
                    onRefresh: () =>
                        opDay.loadOpDay(user.getKitchenId(), forceLoad: true),
                    child: Column(children: [
                      ScopedProgressBar<ScopedOpDay>(),
                      Expanded(child: MorningList())
                    ])))));
  }
}

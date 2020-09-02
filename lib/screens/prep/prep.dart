import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/prep_list.dart';
import '../common/components/scoped_progress_bar.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import '../../service_locator.dart';

class PrepChecklistPage extends StatefulWidget {
  static const routeName = '/prep';

  @override
  createState() => _PrepChecklistPageState();
}

class _PrepChecklistPageState extends State<PrepChecklistPage> {
  final opDay = locator<ScopedOpDay>();
  final data = locator<ScopedLookup>();
  final user = locator<ScopedUser>();

  _PrepChecklistPageState();

  //TODO: show alert if couldn't load
  @override
  void initState() {
    super.initState();
    opDay.loadOpDay(user.getKitchenId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Prep Checklist")),
        drawer: NavigationMenu(PrepChecklistPage.routeName),
        body: ScopedModel<ScopedOpDay>(
            model: this.opDay,
            child: ScopedModel<ScopedDayPrep>(
                model: this.opDay.scopedDayPrep,
                child: ScopedModel<ScopedLookup>(
                    model: this.data,
                    child: RefreshIndicator(
                        onRefresh: () => opDay.loadOpDay(user.getKitchenId(),
                            forceLoad: true),
                        child: Column(children: [
                          ScopedProgressBar<ScopedOpDay>(),
                          Expanded(child: PrepList())
                        ]))))));
  }
}

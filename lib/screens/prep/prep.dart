import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/prep_list.dart';
import '../op_day/op_day_progress_bar.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import '../../service_locator.dart';

class PrepChecklistPage extends StatefulWidget {
  final int pageId;

  PrepChecklistPage(this.pageId);

  @override
  createState() => _PrepChecklistPageState();
}

class _PrepChecklistPageState extends State<PrepChecklistPage> {
  final opDay = locator<ScopedOpDay>();
  final String title = "Prep Checklist";

  _PrepChecklistPageState();

  @override
  void initState() {
    super.initState();
    opDay.loadOpDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: NavigationMenu.navigationDrawer(this.widget.pageId),
        body: ScopedModel<ScopedOpDay>(
            model: this.opDay,
            child: ScopedModel<ScopedDayPrep>(
                model: this.opDay.scopedDayPrep,
                child: RefreshIndicator(
                    onRefresh: () => opDay.loadOpDay(forceLoad: true),
                    child: Column(children: [
                      OpDayProgressBar(),
                      Expanded(child: PrepList())
                    ])))));
  }
}

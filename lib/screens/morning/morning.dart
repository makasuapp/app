import 'package:flutter/material.dart';
import 'package:kitchen/navigation_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/morning_list.dart';
import '../common/components/scoped_progress_bar.dart';
import 'package:kitchen/scoped_models/scoped_day_ingredient.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import '../../service_locator.dart';

class MorningChecklistPage extends StatefulWidget {
  final int pageId;
  final String title;

  MorningChecklistPage(this.pageId, this.title);

  @override
  createState() => _MorningChecklistPageState();
}

class _MorningChecklistPageState extends State<MorningChecklistPage> {
  final opDay = locator<ScopedOpDay>();

  _MorningChecklistPageState();

  @override
  void initState() {
    super.initState();
    opDay.loadOpDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(this.widget.title)),
        drawer: NavigationMenu(this.widget.pageId),
        body: ScopedModel<ScopedOpDay>(
            model: this.opDay,
            child: ScopedModel<ScopedDayIngredient>(
                model: this.opDay.scopedDayIngredient,
                child: RefreshIndicator(
                    onRefresh: () => opDay.loadOpDay(forceLoad: true),
                    child: Column(children: [
                      ScopedProgressBar<ScopedOpDay>(),
                      Expanded(child: MorningList())
                    ])))));
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/morning_list.dart';
import '../op_day/op_day_progress_bar.dart';
import '../../scoped_models/scoped_op_day.dart';

class MorningChecklistPage extends StatefulWidget {
  @override
  createState() => _MorningChecklistPageState();
}

class _MorningChecklistPageState extends State<MorningChecklistPage> {
  final opDay = ScopedOpDay();

  @override
  void initState() {
    super.initState();
    opDay.loadOpDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MorningChecklist Checklist")),
      body: ScopedModel<ScopedOpDay>(
        model: this.opDay,
        child: RefreshIndicator(
          onRefresh: opDay.loadOpDay,
          child: Column(children: [
            OpDayProgressBar(),
            Expanded(child: MorningList())
          ])
        )
      )
    );
  }
}
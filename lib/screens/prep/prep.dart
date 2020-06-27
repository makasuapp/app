import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './components/prep_list.dart';
import '../op_day/op_day_progress_bar.dart';
import '../../scoped_models/scoped_op_day.dart';

class PrepChecklistPage extends StatefulWidget {
  @override
  createState() => _PrepChecklistPageState();
}

class _PrepChecklistPageState extends State<PrepChecklistPage> {
  //TODO: this should be shared with morning
  final opDay = ScopedOpDay();

  @override
  void initState() {
    super.initState();
    opDay.loadOpDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prep Checklist")),
      body: ScopedModel<ScopedOpDay>(
        model: this.opDay,
        child: RefreshIndicator(
          onRefresh: opDay.loadOpDay,
          child: Column(children: [
            OpDayProgressBar(),
            Expanded(child: PrepList())
          ])
        )
      )
    );
  }
}
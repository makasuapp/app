import 'package:flutter/material.dart';
import '../../screens/common/progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/scoped_op_day.dart';

class OpDayProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOpDay>(
      builder: (context, child, scopedOpDay) => 
        ProgressBar(scopedOpDay.isLoading)
    );
  }
}
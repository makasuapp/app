import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_api_model.dart';
import 'progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopedProgressBar<T extends ScopedApiModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<T>(
        builder: (context, child, scopedModel) =>
            ProgressBar(scopedModel.isLoading));
  }
}

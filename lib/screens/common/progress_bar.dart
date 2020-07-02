import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final bool isLoading;

  ProgressBar(this.isLoading);

  @override
  Widget build(BuildContext context) {
    return this.isLoading
        ? LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container();
  }
}

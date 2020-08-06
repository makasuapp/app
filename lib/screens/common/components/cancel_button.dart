import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class CancelButton extends StatelessWidget {
  final void Function() onCancel;
  final String btnText;

  CancelButton(this.onCancel, {this.btnText});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: Styles.cancelBtnColor,
        padding: Styles.defaultBtnPadding,
        onPressed: this.onCancel,
        child: Text(this.btnText != null ? this.btnText : "Cancel",
            style: Styles.cancelBtnText));
  }
}

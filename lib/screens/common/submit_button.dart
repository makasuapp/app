import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onSubmit;
  final String btnText;

  SubmitButton(this.onSubmit, {this.btnText});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Styles.submitBtnColor,
      textColor: Styles.submitBtnTextColor,
      padding: Styles.defaultBtnPadding,
      onPressed: this.onSubmit,
      child: Text(this.btnText != null ? this.btnText : "Submit", style: Styles.defaultBtnText)
    );
  }
}
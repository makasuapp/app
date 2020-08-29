import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kitchen/styles.dart';

class LinkText {
  final String text;
  final String url;

  LinkText(this.text, this.url);

  //for some reason, making this a method to make it look like a widget breaks...
  TextSpan build() {
    return TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            launch(url);
          },
        text: this.text,
        style: Styles.textHyperlink);
  }
}

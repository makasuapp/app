import 'package:flutter/material.dart';
import '../order_styles.dart';

class Comment extends StatelessWidget {
  final String comment;

  Comment(this.comment);

  @override
  Widget build(BuildContext context) {
    if (this.comment == null) {
      return Container();
    } else {
      return Wrap(
          children: [Text(this.comment, style: OrderStyles.commentText)]);
    }
  }
}

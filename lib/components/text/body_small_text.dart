import 'package:flutter/material.dart';

class BodySmallText extends StatelessWidget {
  BodySmallText({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}

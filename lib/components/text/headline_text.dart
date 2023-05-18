import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HeadlineText extends StatelessWidget {
  HeadlineText({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}

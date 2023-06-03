import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ContentsTitleText extends StatelessWidget {
  ContentsTitleText({
    super.key,
    required this.text,
    this.icon,
    this.sub,
    this.preffix,
  });

  Widget? preffix;
  String text;
  IconData? icon;
  List<Widget>? sub;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(width: 3),
            Icon(
              icon,
              size: 18,
              color: buttonBackgroundColor,
            )
          ],
        ),
        Row(children: sub ?? []),
      ],
    );
  }
}

     // Text(
          //   isAction != null ? '$actionText' : '',
          //   style: const TextStyle(color: disEnabledTypeColor),
          // )
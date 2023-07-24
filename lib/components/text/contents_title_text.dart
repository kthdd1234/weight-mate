import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ContentsTitleText extends StatelessWidget {
  ContentsTitleText(
      {super.key,
      required this.text,
      this.icon,
      this.sub,
      this.preffix,
      this.fontSize});

  Widget? preffix;
  String text;
  IconData? icon;
  List<Widget>? sub;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              text,
              style: fontSize != null
                  ? TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)
                  : Theme.of(context).textTheme.labelLarge,
            ),
            icon != null
                ? Row(
                    children: [
                      SpaceWidth(width: 3),
                      Icon(
                        icon,
                        size: 18,
                        color: buttonBackgroundColor,
                      ),
                    ],
                  )
                : const EmptyArea()
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
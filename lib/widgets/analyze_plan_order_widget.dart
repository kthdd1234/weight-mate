import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/sub_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzePlanOrderWidget extends StatelessWidget {
  AnalyzePlanOrderWidget({
    super.key,
    required this.index,
    required this.count,
    required this.icon,
    required this.text,
  });

  int index;
  int count;
  IconData icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextIcon(
              backgroundColor: typeBackgroundColor,
              text: '$index',
              borderRadius: 5,
              textColor: buttonBackgroundColor,
              fontSize: 12,
            ),
            SpaceWidth(width: smallSpace),
            CircularIcon(
              size: 40,
              borderRadius: 40,
              icon: icon,
              backgroundColor: typeBackgroundColor,
            ),
            SpaceWidth(width: smallSpace),
            Expanded(flex: 3, child: SubText(text: text, value: '')),
            TextIcon(
              backgroundColor: typeBackgroundColor,
              text: '$count회',
              borderRadius: 7,
              textColor: buttonBackgroundColor,
              fontSize: 10,
            ),
          ],
        ),
        SpaceHeight(height: regularSapce)
      ],
    );
  }
}

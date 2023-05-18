import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class IconText extends StatelessWidget {
  IconText({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.text,
    required this.textColor,
    required this.textSize,
  });

  IconData icon;
  Color iconColor;
  double iconSize;
  String text;
  Color textColor;
  double textSize;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: iconSize, color: iconColor),
      SpaceWidth(width: tinySpace),
      Text(
        text,
        style: TextStyle(color: textColor, fontSize: textSize),
      )
    ]);
  }
}
// 17 , 13
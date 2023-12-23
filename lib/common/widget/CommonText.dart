import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonText extends StatelessWidget {
  CommonText(
      {super.key,
      required this.text,
      required this.size,
      this.isBold,
      this.leftIcon,
      this.rightIcon,
      this.color,
      this.isLineThrough,
      this.isCenter,
      this.onTap});

  String text;
  double size;
  bool? isCenter;
  bool? isBold;
  IconData? leftIcon, rightIcon;
  Color? color;
  bool? isLineThrough;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: isCenter == true
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          leftIcon != null
              ? Row(children: [
                  Icon(leftIcon, size: size, color: color),
                  SpaceWidth(width: 3)
                ])
              : const EmptyArea(),
          Text(
            text,
            style: TextStyle(
              color: color ?? themeColor,
              fontSize: size,
              fontWeight: isBold == true ? FontWeight.bold : null,
              decoration:
                  isLineThrough == true ? TextDecoration.lineThrough : null,
              decorationThickness: 2,
              decorationColor: Colors.grey,
            ),
          ),
          rightIcon != null
              ? Row(children: [
                  SpaceWidth(width: 3),
                  Icon(leftIcon, size: size, color: color),
                ])
              : const EmptyArea()
        ],
      ),
    );
  }
}

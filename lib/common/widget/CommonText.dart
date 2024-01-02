import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonText extends StatelessWidget {
  CommonText({
    super.key,
    required this.text,
    required this.size,
    this.isBold,
    this.leftIcon,
    this.rightIcon,
    this.color,
    this.decoration,
    this.isCenter,
    this.isNotTop,
    this.onTap,
    this.isWidth,
    this.decoColor,
  });

  String text;
  double size;
  bool? isCenter;
  bool? isBold;
  IconData? leftIcon, rightIcon;
  Color? color, decoColor;
  String? decoration;
  bool? isNotTop;
  bool? isWidth;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    TextDecoration? textDecoration = {
      'lineThrough': TextDecoration.lineThrough,
      'underLine': TextDecoration.underline
    }[decoration];

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
                  SpaceWidth(width: tinySpace)
                ])
              : const EmptyArea(),
          Padding(
            padding: EdgeInsets.only(top: isNotTop == true ? 0 : 2),
            child: SizedBox(
              width: isWidth == true
                  ? MediaQuery.of(context).size.width - 80
                  : null,
              child: Text(
                text,
                style: TextStyle(
                  color: color ?? themeColor,
                  fontSize: size,
                  fontWeight: isBold == true ? FontWeight.bold : null,
                  decoration: textDecoration,
                  decorationThickness: 2,
                  decorationColor: decoColor ?? themeColor,
                ),
              ),
            ),
          ),
          rightIcon != null
              ? Row(children: [
                  // SpaceWidth(width: 3),
                  Icon(rightIcon, size: size + 3, color: color),
                ])
              : const EmptyArea()
        ],
      ),
    );
  }
}

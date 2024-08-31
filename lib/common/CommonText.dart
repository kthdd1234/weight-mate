import 'package:easy_localization/easy_localization.dart';
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
    this.isNotTr,
    this.nameArgs,
    this.iconSize,
    this.iconColor,
  });

  String text;
  double size;
  bool? isCenter;
  bool? isBold;
  IconData? leftIcon, rightIcon;
  Color? color, decoColor, iconColor;
  String? decoration;
  bool? isNotTop, isNotTr;
  bool? isWidth;
  Map<String, String>? nameArgs;
  double? iconSize;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    TextDecoration? textDecoration = {
      'none': TextDecoration.none,
      'lineThrough': TextDecoration.lineThrough,
      'underLine': TextDecoration.underline
    }[decoration];

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: isCenter == true
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          leftIcon != null
              ? Row(children: [
                  Icon(leftIcon,
                      size: iconSize ?? size + 1, color: iconColor ?? color),
                  SpaceWidth(width: tinySpace)
                ])
              : const EmptyArea(),
          Padding(
            padding: EdgeInsets.only(top: leftIcon == null ? 0 : 2),
            child: SizedBox(
              child: Text(
                isNotTr == true ? text : text.tr(namedArgs: nameArgs),
                style: TextStyle(
                  color: color ?? textColor,
                  fontSize: size,
                  fontWeight:
                      isBold == true ? FontWeight.w700 : FontWeight.w400,
                  decoration: textDecoration,
                  decorationThickness: 1,
                  decorationColor: decoColor ?? textColor,
                ),
              ),
            ),
          ),
          rightIcon != null
              ? Row(children: [
                  SpaceWidth(width: 3),
                  Icon(rightIcon, size: iconSize ?? size + 3, color: color),
                ])
              : const EmptyArea()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TextIcon extends StatelessWidget {
  TextIcon({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.borderRadius,
    required this.textColor,
    required this.fontSize,
    required this.onTap,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.backgroundColorOpacity,
  });

  Color backgroundColor;
  double borderRadius;
  String text;
  Color textColor;
  double fontSize;
  IconData? icon;
  double? iconSize;
  Color? iconColor;
  double? padding;
  double? backgroundColorOpacity;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(backgroundColorOpacity ?? 1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding ?? 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Row(
                      children: [
                        Icon(icon, size: iconSize, color: iconColor),
                        SpaceWidth(width: 3),
                      ],
                    )
                  : const EmptyArea(),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

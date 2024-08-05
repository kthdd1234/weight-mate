import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_text_vertical_area.dart';

class ExpandedButtonVerti extends StatelessWidget {
  ExpandedButtonVerti({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.mainColor,
    this.backgroundColor,
    this.isBold,
    this.titleSize,
    this.iconSize,
    this.height,
    this.padding,
    this.outterPadding,
  });

  IconData icon;
  String title;
  Color? mainColor;
  Color? backgroundColor;
  bool? isBold;
  Function() onTap;
  double? titleSize, iconSize, height;
  EdgeInsets? padding, outterPadding;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: outterPadding ?? const EdgeInsets.all(0),
        child: InkWell(
          onTap: onTap,
          child: EmptyTextVerticalArea(
            icon: icon,
            title: title,
            height: height ?? 105,
            mainColor: mainColor,
            backgroundColor: backgroundColor,
            isBold: isBold,
            iconSize: iconSize,
            titleSize: titleSize,
            padding: padding,
          ),
        ),
      ),
    );
  }
}

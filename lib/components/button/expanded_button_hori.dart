import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ExpandedButtonHori extends StatelessWidget {
  ExpandedButtonHori({
    super.key,
    required this.text,
    required this.onTap,
    this.fontSize,
    this.imgUrl,
    this.color,
    this.icon,
    this.padding,
    this.borderRadius,
    this.nameArgs,
    this.flex,
    this.textColor,
  });

  String? imgUrl;
  Color? color, textColor;
  IconData? icon;
  String text;
  int? flex;
  EdgeInsets? padding;
  double? fontSize, borderRadius;
  Map<String, String>? nameArgs;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: InkWell(
        onTap: onTap,
        child: ContentsBox(
          borderRadius: borderRadius,
          padding: padding ?? pagePadding,
          imgUrl: imgUrl,
          backgroundColor: color,
          contentsWidget: CommonText(
            text: text,
            size: fontSize ?? 14,
            leftIcon: icon,
            isBold: true,
            isCenter: true,
            color: textColor ?? Colors.white,
            nameArgs: nameArgs,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonTag extends StatelessWidget {
  CommonTag({
    super.key,
    required this.color,
    this.text,
    this.icon,
    this.onTap,
    this.leftIcon,
    this.size,
    this.bgColor,
    this.nameArgs,
  });

  String color;
  String? text;
  IconData? icon, leftIcon;
  double? size;
  Color? bgColor;
  Map<String, String>? nameArgs;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Map<String, Color> tagColor = tagColors[color]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? tagColor['bgColor'],
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: text != null
            ? CommonText(
                text: text ?? '',
                color: tagColor['textColor'],
                size: size ?? 10,
                isCenter: true,
                isBold: true,
                isNotTop: true,
                leftIcon: leftIcon,
                nameArgs: nameArgs,
              )
            : Icon(icon, size: 15, color: tagColor['textColor']),
      ),
    );
  }
}

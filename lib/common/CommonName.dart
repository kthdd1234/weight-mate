import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonName extends StatelessWidget {
  CommonName({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.isNotTr,
    this.isBold,
    this.highlightColor,
    this.nameArgs,
    this.onTap,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.decorationColor,
  });

  String text;
  Color? color;
  double? fontSize;
  bool? isNotTr, isBold;
  Color? highlightColor;
  Map<String, String>? nameArgs;
  TextAlign? textAlign;
  TextOverflow? overflow;
  bool? softWrap;
  TextDecoration? decoration;
  Color? decorationColor;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(highlightColor != null ? 3 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: highlightColor,
      ),
      child: Text(
        isNotTr == true ? text : text.tr(namedArgs: nameArgs),
        textAlign: textAlign ?? TextAlign.center,
        softWrap: softWrap ?? true,
        style: TextStyle(
          color: color ?? textColor,
          fontSize: fontSize,
          fontWeight: isBold == true ? FontWeight.bold : FontWeight.w400,
          overflow: overflow,
          decoration: decoration,
          decorationColor: decorationColor,
        ),
      ),
    );
  }
}

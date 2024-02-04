import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonButton extends StatelessWidget {
  CommonButton({
    super.key,
    required this.text,
    required this.fontSize,
    required this.bgColor,
    required this.radious,
    required this.textColor,
    required this.onTap,
    this.isBold,
    this.height,
    this.isNotTr,
  });

  String text;
  double fontSize, radious;
  Color bgColor, textColor;
  double? height;
  bool? isBold, isNotTr;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? largeSpace,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radious),
          ),
          child: CommonText(
            text: text,
            size: fontSize,
            color: textColor,
            isCenter: true,
            isBold: isBold == true,
            isNotTr: isNotTr == true,
          ),
        ),
      ),
    );
  }
}

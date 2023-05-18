import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TextIcon extends StatelessWidget {
  TextIcon(
      {super.key,
      required this.backgroundColor,
      required this.text,
      required this.borderRadius,
      required this.textColor,
      required this.fontSize});

  Color backgroundColor;
  double borderRadius;
  String text;
  Color textColor;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(smallSpace),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

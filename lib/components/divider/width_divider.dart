import 'package:flutter/material.dart';

class WidthDivider extends StatelessWidget {
  WidthDivider({
    super.key,
    required this.width,
    this.height,
    this.color,
  });

  double width;
  double? height;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 1,
      color: color ?? const Color(0xffEEF1F3),
    );
  }
}

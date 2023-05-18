import 'package:flutter/material.dart';

class HeightDivider extends StatelessWidget {
  HeightDivider({
    super.key,
    required this.height,
    this.width,
    this.color,
  });

  double height;
  double? width;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 1,
      height: height,
      color: color ?? const Color(0xffEEF1F3),
    );
  }
}

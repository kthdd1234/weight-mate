import 'package:flutter/material.dart';

class HeightDivider extends StatelessWidget {
  HeightDivider(
      {super.key,
      required this.height,
      this.width,
      this.color,
      this.borderRadius});

  double height;
  double? width;
  Color? color;
  BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 1,
      height: height,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: color ?? const Color(0xffEEF1F3),
        borderRadius: borderRadius,
      ),
    );
  }
}

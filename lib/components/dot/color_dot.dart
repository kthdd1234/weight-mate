import 'package:flutter/material.dart';

class ColorDot extends StatelessWidget {
  ColorDot({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.isOutlined,
  });

  double width;
  double height;
  bool? isOutlined;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: isOutlined == true
          ? BoxDecoration(
              border: Border.all(width: 1, color: color),
              borderRadius: BorderRadius.circular(30),
            )
          : BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
    );
  }
}

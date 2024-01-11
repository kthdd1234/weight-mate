import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  Dot({
    super.key,
    required this.size,
    required this.color,
    this.isOutlined,
  });

  double size;
  bool? isOutlined;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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

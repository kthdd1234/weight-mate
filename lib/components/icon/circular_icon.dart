import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CircularIcon extends StatelessWidget {
  CircularIcon(
      {super.key,
      required this.widthAndHeight,
      required this.borderRadius,
      required this.icon,
      required this.backgroundColor});

  double widthAndHeight;
  double borderRadius;
  IconData icon;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthAndHeight,
      height: widthAndHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(smallSpace),
        child: Icon(
          icon,
          size: widthAndHeight - 20,
          color: buttonBackgroundColor,
        ),
      ),
    );
  }
}

// 45
// 45
// 10
// Icons.time_to_leave

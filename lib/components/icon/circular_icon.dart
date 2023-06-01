import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CircularIcon extends StatelessWidget {
  CircularIcon({
    super.key,
    required this.size,
    required this.borderRadius,
    required this.icon,
    required this.backgroundColor,
    this.adjustSize,
    this.id,
    this.onTap,
  });

  double size;
  double borderRadius;
  IconData icon;
  Color backgroundColor;
  double? adjustSize;
  dynamic id;
  Function(dynamic id)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap != null ? onTap!(id) : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          icon,
          size: size - (adjustSize ?? 20),
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

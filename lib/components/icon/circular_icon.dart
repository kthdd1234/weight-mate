import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CircularIcon extends StatelessWidget {
  CircularIcon(
      {super.key,
      required this.size,
      required this.borderRadius,
      this.icon,
      required this.backgroundColor,
      this.adjustSize,
      this.id,
      this.onTap,
      this.iconColor,
      this.borderColor,
      this.backgroundColorOpacity,
      this.padding});

  double size;
  double borderRadius;
  IconData? icon;
  Color backgroundColor;
  double? adjustSize;
  dynamic id;
  Function(dynamic id)? onTap;
  Color? iconColor;
  Color? borderColor;
  double? backgroundColorOpacity;
  double? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap != null ? onTap!(id) : null,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(backgroundColorOpacity ?? 1),
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Icon(
            icon,
            size: size - (adjustSize ?? 20),
            color: iconColor ?? themeColor,
          ),
        ),
      ),
    );
  }
}

// 45
// 45
// 10
// Icons.time_to_leave

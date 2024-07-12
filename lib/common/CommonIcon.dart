import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonIcon extends StatelessWidget {
  CommonIcon({
    super.key,
    required this.icon,
    required this.size,
    this.onTap,
    this.color,
    this.bgColor,
  });

  IconData icon;
  double size;
  Color? color, bgColor;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(bgColor != null ? 3 : 0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(bgColor != null ? 5 : 0),
        ),
        child: Icon(icon, size: size, color: color ?? textColor),
      ),
    );
  }
}

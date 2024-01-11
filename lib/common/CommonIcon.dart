import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonIcon extends StatelessWidget {
  CommonIcon({
    super.key,
    required this.icon,
    required this.size,
    this.onTap,
    this.color,
  });

  IconData icon;
  double size;
  Color? color;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Icon(icon, size: size, color: color ?? themeColor));
  }
}

import 'package:flutter/material.dart';

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
    return InkWell(onTap: onTap, child: Icon(icon, size: size, color: color));
  }
}

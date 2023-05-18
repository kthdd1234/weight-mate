import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class PopupMenuItemText extends StatelessWidget {
  PopupMenuItemText({
    super.key,
    required this.icon,
    required this.text,
  });

  IconData icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: buttonBackgroundColor),
        SpaceWidth(width: smallSpace),
        Text(
          text,
          style: const TextStyle(color: buttonBackgroundColor),
        ),
      ],
    );
  }
}

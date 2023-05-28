import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DefaultIcon extends StatelessWidget {
  DefaultIcon({
    super.key,
    required this.id,
    required this.icon,
    required this.onTap,
    this.color,
  });

  dynamic id;
  IconData icon;
  Function(String id) onTap;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceWidth(width: 7.5),
        InkWell(
          onTap: () => onTap(id),
          child: Icon(
            icon,
            size: 21,
            color: color ?? buttonBackgroundColor,
          ),
        ),
      ],
    );
  }
}

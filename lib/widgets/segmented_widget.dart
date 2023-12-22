import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SegmentedWidget extends StatelessWidget {
  SegmentedWidget({
    super.key,
    required this.title,
    this.color,
  });

  String title;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        color != null
            ? ColorDot(width: 7.5, height: 7.5, color: color!)
            : const EmptyArea(),
        color != null ? SpaceWidth(width: tinySpace) : const EmptyArea(),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: themeColor,
          ),
        ),
      ],
    );
  }
}

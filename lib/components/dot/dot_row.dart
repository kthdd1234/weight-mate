import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DotRow extends StatelessWidget {
  DotRow({super.key, required this.row});

  List<String?> row;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((name) {
        Color color =
            name != null ? tagColors[name]!['textColor']! : whiteBgBtnColor;
        return Row(
          children: [Dot(size: 5, color: color), SpaceWidth(width: 3)],
        );
      }).toList(),
    );
  }
}

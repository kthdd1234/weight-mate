import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class StickerMaker extends StatelessWidget {
  StickerMaker({
    super.key,
    required this.row1,
    required this.row2,
    this.mainAxisAlignment,
  });

  List<String?> row1, row2;
  MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
      children: [
        DotRow(row: row1),
        SpaceHeight(height: 3),
        DotRow(row: row2),
      ],
    );
  }
}

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

class Dot extends StatelessWidget {
  Dot({
    super.key,
    required this.size,
    required this.color,
    this.isOutlined,
  });

  double size;
  bool? isOutlined;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: isOutlined == true
          ? BoxDecoration(
              border: Border.all(width: 1, color: color),
              borderRadius: BorderRadius.circular(30),
            )
          : BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
    );
  }
}

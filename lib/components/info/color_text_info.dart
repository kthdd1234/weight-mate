import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ColorTextInfo extends StatelessWidget {
  ColorTextInfo({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.color,
    this.isOutlined,
  });

  double width;
  double height;
  String text;
  Color color;
  bool? isOutlined;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceWidth(width: smallSpace),
        ColorDot(
          width: width,
          height: height,
          color: color,
          isOutlined: isOutlined,
        ),
        SpaceWidth(width: tinySpace),
        BodySmallText(text: text),
      ],
    );
  }
}

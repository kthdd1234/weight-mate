import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonTag extends StatelessWidget {
  CommonTag({
    super.key,
    required this.color,
    required this.text,
  });

  String color, text;

  @override
  Widget build(BuildContext context) {
    Map<String, Color> tagColor = tagColors[color]!;

    return Container(
      decoration: BoxDecoration(
        // color: tagColor['textColor'],
        borderRadius: BorderRadius.circular(5),
      ),
      // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      child: CommonText(
        text: text,
        color: Colors.grey,
        size: 11,
        isBold: true,
        isNotTop: true,
      ),
    );
  }
}

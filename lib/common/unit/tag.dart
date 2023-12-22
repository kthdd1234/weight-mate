import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class Tag extends StatelessWidget {
  Tag({
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
        color: tagColor['bgColor'],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            size: 16,
            color: tagColor['textColor'],
          ),
          SpaceWidth(width: tinySpace),
          Text(
            text,
            style: TextStyle(
              color: tagColor['textColor'],
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

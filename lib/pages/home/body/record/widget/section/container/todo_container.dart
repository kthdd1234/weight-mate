import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TodoContainer extends StatelessWidget {
  TodoContainer({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });

  String color, text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    Color mainColor = tagColors[color]!['textColor']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16),
                SpaceWidth(width: tinySpace),
                Text(
                  text,
                  style: const TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const Icon(Icons.add_circle, color: themeColor),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: smallSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 0,
                child: Icon(Icons.check_box_rounded, color: mainColor),
              ),
              SpaceWidth(width: tinySpace),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🍎사과 1개, 🍠 고구마 반쪽',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                        decorationColor: Colors.grey,
                      ),
                    ),
                    SpaceHeight(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 13,
                          color: themeColor,
                        ),
                        SpaceWidth(width: tinySpace),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '오전 08:30',
                            style: TextStyle(color: themeColor, fontSize: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.more_horiz, color: Colors.grey),
                    // SpaceHeight(height: 3),
                    // Text(
                    //   '오전 08:30',
                    //   style: TextStyle(color: mainColor, fontSize: 12),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
    );
  }
}

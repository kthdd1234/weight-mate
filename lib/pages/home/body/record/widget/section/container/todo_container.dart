import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TodoContainer extends StatelessWidget {
  TodoContainer({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
  });

  String color, title;
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
            CommonText(text: title, size: 15, leftIcon: icon, isBold: true),
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
                    CommonText(text: '🍎 테스트', size: 15, color: Colors.grey),
                    SpaceHeight(height: 3),
                    CommonText(
                      text: '오전 08:30',
                      size: 12,
                      leftIcon: Icons.notifications_active,
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Icon(Icons.more_horiz, color: Colors.grey)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

        // SpaceHeight(height: 3),
                    // Text(
                    //   '오전 08:30',
                    //   style: TextStyle(color: mainColor, fontSize: 12),
                    // ),

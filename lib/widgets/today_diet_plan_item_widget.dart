import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TodayDietPlanItemWidget extends StatelessWidget {
  TodayDietPlanItemWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.isAction,
  });

  IconData icon;
  String text;
  bool isAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpaceHeight(height: tinySpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircularIcon(
                  widthAndHeight: 40,
                  borderRadius: 10,
                  icon: icon,
                  backgroundColor: typeBackgroundColor,
                ),
                SpaceWidth(width: smallSpace),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    text,
                    style: TextStyle(
                        decoration:
                            isAction ? TextDecoration.lineThrough : null),
                  ),
                ),
              ],
            ),
            isAction
                ? const Icon(
                    Icons.task_alt_sharp,
                    color: buttonBackgroundColor,
                    size: 20,
                  )
                : const EmptyArea(),
          ],
        ),
        SpaceHeight(height: smallSpace + tinySpace),
      ],
    );
  }
}

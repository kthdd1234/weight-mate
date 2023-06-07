import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class PlanItemInfo extends StatelessWidget {
  PlanItemInfo({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    required this.name,
    required this.startDateTime,
    this.endDateTime,
    required this.onTap,
    required this.isAlarm,
    required this.alarmTime,
  });

  String id, title, name;
  IconData icon;
  DateTime startDateTime;
  DateTime? endDateTime, alarmTime;
  Function(String id) onTap;
  bool isAlarm;

  @override
  Widget build(BuildContext context) {
    iconText({required IconData icon, required String text}) {
      return Row(
        children: [
          Icon(icon, size: 18, color: buttonBackgroundColor),
          SpaceWidth(width: tinySpace),
          Text(
            text,
            style: const TextStyle(color: buttonBackgroundColor, fontSize: 12),
          )
        ],
      );
    }

    return InkWell(
      onTap: () => onTap(id),
      child: ContentsBox(
        backgroundColor: dialogBackgroundColor,
        contentsWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodySmallText(text: title),
                SpaceHeight(height: smallSpace),
                Text(
                  name,
                  style: const TextStyle(color: buttonBackgroundColor),
                ),
                SpaceHeight(height: smallSpace),
                iconText(
                  icon: Icons.calendar_month,
                  text:
                      '${dateTimeToDotYY(startDateTime)} ~ ${dateTimeToDotYY(endDateTime)}',
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircularIcon(
                  size: 35,
                  borderRadius: 10,
                  icon: icon,
                  backgroundColor: typeBackgroundColor,
                  adjustSize: 15,
                ),
                SpaceHeight(height: regularSapce),
                isAlarm
                    ? TextIcon(
                        backgroundColor: enableBackgroundColor,
                        text: timeToString(alarmTime),
                        borderRadius: 10,
                        textColor: enableTextColor,
                        fontSize: 10,
                        icon: Icons.notifications_active,
                        iconSize: 13,
                        iconColor: enableTextColor,
                      )
                    : TextIcon(
                        backgroundColor: disabledButtonBackgroundColor,
                        text: '알림 OFF',
                        borderRadius: 10,
                        textColor: disEnabledTypeColor,
                        fontSize: 10,
                        iconSize: 13,
                        iconColor: disEnabledTypeColor,
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
 // SpaceHeight(height: tinySpace),
                        // iconText(
                        //   icon: Icons.notifications_active_outlined,
                        //   text: timeToString(alarmDateTime),
                        // ),
import 'package:flutter/material.dart';
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
    required this.groupName,
    required this.icon,
    required this.itemName,
    required this.startDateTime,
    required this.endDateTime,
    required this.isAct,
    required this.onTap,
  });

  String id, groupName, itemName;
  IconData icon;
  DateTime startDateTime, endDateTime;
  bool isAct;
  Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    iconTextWidget({required IconData icon, required String text}) {
      return Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: buttonBackgroundColor,
          ),
          SpaceWidth(width: tinySpace),
          Text(
            text,
            style: TextStyle(
              color: buttonBackgroundColor,
              fontSize: 12,
            ),
          )
        ],
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: () => onTap(id),
          child: ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodySmallText(text: groupName),
                    SpaceHeight(height: smallSpace),
                    Text(
                      itemName,
                      style: const TextStyle(
                        color: buttonBackgroundColor,
                      ),
                    ),
                    SpaceHeight(height: smallSpace),
                    iconTextWidget(
                      icon: Icons.calendar_month,
                      text: '23.04.31 ~ 23.06.31',
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
                    TextIcon(
                      backgroundColor:
                          isAct ? enableBackgroundColor : Color(0xffF5F6F7),
                      text: isAct ? '실천 완료!' : '미실천',
                      borderRadius: 10,
                      textColor: isAct ? enableTextColor : Color(0xff9A9EAA),
                      fontSize: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
    );
  }
}
 // SpaceHeight(height: tinySpace),
                        // iconTextWidget(
                        //   icon: Icons.notifications_active_outlined,
                        //   text: timeToString(alarmDateTime),
                        // ),
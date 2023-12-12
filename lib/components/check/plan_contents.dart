import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class PlanContents extends StatelessWidget {
  PlanContents({
    super.key,
    required this.id,
    required this.text,
    required this.type,
    required this.isChecked,
    required this.onTapCheck,
    required this.onTapContents,
    required this.checkIcon,
    required this.notCheckIcon,
    required this.notCheckColor,
    this.onTapMore,
    this.alarmTime,
    this.recordTime,
    this.createDateTime,
  });

  String id;
  String text, type;
  bool isChecked;
  IconData checkIcon, notCheckIcon;
  Color notCheckColor;
  Function({required String id, required bool isSelected}) onTapCheck;
  Function(String id) onTapContents;
  Function(String id)? onTapMore;
  DateTime? alarmTime, recordTime;
  DateTime? createDateTime;

  @override
  Widget build(BuildContext context) {
    final planInfo = planTypeDetailInfo[planType[type]]!;
    final alarmIcon = alarmTime != null
        ? Icons.notifications_active_outlined
        : Icons.notifications_off_outlined;
    final alarmBgColor =
        alarmTime != null ? Colors.blue.shade50 : Colors.grey.shade50;
    final alarmText =
        alarmTime != null ? '${timeToString(alarmTime)}' : '알림 OFF';
    final alarmColor = alarmTime != null ? Colors.blue : Colors.grey;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => onTapCheck(id: id, isSelected: !isChecked),
              child: Icon(
                isChecked ? checkIcon : notCheckIcon,
                color: isChecked ? planInfo.mainColor : notCheckColor,
              ),
            ),
            SpaceWidth(width: smallSpace),
            Expanded(
              child: InkWell(
                onTap: () => onTapContents(id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(text),
                    ),
                    SpaceHeight(height: tinySpace),
                    Row(
                      children: [
                        TextIcon(
                          backgroundColor: planInfo.shadeColor,
                          text: planInfo.title,
                          borderRadius: 5,
                          textColor: planInfo.mainColor,
                          fontSize: 10,
                          padding: 8,
                          icon: planInfo.icon,
                          iconColor: planInfo.mainColor,
                          iconSize: 14,
                        ),
                        SpaceWidth(width: tinySpace),
                        TextIcon(
                          backgroundColor: alarmBgColor,
                          text: alarmText,
                          borderRadius: 5,
                          textColor: alarmColor,
                          fontSize: 10,
                          padding: 8,
                          icon: alarmIcon,
                          iconColor: alarmColor,
                          iconSize: 14,
                        ),
                        SpaceWidth(width: tinySpace),
                        createDateTime != null
                            ? IconText(
                                icon: Icons.calendar_month,
                                iconColor: buttonBackgroundColor,
                                iconSize: 12,
                                text: dateTimeFormatter(
                                    format: 'yy.MM.dd',
                                    dateTime: createDateTime!),
                                textColor: buttonBackgroundColor,
                                textSize: 11,
                              )
                            : const EmptyArea(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onTapMore != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => onTapMore!(id),
                        child: const Icon(Icons.more_horiz, color: Colors.grey),
                      ),
                      SpaceHeight(height: smallSpace),
                      isChecked
                          ? Row(
                              children: [
                                Icon(Icons.check,
                                    size: 12, color: planInfo.mainColor),
                                SpaceWidth(width: 3),
                                Text(
                                  timeToString(recordTime),
                                  style: TextStyle(
                                      fontSize: 11, color: planInfo.mainColor),
                                ),
                              ],
                            )
                          : const EmptyArea(),
                    ],
                  )
                : const EmptyArea(),
          ],
        ),
        SpaceHeight(height: regularSapce),
      ],
    );
  }
}
           // IconText(
                        //   icon: planPrioritys[priority]!['icon'] as IconData,
                        //   iconColor: buttonBackgroundColor,
                        //   iconSize: 12,
                        //   text: planPrioritys[priority]!['name'] as String,
                        //   textColor: buttonBackgroundColor,
                        //   textSize: 11,
                        // ),
                        //          IconText(
                        //   icon: alarmTime != null
                        //       ? Icons.notifications_active
                        //       : Icons.notifications_active_outlined,
                        //   iconColor: buttonBackgroundColor,
                        //   iconSize: 12,
                        //   text:
                        //       '${alarmTime != null ? timeToString(alarmTime) : '알림 OFF'}',
                        //   textColor: buttonBackgroundColor,
                        //   textSize: 11,
                        // ),
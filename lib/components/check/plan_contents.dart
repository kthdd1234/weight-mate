import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/components/text/sub_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
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
    required this.isShowType,
    required this.priority,
    this.alarmId,
    this.onTapMore,
    this.alarmTime,
    this.recordTime,
    this.createDateTime,
  });

  String id;
  String text, type, priority;
  bool isChecked;
  bool isShowType;
  IconData checkIcon, notCheckIcon;
  Color notCheckColor;
  int? alarmId;

  Function({required String id, required bool isSelected}) onTapCheck;
  Function(String id) onTapContents;
  Function(String id)? onTapMore;
  DateTime? alarmTime, recordTime;
  DateTime? createDateTime;

  @override
  Widget build(BuildContext context) {
    PlanTypeDetailClass planInfo = planTypeDetailInfo[planType[type]]!;

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
                        isShowType
                            ? Row(
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
                                    onTap: () => onTapContents(id),
                                  ),
                                  SpaceWidth(width: tinySpace),
                                ],
                              )
                            : const EmptyArea(),
                        IconText(
                          icon: alarmTime != null
                              ? Icons.alarm
                              : Icons.alarm_off_outlined,
                          iconColor: alarmTime != null
                              ? buttonBackgroundColor
                              : Colors.grey,
                          iconSize: 12,
                          text:
                              '${alarmTime != null ? timeToString(alarmTime) : '알림 없음'}',
                          textColor: alarmTime != null
                              ? buttonBackgroundColor
                              : Colors.grey,
                          textSize: 11,
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
                      SpaceHeight(height: tinySpace),
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
                               // TextIcon(
                        //   backgroundColor: priorityBgColor,
                        //   text: priorityText,
                        //   borderRadius: 5,
                        //   textColor: priorityTextColor,
                        //   fontSize: 10,
                        //   padding: 8,
                        //   icon: priorityIcon,
                        //   iconColor: priorityTextColor,
                        //   iconSize: 14,
                        // ),
                        // SpaceWidth(width: tinySpace),

    //                         IconData priorityIcon = planPrioritys[priority]!.icon;
    // String priorityText = planPrioritys[priority]!.name;
    // Color priorityBgColor = planPrioritys[priority]!.bgColor;
    // Color priorityTextColor = planPrioritys[priority]!.textColor;
    //     IconData alarmIcon = alarmTime != null
    //     ? Icons.notifications_active_outlined
    //     : Icons.notifications_off_outlined;
    // Color alarmBgColor =
    //     alarmTime != null ? Colors.blue.shade50 : Colors.grey.shade50;
    // String alarmText =
    //     alarmTime != null ? '${timeToString(alarmTime)}' : '알림 없음';
    // MaterialColor alarmColor = alarmTime != null ? Colors.blue : Colors.grey;
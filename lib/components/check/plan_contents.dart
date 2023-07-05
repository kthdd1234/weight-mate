import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class PlanContents extends StatelessWidget {
  PlanContents({
    super.key,
    required this.mainColor,
    required this.id,
    required this.text,
    required this.isChecked,
    required this.onTapCheck,
    required this.onTapContents,
    required this.priority,
    required this.checkIcon,
    required this.notCheckIcon,
    required this.notCheckColor,
    this.onTapMore,
    this.alarmTime,
    this.recordTime,
    this.createDateTime,
  });

  String id;
  String text;
  bool isChecked;
  Color mainColor;
  String priority;
  IconData checkIcon, notCheckIcon;
  Color notCheckColor;
  Function({required String id, required bool isSelected}) onTapCheck;
  Function(String id) onTapContents;
  Function(String id)? onTapMore;
  DateTime? alarmTime, recordTime;
  DateTime? createDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => onTapCheck(id: id, isSelected: !isChecked),
              child: Icon(
                isChecked ? checkIcon : notCheckIcon,
                color: isChecked ? mainColor : notCheckColor,
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
                        IconText(
                          icon: planPrioritys[priority]!['icon'] as IconData,
                          iconColor: buttonBackgroundColor,
                          iconSize: 12,
                          text: planPrioritys[priority]!['name'] as String,
                          textColor: buttonBackgroundColor,
                          textSize: 11,
                        ),
                        SpaceWidth(width: tinySpace),
                        IconText(
                          icon: alarmTime != null
                              ? Icons.notifications_active
                              : Icons.notifications_active_outlined,
                          iconColor: buttonBackgroundColor,
                          iconSize: 12,
                          text:
                              '${alarmTime != null ? timeToString(alarmTime) : '알림 OFF'}',
                          textColor: buttonBackgroundColor,
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
                      isChecked
                          ? Row(
                              children: [
                                Icon(Icons.check, size: 12, color: mainColor),
                                SpaceWidth(width: 3),
                                Text(
                                  timeToString(recordTime),
                                  style:
                                      TextStyle(fontSize: 11, color: mainColor),
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

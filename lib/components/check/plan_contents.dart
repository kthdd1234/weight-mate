import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class PlanContents extends StatelessWidget {
  PlanContents({
    super.key,
    required this.mainColor,
    required this.id,
    required this.text,
    required this.isAction,
    required this.onTapCheck,
    required this.onTapContents,
    required this.onTapMore,
    required this.startDateTime,
    this.endDateTime,
    this.alarmTime,
    this.recordTime,
  });

  String id;
  String text;
  bool isAction;
  Color mainColor;
  Function({required String id, required bool isSelected}) onTapCheck;
  Function(String id) onTapContents;
  Function(String id) onTapMore;
  DateTime startDateTime;
  DateTime? endDateTime, alarmTime, recordTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => onTapCheck(id: id, isSelected: !isAction),
              child: Icon(
                Icons.check_box,
                color: isAction ? mainColor : Colors.grey.shade300,
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
                          icon: Icons.calendar_month,
                          iconColor: buttonBackgroundColor,
                          iconSize: 12,
                          text:
                              '${dateTimeFormatter(format: 'yy.MM.dd', dateTime: startDateTime)} ~ ${endDateTime != null ? dateTimeFormatter(format: 'yy.MM.dd', dateTime: endDateTime!) : ''}',
                          textColor: buttonBackgroundColor,
                          textSize: 11,
                        ),
                        SpaceWidth(width: tinySpace),
                        IconText(
                          icon: Icons.notifications_active,
                          iconColor: buttonBackgroundColor,
                          iconSize: 12,
                          text:
                              '${alarmTime != null ? timeToString(alarmTime) : '알림 OFF'}',
                          textColor: buttonBackgroundColor,
                          textSize: 11,
                        ),
                        SpaceWidth(width: tinySpace),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => onTapMore(id),
                  child: const Icon(Icons.more_horiz, color: Colors.grey),
                ),
                isAction
                    ? Row(
                        children: [
                          Icon(Icons.check, size: 12, color: mainColor),
                          SpaceWidth(width: 3),
                          Text(
                            timeToString(recordTime),
                            style: TextStyle(fontSize: 11, color: mainColor),
                          ),
                        ],
                      )
                    : const EmptyArea(),
              ],
            )
          ],
        ),
        SpaceHeight(height: regularSapce),
      ],
    );
  }
}

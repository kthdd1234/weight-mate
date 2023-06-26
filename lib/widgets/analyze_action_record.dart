import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_month_dialog.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';

class AnalyzeActionRecord extends StatefulWidget {
  AnalyzeActionRecord({
    super.key,
    required this.recordBox,
    required this.planBox,
  });

  Box<RecordBox> recordBox;
  Box<PlanBox> planBox;

  @override
  State<AnalyzeActionRecord> createState() => _AnalyzeActionRecordState();
}

class _AnalyzeActionRecordState extends State<AnalyzeActionRecord> {
  late DateTime seletedDateTime;

  @override
  void initState() {
    seletedDateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDateTime =
        DateTime(seletedDateTime.year, seletedDateTime.month, 1);
    DateTime lastDateTime =
        DateTime(seletedDateTime.year, seletedDateTime.month + 1, 0);
    String titleDateTime =
        '${dateTimeFormatter(dateTime: firstDateTime, format: 'yy.MM.dd')} ~ ${dateTimeFormatter(dateTime: lastDateTime, format: 'yy.MM.dd')}';

    setColorTextInfo({
      required String text,
      required Color color,
    }) {
      return ColorTextInfo(
        width: 10,
        height: 10,
        text: text,
        color: color,
      );
    }

    timeLineWidget({
      required DateTime dateTime,
      required String dateTimeFormat,
      required Color circleColor,
      required String title,
      required String name,
      required DateTime timeValue,
    }) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              dateTimeFormatter(format: dateTimeFormat, dateTime: dateTime),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.6,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
          Stack(
            alignment: const Alignment(0.0, -0.1),
            children: [
              const SizedBox(
                height: 110,
                child: VerticalDivider(width: 1, thickness: 1),
              ),
              CircleAvatar(
                backgroundColor: typeBackgroundColor,
                radius: 5,
                child: CircleAvatar(radius: 4, backgroundColor: circleColor),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BodySmallText(text: title),
                      SpaceHeight(height: tinySpace),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check,
                            size: 18,
                            color: buttonBackgroundColor,
                          ),
                          SpaceWidth(width: tinySpace),
                          Text(name, style: const TextStyle(fontSize: 13)),
                          SpaceHeight(height: tinySpace),
                        ],
                      ),
                      SpaceHeight(height: tinySpace),
                      IconText(
                        icon: Icons.check_circle,
                        iconColor: Colors.grey,
                        iconSize: 0,
                        text: timeToString(timeValue),
                        textColor: Colors.grey,
                        textSize: 11,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }

    onSubmit(DateTime dateTime) {
      setState(() => seletedDateTime = dateTime);
      closeDialog(context);
    }

    onTapCalendarMonth() {
      showDialog(
        context: context,
        builder: (context) => CalendarMonthDialog(
          initialDateTime: seletedDateTime,
          onSubmit: onSubmit,
          onCancel: () => closeDialog(context),
        ),
      );
    }

    onTapRecordSort() {}

    setListView() {
      // todo
    }

    return Expanded(
      child: Column(
        children: [
          SpaceHeight(height: regularSapce),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${dateTimeFormatter(format: 'MM월', dateTime: seletedDateTime)} 실천 기록'),
              BodySmallText(text: titleDateTime),
              // Text(titleDateTime, style: TextStyle(fontSize: 12)),
            ],
          ),
          SpaceHeight(height: smallSpace),
          WidthDivider(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade400,
          ),
          Expanded(
            flex: 8,
            child: ListView(
              children: [
                timeLineWidget(
                  dateTime: DateTime.now(),
                  dateTimeFormat: 'yyyy\nMM.dd 월',
                  circleColor: dietColor,
                  title: '식이요법',
                  name: '간헐적 단식 16:8',
                  timeValue: DateTime.now(),
                ),
              ],
            ),
          ),
          WidthDivider(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade400,
          ),
          SpaceHeight(height: regularSapce),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconText(
                icon: Icons.check,
                iconColor: buttonBackgroundColor,
                iconSize: 13,
                text: '실천 완료',
                textColor: Colors.grey.shade700,
                textSize: 12,
              ),
              setColorTextInfo(text: '식이요법', color: dietColor),
              setColorTextInfo(text: '운동', color: exerciseColor),
              setColorTextInfo(text: '생활습관', color: lifeStyleColor),
            ],
          ),
          SpaceHeight(height: regularSapce),
          Row(
            children: [
              ExpandedButton(
                imgUrl: 'assets/images/t-22.png',
                icon: Icons.calendar_month_outlined,
                text: dateTimeFormatter(
                  format: 'yyyy년 MM월',
                  dateTime: seletedDateTime,
                ),
                onTap: onTapCalendarMonth,
              ),
              SpaceWidth(width: smallSpace),
              ExpandedButton(
                imgUrl: 'assets/images/t-23.png',
                icon: Icons.swap_vert_outlined,
                text: '최신 기록순',
                onTap: onTapRecordSort,
              ),
            ],
          )
        ],
      ),
    );
  }
}

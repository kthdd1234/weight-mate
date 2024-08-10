import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import '../../utils/constants.dart';

class RowTitle extends StatelessWidget {
  RowTitle({
    super.key,
    required this.type,
    required this.selectedMonth,
    required this.onTap,
  });

  String type;
  DateTime selectedMonth;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    MaterialColor color = categoryColors[type]!;

    return Row(
      children: [
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: onTap,
            child: CommonText(
              isNotTr: true,
              text: m(locale: locale, dateTime: selectedMonth),
              size: 12,
              isCenter: true,
              rightIcon: Icons.keyboard_arrow_down_sharp,
            ),
          ),
        ),
        SpaceWidth(width: 10),
        locale != 'en'
            ? Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: category[type]!
                        .map((item) => Row(
                              children: [
                                SpaceWidth(width: 10),
                                CommonIcon(
                                  icon: item['icon'],
                                  size: 11,
                                  color: color.shade300,
                                  bgColor: color.shade50,
                                ),
                                SpaceWidth(width: 7),
                                CommonText(
                                  text: item['title'],
                                  size: 12,
                                ),
                              ],
                            ))
                        .toList()),
              )
            : const EmptyArea(),
      ],
    );
  }
}

class ColumnContainer extends StatelessWidget {
  ColumnContainer({
    super.key,
    required this.recordInfo,
    required this.dateTime,
    required this.type,
    required this.actions,
  });

  RecordBox? recordInfo;
  DateTime dateTime;
  String type;
  List<Map<String, dynamic>>? actions;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    List<Map<String, dynamic>>? actionList = onOrderList(
      actions: actions,
      type: type,
      dietRecordOrderList: recordInfo?.dietRecordOrderList,
      exerciseRecordOrderList: recordInfo?.exerciseRecordOrderList,
    );

    List<RecordLabel>? actionLabelList = actionList
        ?.map((item2) => RecordLabel(
              type: type,
              title: item2['title'],
              text: item2['name'],
              icon: categoryIcons[item2['title']]!,
              dietExerciseRecordDateTime: item2['dietExerciseRecordDateTime'],
            ))
        .toList();

    dateTimeTitle({required String text, required Color color}) {
      return CommonText(
        text: text,
        isNotTr: true,
        size: 13,
        isCenter: true,
        color: color,
      );
    }

    if (actionLabelList?.isEmpty == true) {
      return const EmptyArea();
    }

    return Column(
      children: [
        SpaceHeight(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Column(
                  children: [
                    dateTimeTitle(
                      text: d(locale: locale, dateTime: dateTime),
                      color: textColor,
                    ),
                    dateTimeTitle(
                      text: '(${eShort(locale: locale, dateTime: dateTime)})',
                      color: grey.original,
                    )
                  ],
                ),
              ),
            ),
            SpaceWidth(width: 30),
            Expanded(child: Column(children: actionLabelList ?? []))
          ],
        ),
        Divider(color: Colors.grey.shade200),
      ],
    );
  }
}

class RecordLabel extends StatelessWidget {
  RecordLabel({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    required this.type,
    this.dietExerciseRecordDateTime,
  });

  String text, type, title;
  DateTime? dietExerciseRecordDateTime;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    MaterialColor color = categoryColors[type]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 2),
            child: CommonIcon(
              icon: icon,
              size: 11,
              color: color.shade300,
              bgColor: color.shade50,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                dietExerciseRecordDateTime != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: CommonText(
                          text: hm(
                            locale: locale,
                            dateTime: dietExerciseRecordDateTime!,
                          ),
                          size: 11,
                          color: grey.original,
                          isNotTop: true,
                          isNotTr: true,
                        ),
                      )
                    : const EmptyArea()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import '../../utils/constants.dart';

class TodoChartPage extends StatefulWidget {
  const TodoChartPage({super.key});

  @override
  State<TodoChartPage> createState() => _TodoChartPageState();
}

class _TodoChartPageState extends State<TodoChartPage> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String type = args['type']!;
    String title = args['title']!;
    int selectedMonthKey = mToInt(selectedMonth);
    List<RecordBox?> recordList = recordRepository.recordBox.values.toList();

    isDisplayRecord(RecordBox? record) {
      bool isSelectedMonth =
          (mToInt(record?.createDateTime) == selectedMonthKey);
      bool? isRecordAction = record?.actions?.any(
        (item) => item['isRecord'] == true,
      );

      return isSelectedMonth && isRecordAction == true;
    }

    List<RecordBox?> displayRecordList = recordList
        .where((record) => isDisplayRecord(record))
        .toList()
        .reversed
        .toList();

    return AppFramework(
      widget: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        appBar: AppBar(
          title: Text(
            '$title 기록 모아보기'.tr(),
            style: const TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ContentsBox(
              contentsWidget: Column(
                children: [
                  RowTitle(type: type, selectedMonth: selectedMonth),
                  Divider(color: Colors.grey.shade200),
                  displayRecordList.isNotEmpty
                      ? Expanded(
                          child: ListView(
                            children: displayRecordList
                                .map((record) => ColumnContainer(
                                      dateTime: record!.createDateTime,
                                      type: type,
                                      actions: record.actions,
                                    ))
                                .toList(),
                          ),
                        )
                      : EmptyTextVerticalArea(
                          iconSize: 30,
                          titleSize: 15,
                          icon: Icons.local_dining_rounded,
                          title: '기록한 식단이 없어요.',
                          backgroundColor: Colors.transparent,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RowTitle extends StatelessWidget {
  RowTitle({
    super.key,
    required this.type,
    required this.selectedMonth,
  });

  String type;
  DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return Row(
      children: [
        Expanded(
          flex: 0,
          child: CommonText(
            text: m(locale: locale, dateTime: selectedMonth),
            size: 12,
            isCenter: true,
            rightIcon: Icons.keyboard_arrow_down_sharp,
          ),
        ),
        SpaceWidth(width: 10),
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: category[type]!
                  .map((item) => Row(
                        children: [
                          SpaceWidth(width: 10),
                          CommonText(
                            leftIcon: item['icon'],
                            text: item['title'],
                            size: 12,
                          ),
                        ],
                      ))
                  .toList()),
        ),
      ],
    );
  }
}

class ColumnContainer extends StatelessWidget {
  ColumnContainer({
    super.key,
    required this.dateTime,
    required this.type,
    required this.actions,
  });

  DateTime dateTime;
  String type;
  List<Map<String, dynamic>>? actions;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    dateTimeTitle({required String text, required Color color}) {
      return CommonText(
        text: text,
        isNotTr: true,
        size: 10,
        isCenter: true,
        color: color,
      );
    }

    final recordActionList = actions
            ?.where((item_1) =>
                item_1['isRecord'] == true && item_1['type'] == type)
            .map((item_2) => RecordLabel(
                text: item_2['name'], icon: categoryIcons[item_2['title']]!))
            .toList() ??
        [];

    return Column(
      children: [
        SpaceHeight(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Column(
                children: [
                  dateTimeTitle(
                      text: d(locale: locale, dateTime: dateTime),
                      color: themeColor),
                  dateTimeTitle(
                      text: '(${e_short(locale: locale, dateTime: dateTime)})',
                      color: Colors.grey)
                ],
              ),
            ),
            SpaceWidth(width: 30),
            Expanded(child: Column(children: recordActionList))
          ],
        ),
        Divider(color: Colors.grey.shade200),
      ],
    );
  }
}

class RecordLabel extends StatelessWidget {
  RecordLabel({super.key, required this.text, required this.icon});

  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2, right: 5),
            child: CommonIcon(icon: icon, size: 11),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

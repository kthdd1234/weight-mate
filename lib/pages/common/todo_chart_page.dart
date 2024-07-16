import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/common/CommonBlur.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
        (item) => item['isRecord'] == true && item['type'] == type,
      );

      return isSelectedMonth && isRecordAction == true;
    }

    onTapMonthTitle() {
      showDialog(
        context: context,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              backgroundColor: whiteBgBtnColor,
              shape: containerBorderRadious,
              title: DialogTitle(
                text: '월 선택',
                onTap: () => closeDialog(context),
              ),
              content: DatePicker(
                view: DateRangePickerView.year,
                initialSelectedDate: selectedMonth,
                onSelectionChanged: (datTimeArgs) {
                  setState(() => selectedMonth = datTimeArgs.value);
                  closeDialog(context);
                },
              ),
            ),
          ],
        ),
      );
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
            style: const TextStyle(fontSize: 20, color: textColor),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: textColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Stack(
              children: [
                ContentsBox(
                  contentsWidget: Column(
                    children: [
                      RowTitle(
                        type: type,
                        selectedMonth: selectedMonth,
                        onTap: onTapMonthTitle,
                      ),
                      Divider(color: Colors.grey.shade200),
                      displayRecordList.isNotEmpty
                          ? Expanded(
                              child: ListView(
                                children: displayRecordList
                                    .map((record) => ColumnContainer(
                                          recordInfo: record,
                                          dateTime: record!.createDateTime,
                                          type: type,
                                          actions: record.actions,
                                        ))
                                    .toList(),
                              ),
                            )
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CommonIcon(
                                    icon: todoData[type]!.icon,
                                    size: 20,
                                    color: grey.original,
                                  ),
                                  SpaceHeight(height: 10),
                                  CommonText(
                                    text: '기록이 없어요.',
                                    size: 15,
                                    isCenter: true,
                                    color: grey.original,
                                  ),
                                  SpaceHeight(height: 20),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                CommonBlur(),
              ],
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

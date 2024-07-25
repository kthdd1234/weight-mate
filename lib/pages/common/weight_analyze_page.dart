// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonBlur.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_chart_page.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WeightAnalyzePage extends StatelessWidget {
  const WeightAnalyzePage({super.key});

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    UserBox user = userRepository.user;
    double? goalWeight = user.goalWeight;
    String unit = user.weightUnit ?? 'kg';

    List<Widget> analyzeWidgetList = [
      MonthAnalysis(locale: locale, unit: unit),
      YearAnalysis(locale: locale, unit: unit),
      CompareToFirst(locale: locale, unit: unit),
      CompareToGoal(locale: locale, unit: unit, goalWeight: goalWeight),
    ];

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '체중 분석표'),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: ((context, index) => analyzeWidgetList[index]),
              itemCount: analyzeWidgetList.length,
            ),
            CommonBlur(),
          ],
        ),
      ),
    );
  }
}

class CompareToFirst extends StatelessWidget {
  CompareToFirst({super.key, required this.unit, required this.locale});

  String locale, unit;

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();
    DateTime now = DateTime.now();

    RecordBox first = recordList.firstWhere((record) => record.weight != null,
        orElse: () => RecordBox(createDateTime: now));
    RecordBox last = recordList.lastWhere((record) => record.weight != null,
        orElse: () => RecordBox(createDateTime: now));

    double firstWeight = first.weight ?? 0;
    double lastWeight = last.weight ?? 0;
    DateTime firstDateTime = first.createDateTime;
    DateTime lastDateTime = last.createDateTime;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            ContentsTitle(title: '처음과 비교', svg: "start-icon"),
            CompareItemCell(
              title: '처음 기록한 체중',
              subTitle: ymdeShort(locale: locale, dateTime: firstDateTime),
              text: '$firstWeight$unit',
            ),
            CompareItemCell(
              title: '마지막으로 기록한 체중',
              subTitle: ymdeShort(locale: locale, dateTime: lastDateTime),
              text: '$lastWeight$unit',
            ),
            CompareItemCell(
              title: '처음과 비교 했을 때 변화',
              text:
                  '${calculatedWeight(fWeight: lastWeight, lWeight: firstWeight)}$unit',
              isNotDivider: true,
            ),
          ],
        ),
      ),
    );
  }
}

class CompareToGoal extends StatelessWidget {
  CompareToGoal({
    super.key,
    required this.unit,
    required this.goalWeight,
    required this.locale,
  });

  double? goalWeight;
  String locale, unit;

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();
    DateTime now = DateTime.now();

    RecordBox last = recordList.lastWhere((record) => record.weight != null,
        orElse: () => RecordBox(createDateTime: now));
    double lastWeight = last.weight ?? 0;
    DateTime? lastDateTime = last.createDateTime;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            ContentsTitle(title: '목표와 비교', svg: "flag-icon"),
            CompareItemCell(
              title: '목표 체중',
              text: '$goalWeight$unit',
            ),
            CompareItemCell(
              title: '마지막으로 기록한 체중',
              subTitle: ymdeShort(locale: locale, dateTime: lastDateTime),
              text: '$lastWeight$unit',
            ),
            CompareItemCell(
              title: '목표까지',
              text:
                  '${calculatedWeight(fWeight: goalWeight!, lWeight: lastWeight)}$unit',
              isNotDivider: true,
            )
          ],
        ),
      ),
    );
  }
}

class MonthAnalysis extends StatefulWidget {
  MonthAnalysis({super.key, required this.locale, required this.unit});

  String locale, unit;

  @override
  State<MonthAnalysis> createState() => _MonthAnalysisState();
}

class _MonthAnalysisState extends State<MonthAnalysis> {
  DateTime seletedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();

    String month = m(locale: widget.locale, dateTime: seletedDateTime);
    List<RecordBox> seletedRecordList = recordList.where((record) {
      bool isYear = record.createDateTime.year == seletedDateTime.year;
      bool isMonth = record.createDateTime.month == seletedDateTime.month;
      bool isWeight = record.weight != null;

      return isYear && isMonth && isWeight;
    }).toList();

    onShowCalendar() {
      onShowDateTimeDialog(
        context: context,
        view: DateRangePickerView.year,
        initialSelectedDate: seletedDateTime,
        onSelectionChanged: (args) {
          setState(() => seletedDateTime = args.value);
          closeDialog(context);
        },
      );
    }

    onTapSixMonthGraphButton() {
      List<StackGraphData> max = [];
      List<StackGraphData> avg = [];
      List<StackGraphData> min = [];

      for (var i = 0; i < 6; i++) {
        DateTime monthDt = Jiffy.now().subtract(months: i).dateTime;
        String ymDtStr = ym(locale: widget.locale, dateTime: monthDt);
        List<RecordBox> ymRecordList = recordList
            .where((record) =>
                ymDtStr ==
                    ym(
                        locale: widget.locale,
                        dateTime: record.createDateTime) &&
                record.weight != null)
            .toList();

        if (ymRecordList.isNotEmpty) {
          double? maxWeight = maxRecordFunc(list: ymRecordList).weight;
          double? avgWeight =
              double.tryParse(avgRecordFunc(list: ymRecordList));
          double? minWeight = minRecordFunc(list: ymRecordList).weight;

          String x = yyyyUnderM(locale: widget.locale, dateTime: monthDt);
          StackGraphData maxData = StackGraphData(x, maxWeight);
          StackGraphData avgData = StackGraphData(x, avgWeight);
          StackGraphData minData = StackGraphData(x, minWeight);

          max.add(maxData);
          avg.add(avgData);
          min.add(minData);
        }
      }

      Navigator.pushNamed(
        context,
        '/max-min-avg-graph-page',
        arguments: DataSourceClass(
          title: '월간 비교 그래프',
          max: max.reversed.toList(),
          avg: avg.reversed.toList(),
          min: min.reversed.toList(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            ContentsTitle(
              title: ' 분석',
              svg: "calendar-icon",
              subTitle: month,
              nameArgs: {"date": month},
              onShowCalendar: onShowCalendar,
            ),
            seletedRecordList.isNotEmpty
                ? Column(
                    children: [
                      CompareItemCell(
                        title: '평균 체중',
                        text:
                            '${avgRecordFunc(list: seletedRecordList)}${widget.unit}',
                      ),
                      CompareItemCell(
                        title: '최고 체중',
                        text:
                            '${maxRecordFunc(list: seletedRecordList).weight}${widget.unit}',
                        subTitle: ymdeShort(
                          locale: widget.locale,
                          dateTime: maxRecordFunc(list: seletedRecordList)
                              .createDateTime,
                        ),
                      ),
                      CompareItemCell(
                        title: '최저 체중',
                        text:
                            '${minRecordFunc(list: seletedRecordList).weight}${widget.unit}',
                        subTitle: ymdeShort(
                          locale: widget.locale,
                          dateTime: minRecordFunc(list: seletedRecordList)
                              .createDateTime,
                        ),
                        isNotDivider: true,
                      ),
                      GraphCompareButton(
                        text: '월간 비교 그래프',
                        imgNumber: 11,
                        onTap: onTapSixMonthGraphButton,
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: EmptyWidget(
                        icon: Icons.monitor_weight, text: "기록이 없어요."),
                  )
          ],
        ),
      ),
    );
  }
}

class GraphCompareButton extends StatelessWidget {
  GraphCompareButton({
    super.key,
    required this.text,
    required this.imgNumber,
    required this.onTap,
  });

  String text;
  int imgNumber;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          ExpandedButtonHori(
            padding: const EdgeInsets.symmetric(vertical: 12.5),
            text: text,
            imgUrl: 'assets/images/t-$imgNumber.png',
            borderRadius: 5,
            onTap: onTap,
          )
        ],
      ),
    );
  }
}

class YearAnalysis extends StatefulWidget {
  YearAnalysis({super.key, required this.locale, required this.unit});

  String locale, unit;

  @override
  State<YearAnalysis> createState() => _YearAnalysisState();
}

class _YearAnalysisState extends State<YearAnalysis> {
  DateTime seletedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();

    String year = y(locale: widget.locale, dateTime: seletedDateTime);
    List<RecordBox> seletedRecordList = recordList.where((record) {
      bool isYear = record.createDateTime.year == seletedDateTime.year;
      bool isWeight = record.weight != null;

      return isYear && isWeight;
    }).toList();

    onShowCalendar() {
      onShowDateTimeDialog(
        context: context,
        view: DateRangePickerView.decade,
        initialSelectedDate: seletedDateTime,
        onSelectionChanged: (args) {
          setState(() => seletedDateTime = args.value);
          closeDialog(context);
        },
      );
    }

    onTapOneYearGraphButton() {
      List<StackGraphData> max = [];
      List<StackGraphData> avg = [];
      List<StackGraphData> min = [];

      for (var i = 0; i < 6; i++) {
        DateTime monthDt = Jiffy.now().subtract(years: i).dateTime;
        String yDtStr = y(locale: widget.locale, dateTime: monthDt);
        List<RecordBox> yRecordList = recordList
            .where((record) =>
                yDtStr ==
                    y(locale: widget.locale, dateTime: record.createDateTime) &&
                record.weight != null)
            .toList();

        if (yRecordList.isNotEmpty) {
          double? maxWeight = maxRecordFunc(list: yRecordList).weight;
          double? avgWeight = double.tryParse(avgRecordFunc(list: yRecordList));
          double? minWeight = minRecordFunc(list: yRecordList).weight;

          String x = y(locale: widget.locale, dateTime: monthDt);
          StackGraphData maxData = StackGraphData(x, maxWeight);
          StackGraphData avgData = StackGraphData(x, avgWeight);
          StackGraphData minData = StackGraphData(x, minWeight);

          max.add(maxData);
          avg.add(avgData);
          min.add(minData);
        }
      }

      Navigator.pushNamed(
        context,
        '/max-min-avg-graph-page',
        arguments: DataSourceClass(
          title: '연간 비교 그래프',
          max: max.reversed.toList(),
          avg: avg.reversed.toList(),
          min: min.reversed.toList(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            ContentsTitle(
              title: ' 분석',
              svg: "chart-icon",
              subTitle: year,
              nameArgs: {"date": year},
              onShowCalendar: onShowCalendar,
            ),
            seletedRecordList.isNotEmpty
                ? Column(
                    children: [
                      CompareItemCell(
                        title: '평균 체중',
                        text:
                            '${avgRecordFunc(list: seletedRecordList)}${widget.unit}',
                      ),
                      CompareItemCell(
                        title: '최고 체중',
                        text:
                            '${maxRecordFunc(list: seletedRecordList).weight}${widget.unit}',
                        subTitle: ymdeShort(
                          locale: widget.locale,
                          dateTime: maxRecordFunc(list: seletedRecordList)
                              .createDateTime,
                        ),
                      ),
                      CompareItemCell(
                        title: '최저 체중',
                        text:
                            '${minRecordFunc(list: seletedRecordList).weight}${widget.unit}',
                        subTitle: ymdeShort(
                          locale: widget.locale,
                          dateTime: minRecordFunc(list: seletedRecordList)
                              .createDateTime,
                        ),
                        isNotDivider: true,
                      ),
                      GraphCompareButton(
                        text: '연간 비교 그래프',
                        imgNumber: 24,
                        onTap: onTapOneYearGraphButton,
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: EmptyWidget(
                      icon: Icons.monitor_weight,
                      text: "기록이 없어요.",
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class ContentsTitle extends StatelessWidget {
  ContentsTitle({
    super.key,
    required this.title,
    required this.svg,
    this.subTitle,
    this.nameArgs,
    this.onShowCalendar,
  });

  String title, svg;
  String? subTitle;
  Map<String, String>? nameArgs;
  Function()? onShowCalendar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CommonSvg(width: 15, name: svg),
              SpaceWidth(width: 7),
              CommonText(text: title, size: 14, nameArgs: nameArgs),
            ],
          ),
          subTitle != null
              ? InkWell(
                  onTap: onShowCalendar,
                  child: Row(
                    children: [
                      CommonIcon(
                        icon: Icons.keyboard_arrow_down_rounded,
                        size: 15,
                        color: grey.original,
                      ),
                      CommonText(
                        color: grey.original,
                        text: subTitle!,
                        size: 13,
                        isNotTr: true,
                      ),
                    ],
                  ),
                )
              : const EmptyArea()
        ],
      ),
    );
  }
}

class CompareItemCell extends StatelessWidget {
  CompareItemCell({
    super.key,
    required this.title,
    required this.text,
    this.subTitle,
    this.isNotDivider,
  });

  String title, text;
  String? subTitle;
  bool? isNotDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(text: title, size: 12),
                CommonText(
                  text: subTitle ?? '',
                  size: 11,
                  color: grey.original,
                  isNotTr: true,
                ),
              ],
            ),
            SpaceHeight(height: 5),
            CommonText(text: text, size: 15, isNotTr: true),
          ],
        ),
        isNotDivider == true
            ? const EmptyArea()
            : Divider(color: Colors.grey.shade200, thickness: 0.5, height: 20),
      ],
    );
  }
}

/** 처음과 비교
 * 처음 기록한 체중                         2023.7.15 (수)
 * 61.8kg
 * ---------------------------------------------------
 * 가장 최근에 기록한 체중                    2024.3.16 (토)
 * 59.1kg
 * ---------------------------------------------------
 * (가장 최근에 기록한 체중) - (처음 기록한 체중)
 * -2.7kg
 * */

/** 목표와 비교                              
 * 목표 체중                               2023.7.15 (수)
 * 55.2kg                                
 * ---------------------------------------------------
 * 가장 최근에 기록한 체중                    2024.3.16 (토)
 * 59.1kg
 * ---------------------------------------------------
 * (목표 체중) - (가장 최근에 기록한 체중)
 * -4.1kg
 * */

/** 3월 분석                                       3월 ▿
 * 평균 체중                                    
 * 58.2kg
 * ---------------------------------------------------
 * 최고 체중
 * 57.2kg
 * ---------------------------------------------------
 * 최저 체중
 * 62.1kg
 * */

/** 2024년 분석                                 2024년 ▿
 * 평균 체중                                    
 * 58.2kg
 * ---------------------------------------------------
 * 최고 체중
 * 57.2kg
 * ---------------------------------------------------
 * 최저 체중
 * 62.1kg
 * */

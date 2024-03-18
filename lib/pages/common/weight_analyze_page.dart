import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class WeightAnalyzePage extends StatelessWidget {
  const WeightAnalyzePage({super.key});

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    UserBox user = userRepository.user;
    double? goalWeight = user.goalWeight;
    String unit = user.weightUnit ?? 'kg';
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();

    List<Widget> analyzeWidgetList = [
      CompareToFirst(locale: locale, unit: unit, recordList: recordList),
      CompareToGoal(
        locale: locale,
        unit: unit,
        recordList: recordList,
        goalWeight: goalWeight,
      ),
      MonthAnalysis(),
      YearAnalysis()
    ];

    if (recordList.isEmpty) {
      // todo
      // return EmptyTextArea(text: text, icon: icon, topHeight: topHeight, downHeight: downHeight, onTap: onTap);
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '체중 분석표'.tr(),
            style: const TextStyle(fontSize: 20, color: themeColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemBuilder: ((context, index) => analyzeWidgetList[index]),
              itemCount: analyzeWidgetList.length,
            ),
          ),
        ),
      ),
    );
  }
}

class CompareToFirst extends StatelessWidget {
  CompareToFirst({
    super.key,
    required this.unit,
    required this.recordList,
    required this.locale,
  });

  String locale, unit;
  List<RecordBox> recordList;

  @override
  Widget build(BuildContext context) {
    RecordBox first = recordList.firstWhere((record) => record.weight != null);
    RecordBox last = recordList.lastWhere((record) => record.weight != null);

    double? firstWeight = first.weight;
    double? lastWeight = last.weight;
    DateTime? firstDateTime = first.weightDateTime;
    DateTime? lastDateTime = last.weightDateTime;

    weightResult() {
      if (firstWeight == null || lastWeight == null) {
        return '-$unit';
      }

      return '${calculatedWeight(fWeight: firstWeight, lWeight: lastWeight)}$unit';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            CompareItemTitle(title: '처음과 비교', svg: "start-icon"),
            CompareItemCell(
              title: '처음 기록한 체중',
              subTitle: firstDateTime != null
                  ? ymdeShort(locale: locale, dateTime: firstDateTime)
                  : '-',
              text: '${firstWeight ?? '-'}$unit',
            ),
            CompareItemCell(
              title: '마지막으로 기록한 체중',
              subTitle: lastDateTime != null
                  ? ymdeShort(locale: locale, dateTime: lastDateTime)
                  : '-',
              text: '${lastWeight ?? '-'}$unit',
            ),
            CompareItemCell(
              title: '처음과 비교 했을 때 변화',
              text: weightResult(),
              isNotDivider: true,
            )
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
    required this.recordList,
    required this.locale,
  });

  double? goalWeight;
  String locale, unit;
  List<RecordBox> recordList;

  @override
  Widget build(BuildContext context) {
    RecordBox first = recordList.firstWhere((record) => record.weight != null);
    RecordBox last = recordList.lastWhere((record) => record.weight != null);

    double? lastWeight = last.weight;
    DateTime? firstDateTime = first.weightDateTime;
    DateTime? lastDateTime = last.weightDateTime;

    weightResult() {
      if (goalWeight == null || lastWeight == null) {
        return '-$unit';
      }

      return '${calculatedWeight(fWeight: lastWeight, lWeight: goalWeight!)}$unit';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            CompareItemTitle(title: '목표와 비교', svg: "flag-icon"),
            CompareItemCell(
              title: '목표 체중',
              text: '${goalWeight ?? '-'}$unit',
            ),
            CompareItemCell(
              title: '마지막으로 기록한 체중',
              subTitle: lastDateTime != null
                  ? ymdeShort(locale: locale, dateTime: lastDateTime)
                  : '-',
              text: '58.3kg',
            ),
            CompareItemCell(
              title: '목표까지',
              text: weightResult(),
              isNotDivider: true,
            )
          ],
        ),
      ),
    );
  }
}

class MonthAnalysis extends StatelessWidget {
  const MonthAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            CompareItemTitle(
              title: '3월 분석',
              svg: "calendar-icon",
              subTitle: "3월",
            ),
            CompareItemCell(
              title: '평균 체중',
              text: '54.3kg',
            ),
            CompareItemCell(
              title: '최고 체중',
              text: '58.3kg',
            ),
            CompareItemCell(
              title: '최저 체중',
              text: '-2.1kg',
              isNotDivider: true,
            )
          ],
        ),
      ),
    );
  }
}

class YearAnalysis extends StatelessWidget {
  const YearAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      contentsWidget: Column(
        children: [
          CompareItemTitle(
            title: '2024년 분석',
            svg: "chart-icon",
            subTitle: "2024년",
          ),
          CompareItemCell(
            title: '평균 체중',
            text: '54.3kg',
          ),
          CompareItemCell(
            title: '최고 체중',
            text: '58.3kg',
          ),
          CompareItemCell(
            title: '최저 체중',
            text: '-2.1kg',
            isNotDivider: true,
          )
        ],
      ),
    );
  }
}

class CompareItemTitle extends StatelessWidget {
  CompareItemTitle({
    super.key,
    required this.title,
    required this.svg,
    this.subTitle,
  });

  String title, svg;
  String? subTitle;

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
              SpaceWidth(width: 5),
              CommonText(text: title, size: 14, isBold: true),
            ],
          ),
          subTitle != null
              ? Row(
                  children: [
                    CommonIcon(
                      icon: Icons.keyboard_arrow_down_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    CommonText(
                      color: Colors.grey,
                      text: subTitle!,
                      size: 12,
                      isNotTr: true,
                    ),
                  ],
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
                CommonText(text: subTitle ?? '', size: 10, color: Colors.grey),
              ],
            ),
            SpaceHeight(height: 5),
            CommonText(text: text, size: 15),
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

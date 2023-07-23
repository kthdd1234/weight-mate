import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TodayWeightInfosWidget extends StatelessWidget {
  TodayWeightInfosWidget({
    super.key,
    this.weight,
    this.goalWeight,
    this.tall,
    this.beforeWeight,
    this.recordCount,
  });

  double? weight, beforeWeight, goalWeight, tall;
  int? recordCount;

  @override
  Widget build(BuildContext context) {
    setCalculatedGoalWeight() {
      if (weight == null || goalWeight == null) {
        return '- kg';
      }

      return calculatedGoalWeight(goalWeight: goalWeight!, weight: weight!);
    }

    setCalculatedBMI() {
      if (weight == null || tall == null) {
        return '0.00';
      }

      final cmToM = tall! / 100;
      final bmi = weight! / (cmToM * cmToM);
      final bmiToFixed = bmi.toStringAsFixed(1);

      return bmiToFixed;
    }

    setCalculatedBeforeRecord() {
      if (beforeWeight == null || weight == null || beforeWeight == 0.0) {
        return '0.0 kg';
      }

      final value = weight! - beforeWeight!;
      final fixedValue = value.toStringAsFixed(1);
      final operator = weight == beforeWeight!
          ? ''
          : weight! > beforeWeight!
              ? '+'
              : '';

      return '$operator$fixedValue kg';
    }

    setCalculatedWeight() {
      return '$weight kg';
    }

    List<WeightInfoClass> weightInfoClassList = [
      WeightInfoClass(
        id: 'weight',
        title: '현재 체중',
        value: setCalculatedWeight(),
        icon: Icons.monitor_weight,
        more: Icons.check_circle_outline_outlined,
        tooltipMsg: '체중 기록 완료!',
        iconColor: Colors.blue.shade400,
      ),
      WeightInfoClass(
          id: 'bmi',
          title: 'BMI 지수',
          value: setCalculatedBMI(),
          icon: Icons.person_search,
          more: Icons.help_outline_outlined,
          tooltipMsg: '현재 체중(kg)을 키의 제곱(m)으로 나눈 값입니다.',
          iconColor: Colors.cyan.shade400),
      WeightInfoClass(
          id: 'change',
          title: '체중 변화',
          value: setCalculatedBeforeRecord(),
          icon: Icons.insights,
          more: Icons.error_outline,
          tooltipMsg: '(현재 체중) - (이전의 체중) 결과 값입니다.',
          iconColor: Colors.red.shade400),
      WeightInfoClass(
          id: 'goal',
          title: '목표 체중까지',
          value: setCalculatedGoalWeight(),
          icon: Icons.flag,
          more: Icons.error_outline,
          tooltipMsg: '(목표 체중) - (현재 체중) 결과 값입니다.',
          iconColor: Colors.purple.shade400),
    ];

    contentsWidget({
      required String id,
      required String title,
      required String value,
      required IconData icon,
      required IconData more,
      required String tooltipMsg,
      Function(String id)? onTap,
      required Color iconColor,
      required String bottomText,
    }) {
      onTapLink() async {
        Uri url = Uri(
          scheme: 'https',
          host: 'ko.wikipedia.org',
          path: 'wiki/%EC%B2%B4%EC%A7%88%EB%9F%89_%EC%A7%80%EC%88%98',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      }

      return Expanded(
        child: ContentsBox(
          backgroundColor: Colors.white,
          contentsWidget: InkWell(
            onTap: () => onTap != null ? onTap(id) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        color: buttonBackgroundColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Tooltip(
                        showDuration: const Duration(seconds: 4),
                        triggerMode: TooltipTriggerMode.tap,
                        preferBelow: false,
                        message: tooltipMsg,
                        child: Icon(
                          more,
                          size: 15,
                          color: buttonBackgroundColor,
                        ))
                  ],
                ),
                SpaceHeight(height: smallSpace),
                Text(
                  value,
                  style: const TextStyle(
                    color: buttonBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SpaceHeight(height: regularSapce),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: id == 'bmi' ? onTapLink : null,
                      child: Text(
                        bottomText,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: iconColor,
                          decoration:
                              id == 'bmi' ? TextDecoration.underline : null,
                        ),
                      ),
                    ),
                    CircularIcon(
                      size: 40,
                      borderRadius: 50,
                      icon: icon,
                      iconColor: iconColor,
                      backgroundColor: typeBackgroundColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    onTap(String id) {
      final setIconType =
          context.read<RecordIconTypeProvider>().setSeletedRecordIconType;
      id == 'weight'
          ? setIconType(RecordIconTypes.editWeight)
          : setIconType(RecordIconTypes.editGoalWeight);
    }

    return Column(
      children: [
        Row(
          children: [
            contentsWidget(
              id: weightInfoClassList[0].id,
              title: weightInfoClassList[0].title,
              value: weightInfoClassList[0].value,
              icon: weightInfoClassList[0].icon,
              more: weightInfoClassList[0].more,
              tooltipMsg: weightInfoClassList[0].tooltipMsg,
              iconColor: weightInfoClassList[0].iconColor,
              bottomText: '기록 횟수: ${recordCount ?? 0}',
              onTap: onTap,
            ),
            SpaceWidth(width: tinySpace),
            contentsWidget(
              id: weightInfoClassList[1].id,
              title: weightInfoClassList[1].title,
              value: weightInfoClassList[1].value,
              icon: weightInfoClassList[1].icon,
              more: weightInfoClassList[1].more,
              tooltipMsg: weightInfoClassList[1].tooltipMsg,
              iconColor: weightInfoClassList[1].iconColor,
              bottomText: '출처: 위키백과',
            ),
          ],
        ),
        SpaceHeight(height: tinySpace),
        Row(
          children: [
            contentsWidget(
              id: weightInfoClassList[2].id,
              title: weightInfoClassList[2].title,
              value: weightInfoClassList[2].value,
              icon: weightInfoClassList[2].icon,
              more: weightInfoClassList[2].more,
              iconColor: weightInfoClassList[2].iconColor,
              tooltipMsg: weightInfoClassList[2].tooltipMsg,
              bottomText: '이전 체중: ${beforeWeight ?? '-'}',
            ),
            SpaceWidth(width: tinySpace),
            contentsWidget(
              id: weightInfoClassList[3].id,
              title: weightInfoClassList[3].title,
              value: weightInfoClassList[3].value,
              icon: weightInfoClassList[3].icon,
              more: weightInfoClassList[3].more,
              iconColor: weightInfoClassList[3].iconColor,
              tooltipMsg: weightInfoClassList[3].tooltipMsg,
              bottomText: '목표 체중: $goalWeight',
              onTap: onTap,
            ),
          ],
        )
      ],
    );
  }
}

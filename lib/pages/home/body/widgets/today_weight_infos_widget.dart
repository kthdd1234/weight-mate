import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/height_divider.dart';
import 'package:flutter_app_weight_management/components/info/weight_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:provider/provider.dart';

class TodayWeightInfosWidget extends StatelessWidget {
  TodayWeightInfosWidget({
    super.key,
    required this.weightText,
    required this.goalWeightText,
    required this.bodyFatText,
    required this.tallText,
    this.dividerColor,
  });

  String weightText, goalWeightText, bodyFatText, tallText;
  Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    setCalculatedGoalWeight() {
      final weight = double.parse(weightText);
      final goalWeight = double.parse(goalWeightText);
      final toTheGoal = goalWeight - weight;
      final operator = goalWeight == weight
          ? ''
          : goalWeight > weight
              ? '+ '
              : '';

      return '$operator$toTheGoal kg';
    }

    setCalculatedBMI() {
      final tall = double.parse(tallText);
      final cmToM = tall / 100;
      final weight = double.parse(weightText);
      final bmi = weight / (cmToM * cmToM);
      final bmiToFixed = bmi.toStringAsFixed(1);

      return bmiToFixed;
    }

    setBodyFatText() {
      return bodyFatText != '' ? '$bodyFatText %' : '-';
    }

    return Column(
      children: [
        SpaceHeight(height: regularSapce),
        ContentsBox(
          backgroundColor: dialogBackgroundColor,
          contentsWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeightInfo(name: '현재 체중', value: '$weightText kg'),
              HeightDivider(height: 40, color: Colors.grey[300]),
              WeightInfo(name: '목표까지', value: setCalculatedGoalWeight()),
              HeightDivider(height: 40, color: Colors.grey[300]),
              WeightInfo(name: 'BMI', value: setCalculatedBMI()),
              HeightDivider(height: 40, color: Colors.grey[300]),
              WeightInfo(name: '체지방률', value: setBodyFatText()),
            ],
          ),
        ),
      ],
    );
  }
}

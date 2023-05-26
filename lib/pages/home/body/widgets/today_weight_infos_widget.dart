import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/height_divider.dart';
import 'package:flutter_app_weight_management/components/info/weight_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TodayWeightInfosWidget extends StatelessWidget {
  TodayWeightInfosWidget({
    super.key,
    required this.weight,
    required this.goalWeight,
    required this.tall,
    this.beforeWeight,
  });

  double? weight, beforeWeight;
  double goalWeight, tall;

  @override
  Widget build(BuildContext context) {
    setCalculatedGoalWeight() {
      if (weight == null) {
        return '- kg';
      }

      final toTheGoal = goalWeight - weight!;
      final operator = goalWeight == weight!
          ? ''
          : goalWeight > weight!
              ? '+ '
              : '';

      return '$operator$toTheGoal kg';
    }

    setCalculatedBMI() {
      if (weight == null) {
        return '0.00';
      }

      final cmToM = tall / 100;
      final bmi = weight! / (cmToM * cmToM);
      final bmiToFixed = bmi.toStringAsFixed(1);

      return bmiToFixed;
    }

    setCalculatedBeforeRecord() {
      if (beforeWeight == null || weight == null || beforeWeight == 0.0) {
        return '0.0 kg';
      }

      final resultWeight = beforeWeight! - weight!;
      final operator = beforeWeight == weight!
          ? ''
          : beforeWeight! > weight!
              ? '+ '
              : '';

      return '$operator$resultWeight kg';
    }

    return Column(
      children: [
        SpaceHeight(height: regularSapce),
        ContentsBox(
          backgroundColor: dialogBackgroundColor,
          contentsWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeightInfo(name: '현재 체중', value: '$weight kg'),
              HeightDivider(height: 40, color: Colors.grey[300]),
              WeightInfo(name: 'BMI ', value: setCalculatedBMI()),
              HeightDivider(height: 40, color: Colors.grey[300]),
              WeightInfo(name: '체중 변화', value: setCalculatedBeforeRecord()),
              HeightDivider(height: 40, color: Colors.grey[300]),
              WeightInfo(name: '목표까지', value: setCalculatedGoalWeight()),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/colors.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SimpleSteop extends StatelessWidget {
  SimpleSteop({
    super.key,
    required this.step,
    required this.currentStep,
  });

  int step;
  int currentStep;

  @override
  Widget build(BuildContext context) {
    var icons = [
      null,
      currentStep == 1 ? Icons.looks_one_rounded : Icons.looks_one_outlined,
      currentStep == 2 ? Icons.looks_two_rounded : Icons.looks_two_outlined,
      currentStep == 3 ? Icons.looks_3_rounded : Icons.looks_3_outlined,
      currentStep == 4 ? Icons.looks_4_rounded : Icons.looks_4_outlined,
    ];
    return Icon(
      icons[step],
      color: buttonBackgroundColor,
    );
  }
}

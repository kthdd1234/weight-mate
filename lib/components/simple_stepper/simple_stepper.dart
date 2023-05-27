import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_step.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SimpleStepper extends StatelessWidget {
  SimpleStepper({super.key, required this.currentStep});

  int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SimpleSteop(step: 1, currentStep: currentStep),
        const Icon(
          Icons.remove,
          size: 10,
          color: buttonBackgroundColor,
        ),
        SimpleSteop(step: 2, currentStep: currentStep),
        const Icon(
          Icons.remove,
          size: 10,
          color: buttonBackgroundColor,
        ),
        SimpleSteop(step: 3, currentStep: currentStep),
        const Icon(
          Icons.remove,
          size: 10,
          color: buttonBackgroundColor,
        ),
        SimpleSteop(step: 4, currentStep: currentStep),
      ],
    );
  }
}

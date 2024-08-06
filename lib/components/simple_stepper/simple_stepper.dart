import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_step.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SimpleStepper extends StatelessWidget {
  SimpleStepper({super.key, required this.step});

  int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SimpleStep(index: 1, step: step),
        const Icon(
          Icons.remove,
          size: 10,
          color: textColor,
        ),
        SimpleStep(index: 2, step: step),
        const Icon(
          Icons.remove,
          size: 10,
          color: textColor,
        ),
        SimpleStep(index: 3, step: step),
      ],
    );
  }
}

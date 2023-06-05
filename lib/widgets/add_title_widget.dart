import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class AddTitleWidget extends StatelessWidget {
  AddTitleWidget({
    super.key,
    required this.argmentsType,
    required this.step,
    required this.title,
  });

  argmentsTypeEnum argmentsType;
  int step;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SimpleStepper(
          step: setStep(argmentsType: argmentsType, step: step),
          range: setRange(argmentsType: argmentsType),
        ),
        SpaceHeight(height: regularSapce),
        HeadlineText(text: title),
        SpaceHeight(height: regularSapce),
      ],
    );
  }
}

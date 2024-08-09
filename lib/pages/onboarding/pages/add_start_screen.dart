import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/pages/onboarding/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/onboarding/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AddStartScreen extends StatelessWidget {
  const AddStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    onPressedStart() {
      Navigator.pushNamed(context, '/add-body-tall');
    }

    return AddContainer(
      isCenter: true,
      body: Column(
        children: [
          Image.asset('assets/images/MATE.png', width: 150),
          SpaceHeight(height: regularSapce),
          CommonText(text: '체중 메이트', size: 15, isBold: true, isCenter: true),
          SpaceHeight(height: regularSapce),
          CommonText(text: '반가워요! 체중 메이트와 함께', size: 13, isCenter: true),
          CommonText(text: '건강한 다이어트를 시작해봐요:)', size: 13, isCenter: true),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '시작하기',
      onPressedBottomNavigationButton: onPressedStart,
    );
  }
}

class PageTitle extends StatelessWidget {
  PageTitle({super.key, required this.step, required this.title});

  int step;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SimpleStepper(step: step),
        SpaceHeight(height: regularSapce),
        Text(title, style: const TextStyle(fontSize: 18, color: textColor))
            .tr(),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}

class ContentsTitle extends StatelessWidget {
  ContentsTitle({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CommonText(text: text, size: 15),
    );
  }
}

class UnitButtons extends StatelessWidget {
  UnitButtons({
    super.key,
    required this.type,
    required this.state,
    required this.onTap,
  });

  String type, state;
  Function({required String sUnit}) onTap;

  @override
  Widget build(BuildContext context) {
    final unitInfo = {
      'tall': ["cm", "inch"],
      'weight': ["kg", 'lb'],
    }[type]!;

    commonButton({required String unit}) {
      return CommonButton(
        text: unit,
        fontSize: state == unit ? 15 : 14,
        bgColor: state == unit ? textColor : Colors.grey.shade100,
        radious: 5,
        textColor: state == unit ? Colors.white : Colors.grey,
        isBold: state == unit,
        isNotTr: true,
        onTap: () => onTap(sUnit: unit),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          commonButton(unit: unitInfo[0]),
          SpaceWidth(width: 5),
          commonButton(unit: unitInfo[1]),
        ],
      ),
    );
  }
}

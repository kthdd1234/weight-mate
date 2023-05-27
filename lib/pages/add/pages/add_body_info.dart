import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';

class AddBodyInfo extends StatefulWidget {
  const AddBodyInfo({super.key});

  @override
  State<AddBodyInfo> createState() => _AddBodyInfoState();
}

class _AddBodyInfoState extends State<AddBodyInfo> {
  @override
  Widget build(BuildContext context) {
    final tallText = context.watch<DietInfoProvider>().getTallText();
    final weightText = context.watch<DietInfoProvider>().getWeightText();
    final goalWeightText =
        context.watch<DietInfoProvider>().getGoalWeightText();

    onChangedTallText(value) {
      context.read<DietInfoProvider>().changeTallText(value);
    }

    onChangedWeightText(value) {
      context.read<DietInfoProvider>().changeWeightText(value);
    }

    onChangedGoalWeightText(value) {
      context.read<DietInfoProvider>().changeGoalWeightText(value);
    }

    setErrorTextTall() {
      return handleCheckErrorText(
        text: tallText,
        min: tallMin,
        max: tallMax,
        errMsg: tallErrMsg,
      );
    }

    setErrorTextWeight() {
      return handleCheckErrorText(
        text: weightText,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    setErrorTextGoalWeight() {
      return handleCheckErrorText(
        text: goalWeightText,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    onCheckedButtonEnabled() {
      return tallText != '' &&
          weightText != '' &&
          goalWeightText != '' &&
          setErrorTextTall() == null &&
          setErrorTextWeight() == null &&
          setErrorTextGoalWeight() == null;
    }

    onPressedBottomNavigationButton() {
      if (onCheckedButtonEnabled()) {
        // Navigator.pushNamed(context, '/add-goal-weight');
      }

      return null;
    }

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 1),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '프로필 정보를 입력해주세요.'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            height: null,
            contentsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentsTitleText(text: '키'),
                TextInput(
                  maxLength: 5,
                  prefixIcon: Icons.accessibility_new_sharp,
                  suffixText: 'cm',
                  counterText: '(예: 165, 173.2)',
                  hintText: '키를 입력해주세요.',
                  errorText: setErrorTextTall(),
                  onChanged: onChangedTallText,
                ),
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '체중'),
                TextInput(
                  maxLength: 4,
                  prefixIcon: Icons.monitor_weight,
                  suffixText: 'kg',
                  counterText: '(예: 59, 63.5)',
                  hintText: '체중을 입력해주세요.',
                  errorText: setErrorTextWeight(),
                  onChanged: onChangedWeightText,
                ),
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '목표 체중'),
                TextInput(
                  maxLength: 4,
                  prefixIcon: Icons.flag,
                  suffixText: 'kg',
                  counterText: '(예: 50, 70.5)',
                  hintText: '목표 체중을 입력해주세요.',
                  errorText: setErrorTextGoalWeight(),
                  onChanged: onChangedGoalWeightText,
                ),
              ],
            ),
          ),
          SpaceHeight(height: regularSapce),
          BottomText(bottomText: '키와 몸무게는 체질량 지수(BMI)를 계산하는데 사용됩니다.')
        ],
      ),
      bottomSubmitButtonText: '다음',
      buttonEnabled: onCheckedButtonEnabled(),
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
      actions: [],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/pages/onboarding/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/onboarding/action_bar.dart';
import 'package:flutter_app_weight_management/pages/onboarding/add_container.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_start_screen.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

class AddBodyWeight extends StatefulWidget {
  const AddBodyWeight({super.key});

  @override
  State<AddBodyWeight> createState() => _AddBodyWeightState();
}

class _AddBodyWeightState extends State<AddBodyWeight> {
  String sWeightUnit = 'kg';
  TextEditingController goalWeightContoller = TextEditingController();
  FocusNode goalWeightNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    DietInfoProvider readProvider = context.read<DietInfoProvider>();

    isErrorGoalWeight() {
      return isShowErorr(
        unit: sWeightUnit,
        value: double.tryParse(goalWeightContoller.text),
      );
    }

    onChangedGoalWeight(_) {
      bool isInitText =
          isDoubleTryParse(text: goalWeightContoller.text) == false ||
              isErrorGoalWeight();

      if (isInitText) {
        goalWeightContoller.text = '';
      }

      setState(() {});
    }

    onTapUnitButton({required String sUnit}) {
      if (sUnit != sWeightUnit) {
        String? goalWeight = convertWeight(
          unit: sUnit,
          wegiht: goalWeightContoller.text,
        );

        if (goalWeight != null) {
          setState(() => goalWeightContoller.text = goalWeight);
        }

        setState(() => sWeightUnit = sUnit);
      }
    }

    actionItem(focusNode) {
      return KeyboardActionsItem(
        focusNode: focusNode,
        enabled: false,
        displayArrows: false,
        displayDoneButton: false,
        toolbarButtons: [(node) => ActionBar(node: node)],
      );
    }

    isOnButton() {
      String? goalWeight = convertWeight(
        unit: sWeightUnit,
        wegiht: goalWeightContoller.text,
      );

      bool isGoalWeightDone =
          isDoubleTryParse(text: goalWeightContoller.text) &&
              goalWeight != null &&
              isErrorGoalWeight() == false;

      return isGoalWeightDone;
    }

    weightInput({
      required String title,
      required bool autofocus,
      required FocusNode focusNode,
      required TextEditingController controller,
      required IconData prefixIcon,
      required String suffixText,
      required String hintText,
      required String? helperText,
      required Function(String) onChanged,
    }) {
      return Column(
        children: [
          ContentsTitle(text: title),
          TextInput(
            autofocus: autofocus,
            focusNode: focusNode,
            controller: controller,
            maxLength: 5,
            prefixIcon: prefixIcon,
            suffixText: suffixText,
            hintText: hintText.tr(),
            helperText: helperText,
            onChanged: onChanged,
          ),
          SpaceHeight(height: 10)
        ],
      );
    }

    onPressDone() async {
      if (isOnButton()) {
        readProvider.changeGoalWeightText(goalWeightContoller.text);
        readProvider.changeWeightUnit(sWeightUnit);

        await Navigator.pushNamed(context, '/add-alarm-permission');
      }
    }

    helperMsg() {
      int max = sWeightUnit == 'kg' ? kgMax.toInt() : lbMax.toInt();
      return '1 ~ max 의 값을 입력해주세요.'.tr(namedArgs: {'max': '$max'});
    }

    helperGoalWeightText() {
      return goalWeightContoller.text == '' ? helperMsg() : null;
    }

    return AddContainer(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: const Color(0xffCCCDD3),
            nextFocus: true,
            actions: [actionItem(goalWeightNode)],
          ),
          child: Column(
            children: [
              PageTitle(step: 2, title: '목표 체중과 단위를 입력해주세요.'),
              ContentsBox(
                contentsWidget: Column(
                  children: [
                    ContentsTitle(text: '체중 단위'),
                    UnitButtons(
                      type: 'weight',
                      state: sWeightUnit,
                      onTap: onTapUnitButton,
                    ),
                    weightInput(
                      title: '목표 체중',
                      autofocus: false,
                      focusNode: goalWeightNode,
                      controller: goalWeightContoller,
                      prefixIcon: goalWeightPrefixIcon,
                      suffixText: sWeightUnit,
                      helperText: helperGoalWeightText(),
                      hintText: '목표 체중',
                      onChanged: onChangedGoalWeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      buttonEnabled: isOnButton(),
      onPressedBottomNavigationButton: onPressDone,
      bottomSubmitButtonText: '완료',
    );
  }
}

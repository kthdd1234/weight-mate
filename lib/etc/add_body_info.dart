import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/onboarding/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

class AddBodyInfo extends StatefulWidget {
  const AddBodyInfo({super.key});

  @override
  State<AddBodyInfo> createState() => _AddBodyInfoState();
}

class _AddBodyInfoState extends State<AddBodyInfo> {
  TextEditingController tallContoller = TextEditingController(),
      weightContoller = TextEditingController(),
      goalWeightContoller = TextEditingController();

  final FocusNode _tallInput = FocusNode();
  final FocusNode _weightInput = FocusNode();
  final FocusNode _goalWeightInput = FocusNode();

  @override
  Widget build(BuildContext context) {
    DietInfoProvider watchProvider = context.watch<DietInfoProvider>();
    DietInfoProvider readProvider = context.read<DietInfoProvider>();
    UserInfoClass user = watchProvider.getUserInfo();
    String tallUnit = user.tallUnit;
    String weightUnit = user.weightUnit;

    onChangedValue(TextEditingController controller) {
      if (isDoubleTryParse(text: controller.text) == false) {
        controller.text = '';
      }

      setState(() {});
    }

    isTall() {
      return isDoubleTryParse(text: tallContoller.text);
    }

    isWeight() {
      return isDoubleTryParse(text: weightContoller.text);
    }

    isGoalWeight() {
      return isDoubleTryParse(text: goalWeightContoller.text);
    }

    isComplted() {
      return isTall() && isWeight() && isGoalWeight();
    }

    onComplted() {
      if (isComplted()) {
        readProvider.changeTallText(tallContoller.text);
        readProvider.changeWeightText(weightContoller.text);
        readProvider.changeGoalWeightText(goalWeightContoller.text);

        Navigator.pushNamed(context, '/add-plan-list');
      }

      return null;
    }

    bodyInputWidget({
      required FocusNode focusNode,
      required TextEditingController controller,
      required String title,
      required int maxLength,
      required IconData? prefixIcon,
      required String suffixText,
      required String counterText,
      required String hintText,
      required Function(String) onChanged,
    }) {
      return Column(
        children: [
          CommonText(text: title, size: 15, isBold: true),
          SpaceHeight(height: smallSpace),
          TextInput(
            focusNode: focusNode,
            autofocus: title == '키',
            controller: controller,
            maxLength: maxLength,
            prefixIcon: prefixIcon,
            suffixText: suffixText,
            counterText: counterText,
            hintText: hintText.tr(),
            onChanged: onChanged,
          )
        ],
      );
    }

    actionItem(focusNode) {
      return KeyboardActionsItem(
        focusNode: focusNode,
        enabled: false,
        displayArrows: false,
        displayDoneButton: false,
        toolbarButtons: [
          (node) {
            return ActionBar(node: node);
          }
        ],
      );
    }

    return AddContainer(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: const Color(0xffCCCDD3),
            nextFocus: true,
            actions: [
              actionItem(_tallInput),
              actionItem(_weightInput),
              actionItem(_goalWeightInput),
            ],
          ),
          child: Column(
            children: [
              ContentsBox(
                contentsWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: bodyInputWidget(
                            focusNode: _tallInput,
                            controller: tallContoller,
                            title: '키',
                            maxLength: 5,
                            prefixIcon: Icons.accessibility_new_sharp,
                            suffixText: tallUnit,
                            counterText: ' ',
                            hintText: '키',
                            onChanged: (_) => onChangedValue(tallContoller),
                          ),
                        ),
                        SpaceWidth(width: smallSpace),
                        Expanded(
                          child: bodyInputWidget(
                            focusNode: _weightInput,
                            controller: weightContoller,
                            title: '체중',
                            maxLength: 4,
                            prefixIcon: Icons.monitor_weight,
                            suffixText: weightUnit,
                            counterText: ' ',
                            hintText: '체중',
                            onChanged: (_) => onChangedValue(weightContoller),
                          ),
                        ),
                      ],
                    ),
                    SpaceHeight(height: regularSapce),
                    bodyInputWidget(
                      focusNode: _goalWeightInput,
                      controller: goalWeightContoller,
                      title: '목표 체중',
                      maxLength: 4,
                      prefixIcon: Icons.flag,
                      suffixText: weightUnit,
                      counterText: ' ',
                      hintText: '목표 체중',
                      onChanged: (_) => onChangedValue(goalWeightContoller),
                    ),
                  ],
                ),
              ),
              SpaceHeight(height: regularSapce),
              const Text(
                '키와 체중은 체질량 지수(BMI)를 계산하는데 사용됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12),
              ).tr(),
            ],
          ),
        ),
      ),
      bottomSubmitButtonText: '완료',
      buttonEnabled: isComplted(),
      onPressedBottomNavigationButton: onComplted,
    );
  }
}

class ActionBar extends StatelessWidget {
  ActionBar({super.key, required this.node});

  FocusNode node;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(tinySpace),
        child: Row(
          children: [
            CommonButton(
              text: '닫기',
              fontSize: 18,
              radious: 5,
              bgColor: Colors.white,
              textColor: textColor,
              onTap: () => node.unfocus(),
            ),
            SpaceWidth(width: tinySpace),
            CommonButton(
              text: '다음',
              fontSize: 18,
              radious: 5,
              bgColor: textColor,
              textColor: Colors.white,
              onTap: () => node.nextFocus(),
            ),
          ],
        ),
      ),
    );
  }
}

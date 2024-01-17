import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
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
    DietInfoProvider readProvider = context.read<DietInfoProvider>();

    onChangedValue(TextEditingController controller) {
      if (double.tryParse(controller.text) == null) {
        controller.text = '';
      }

      setState(() {});
    }

    setErrorTextTall() {
      return handleCheckErrorText(
        text: tallContoller.text == '.' ? '' : tallContoller.text,
        min: tallMin,
        max: tallMax,
        errMsg: tallErrMsg,
      );
    }

    setErrorTextWeight() {
      return handleCheckErrorText(
        text: weightContoller.text == '.' ? '' : weightContoller.text,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    setErrorTextGoalWeight() {
      return handleCheckErrorText(
        text: goalWeightContoller.text == '.' ? '' : goalWeightContoller.text,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    isTall() {
      return tallContoller.text != '' && setErrorTextTall() == null;
    }

    isWeight() {
      return weightContoller.text != '' && setErrorTextWeight() == null;
    }

    isGoalWeight() {
      return goalWeightContoller.text != '' && setErrorTextGoalWeight() == null;
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
      required dynamic errorText,
      required Function(String) onChanged,
    }) {
      return Column(
        children: [
          ContentsTitleText(text: title),
          SpaceHeight(height: smallSpace),
          TextInput(
            focusNode: focusNode,
            autofocus: title == '키',
            controller: controller,
            maxLength: maxLength,
            prefixIcon: prefixIcon,
            suffixText: suffixText,
            counterText: counterText,
            hintText: hintText,
            errorText: errorText,
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
              AddTitle(step: 1, title: '키와 체중을 입력해주세요.'),
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
                            suffixText: 'cm',
                            counterText: ' ',
                            hintText: '키',
                            errorText: setErrorTextTall(),
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
                            suffixText: 'kg',
                            counterText: ' ',
                            hintText: '체중',
                            errorText: setErrorTextWeight(),
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
                      suffixText: 'kg',
                      counterText: ' ',
                      hintText: '목표 체중',
                      errorText: setErrorTextGoalWeight(),
                      onChanged: (_) => onChangedValue(goalWeightContoller),
                    ),
                  ],
                ),
              ),
              SpaceHeight(height: regularSapce),
              BottomText(bottomText: '키와 체중은 체질량 지수(BMI)를 계산하는데 사용됩니다.')
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
              text: '취소',
              fontSize: 18,
              radious: 5,
              bgColor: Colors.white,
              textColor: themeColor,
              onTap: () => node.unfocus(),
            ),
            SpaceWidth(width: tinySpace),
            CommonButton(
              text: '다음',
              fontSize: 18,
              radious: 5,
              bgColor: themeColor,
              textColor: Colors.white,
              onTap: () => node.nextFocus(),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTitle extends StatelessWidget {
  AddTitle({
    super.key,
    required this.step,
    required this.title,
  });

  int step;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SimpleStepper(step: step),
        SpaceHeight(height: regularSapce),
        CommonText(text: title, size: 18),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}

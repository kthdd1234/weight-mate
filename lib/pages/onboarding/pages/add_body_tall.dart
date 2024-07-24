import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/pages/onboarding/action_bar.dart';
import 'package:flutter_app_weight_management/pages/onboarding/add_container.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_start_screen.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

class AddBodyTall extends StatefulWidget {
  const AddBodyTall({super.key});

  @override
  State<AddBodyTall> createState() => _AddBodyTallState();
}

class _AddBodyTallState extends State<AddBodyTall> {
  TextEditingController tallContoller = TextEditingController();
  String sTallUnit = 'cm';
  FocusNode tallNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    DietInfoProvider readProvider = context.read<DietInfoProvider>();

    isError() {
      return isShowErorr(
        unit: sTallUnit,
        value: double.tryParse(tallContoller.text),
      );
    }

    onChangedTall(_) {
      bool isInitText =
          isDoubleTryParse(text: tallContoller.text) == false || isError();

      if (isInitText) {
        tallContoller.text = '';
      }

      setState(() {});
    }

    onTapUnitButton({required String sUnit}) {
      if (sUnit != sTallUnit) {
        String? tall = convertTall(unit: sUnit, tall: tallContoller.text);

        if (tall != null) {
          tallContoller.text = tall;
        }

        sTallUnit = sUnit;
      }

      setState(() {});
    }

    isOnButton() {
      String? tall = convertTall(unit: sTallUnit, tall: tallContoller.text);

      return isDoubleTryParse(text: tallContoller.text) &&
          tall != null &&
          isError() == false;
    }

    onPressDone() async {
      if (isOnButton()) {
        readProvider.changeTallText(tallContoller.text);
        readProvider.changeTallUnit(sTallUnit);

        await Navigator.pushNamed(context, '/add-body-weight');
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

    helperText() {
      int max = sTallUnit == 'cm' ? cmMax.toInt() : inchMax.toInt();

      return tallContoller.text == ''
          ? '1 ~ max 의 값을 입력해주세요.'.tr(namedArgs: {'max': '$max'})
          : null;
    }

    return AddContainer(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: const Color(0xffCCCDD3),
            nextFocus: true,
            actions: [actionItem(tallNode)],
          ),
          child: Column(
            children: [
              PageTitle(step: 1, title: '현재 키와 단위를 입력해주세요.'),
              ContentsBox(
                contentsWidget: Column(
                  children: [
                    ContentsTitle(text: '키 단위'),
                    UnitButtons(
                      type: 'tall',
                      state: sTallUnit,
                      onTap: onTapUnitButton,
                    ),
                    ContentsTitle(text: '현재 키'),
                    TextInput(
                      autofocus: true,
                      focusNode: tallNode,
                      maxLength: 5,
                      controller: tallContoller,
                      prefixIcon: tallPrefixIcon,
                      suffixText: sTallUnit,
                      helperText: helperText(),
                      hintText: '키'.tr(),
                      onChanged: onChangedTall,
                    )
                  ],
                ),
              )
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

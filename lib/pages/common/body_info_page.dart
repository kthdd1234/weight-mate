import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/pages/onboarding/text_input.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class BodyInputClass {
  BodyInputClass({
    required this.prefixIcon,
    required this.suffixText,
    required this.hintText,
    this.helperText,
  });

  IconData prefixIcon;
  String suffixText;
  String hintText;
  String? helperText;
}

class BodyInfoPage extends StatefulWidget {
  const BodyInfoPage({super.key});

  @override
  State<BodyInfoPage> createState() => _BodyInfoPageState();
}

class _BodyInfoPageState extends State<BodyInfoPage> {
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    UserBox user = userRepository.user;
    Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String type = args['type']!;

    setState(() {
      controller.text = type == 'tall' ? '${user.tall}' : '${user.goalWeight}';
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String type = args['type']!;
    String title = args['title']!;
    UserBox user = userRepository.user;
    String tallUnit = user.tallUnit ?? 'cm';
    String weightUint = user.weightUnit ?? 'kg';

    isError() {
      return isShowErorr(
        unit: type == 'tall' ? tallUnit : weightUint,
        value: double.tryParse(controller.text),
      );
    }

    onChanged(String textValue) {
      bool isInitText =
          isDoubleTryParse(text: controller.text) == false || isError();

      if (isInitText) {
        controller.text = '';
      }

      setState(() {});
    }

    helperText({required String unit}) {
      Map<String, double> unitObj = {
        'kg': kgMax,
        'lb': lbMax,
        'cm': cmMax,
        'inch': inchMax
      };

      return controller.text == ''
          ? '1 ~ max 의 값을 입력해주세요.'.tr(namedArgs: {'max': '${unitObj[unit]}'})
          : null;
    }

    onCompletedTall() {
      if (isError() == false) {
        user.tall = double.parse(controller.text);
        user.save();

        Navigator.pop(context);
      }
    }

    onCompletedGoalWeight() {
      if (isError() == false) {
        user.goalWeight = double.parse(controller.text);
        user.save();

        Navigator.pop(context);
      }
    }

    BodyInputClass bodyInputObj = {
      'tall': BodyInputClass(
        prefixIcon: tallPrefixIcon,
        suffixText: tallUnit,
        hintText: tallHintText.tr(),
        helperText: helperText(unit: tallUnit),
      ),
      'goalWeight': BodyInputClass(
        prefixIcon: goalWeightPrefixIcon,
        suffixText: weightUint,
        hintText: goalWeightHintText.tr(),
        helperText: helperText(unit: weightUint),
      )
    }[type]!;

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: title),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ContentsBox(
              contentsWidget: TextInput(
                autofocus: true,
                focusNode: FocusNode(),
                controller: controller,
                maxLength: 5,
                prefixIcon: bodyInputObj.prefixIcon,
                suffixText: bodyInputObj.suffixText,
                hintText: bodyInputObj.hintText,
                helperText: bodyInputObj.helperText,
                onChanged: onChanged,
              ),
            ),
            BottomSubmitButton(
              padding: const EdgeInsets.all(0),
              isEnabled: !isError(),
              text: '완료'.tr(),
              onPressed:
                  type == 'tall' ? onCompletedTall : onCompletedGoalWeight,
            ),
          ],
        ),
      ),
    );
  }
}

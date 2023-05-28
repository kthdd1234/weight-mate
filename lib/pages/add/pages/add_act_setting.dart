import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class AddActSetting extends StatefulWidget {
  const AddActSetting({super.key});

  @override
  State<AddActSetting> createState() => _AddActSettingState();
}

class _AddActSettingState extends State<AddActSetting> {
  @override
  Widget build(BuildContext context) {
    final actType = context.watch<DietInfoProvider>().getActType();

    buttonEnabled() {
      return false;
    }

    setActTitle() {
      final titles = {
        ActTypeEnum.diet: '다이어트',
        ActTypeEnum.exercise: '운동',
        ActTypeEnum.lifestyle: '생활 습관'
      };

      return titles[actType];
    }

    setSub() {
      final sub = {
        ActTypeEnum.diet: '를',
        ActTypeEnum.exercise: '을',
        ActTypeEnum.lifestyle: '을'
      };

      return sub[actType];
    }

    onPressedBottomNavigationButton() {}

    return AddContainer(
      body: Column(children: [
        SimpleStepper(currentStep: 4),
        SpaceHeight(height: regularSapce),
        HeadlineText(text: '세부 옵션을 설정해주세요.'),
        SpaceHeight(height: regularSapce),
        ContentsBox(
          contentsWidget: Column(
            children: [
              ContentsTitleText(text: '${setActTitle()} 이름', icon: Icons.edit),
              ContentsTitleText(text: '기간 설정', icon: Icons.calendar_month),
              ContentsTitleText(text: '알림 설정', icon: Icons.notification_add),
            ],
          ),
        ),
      ]),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}

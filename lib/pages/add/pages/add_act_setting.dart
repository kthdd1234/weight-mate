import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_default_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
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
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/act_alarm.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_app_weight_management/widgets/date_time_range_input_widget.dart';
import 'package:flutter_app_weight_management/widgets/date_time_tap_widget.dart';
import 'package:provider/provider.dart';

import '../../../components/area/empty_area.dart';
import '../../../components/picker/default_date_time_picker.dart';

class AddActSetting extends StatefulWidget {
  const AddActSetting({super.key});

  @override
  State<AddActSetting> createState() => _AddActSettingState();
}

class _AddActSettingState extends State<AddActSetting> {
  DateTime startActDateTime = DateTime.now();
  DateTime? endActDateTime;

  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  bool isEnabledAlarm = true;
  late DateTime alarmTime;
  late DateTime timeValue;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    alarmTime = DateTime(now.year, now.month, now.day, 10, 30);
    startActDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final actType = context.watch<DietInfoProvider>().getActType();
    final subActType = context.watch<DietInfoProvider>().getSubActType();

    print(actType);
    print(subActType);

    buttonEnabled() {
      return false;
    }

    onPressedBottomNavigationButton() {
      print(nameController.text);
      print(memoController.text);
    }

    titleWidgets(String type) {
      final String text = type == 'start' ? '시작일' : '종료일';
      final Color color = type == 'start' ? buttonBackgroundColor : Colors.red;

      return [
        Text(
          '$text 설정',
          style: const TextStyle(color: buttonBackgroundColor, fontSize: 17),
        ),
        Row(
          children: [
            ColorTextInfo(
              width: smallSpace,
              height: smallSpace,
              text: text,
              color: color,
            ),
          ],
        )
      ];
    }

    onSubmitDialog({type, Object? object}) {
      setState(() {
        if (object is DateTime) {
          type == 'start' ? startActDateTime = object : endActDateTime = object;
        }
      });

      closeDialog(context);
    }

    onTapInput({type, DateTime? dateTime}) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalendarDefaultDialog(
          type: type,
          titleWidgets: titleWidgets(type),
          initialDateTime: dateTime,
          onSubmit: onSubmitDialog,
          onCancel: () => closeDialog(context),
          minDate: type == 'end' ? startActDateTime : null,
        ),
      );
    }

    onDateTimeChanged(DateTime value) {
      setState(() => timeValue = value);
    }

    onTapButton() {
      setState(() => alarmTime = timeValue);
      closeDialog(context);
    }

    onTapAlarm(String id) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: '${actTitles[actType]} 실천 알림',
          widgets: [
            DefaultTimePicker(
              initialDateTime: alarmTime,
              onDateTimeChanged: onDateTimeChanged,
            )
          ],
          isEnabled: true,
          submitText: '완료',
          onSubmit: onTapButton,
        ),
      );
    }

    onChangedSwitch(bool newValue) {
      setState(() => isEnabledAlarm = newValue);
    }

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 4),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '${actTitles[actType]} 실천 계획을 세워보세요.'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(text: '종류'),
                SpaceHeight(height: smallSpace),
                TextInput(
                  controller: nameController,
                  autofocus: true,
                  maxLength: 12,
                  prefixIcon: Icons.edit,
                  suffixText: '',
                  hintText: '종류를 입력해주세요.',
                  counterText: '(예: )',
                  onChanged: (_) {},
                  errorText: null,
                ),
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '기간'),
                SpaceHeight(height: smallSpace),
                DateTimeRangeInputWidget(
                  startActDateTime: startActDateTime,
                  endActDateTime: endActDateTime,
                  onTapInput: onTapInput,
                ),
                SpaceHeight(height: regularSapce + smallSpace),
                ContentsTitleText(text: '알림'),
                SpaceHeight(height: regularSapce),
                ActAlarm(
                  isEnabledAlarm: isEnabledAlarm,
                  actType: actType,
                  onChanged: onChangedSwitch,
                ),
                SpaceHeight(height: smallSpace),
                isEnabledAlarm
                    ? TimeChipWidget(
                        id: 'dietAlarm',
                        time: alarmTime,
                        onTap: onTapAlarm,
                      )
                    : const EmptyArea()
              ],
            ),
          ),
          SpaceHeight(height: regularSapce),
          BottomText(bottomText: '기록 페이지에서 여러개의 계획을 추가할 수 있어요.')
        ],
      ),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}

// ContentsTitleText(text: '메모'),
// SpaceHeight(height: smallSpace),
// TextInput(
//   controller: memoController,
//   autofocus: true,
//   maxLength: 12,
//   prefixIcon: Icons.sms,
//   suffixText: '',
//   hintText: '메모를 입력해주세요.',
//   counterText: '(예: )',
//   onChanged: (_) {},
//   errorText: null,
// ),
// SpaceHeight(height: largeSpace),

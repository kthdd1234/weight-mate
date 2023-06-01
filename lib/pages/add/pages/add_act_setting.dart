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
import 'package:flutter_app_weight_management/model/act_box/act_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/act_alarm.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_app_weight_management/widgets/date_time_range_input_widget.dart';
import 'package:flutter_app_weight_management/widgets/date_time_tap_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../components/area/empty_area.dart';
import '../../../components/picker/default_date_time_picker.dart';

class AddActSetting extends StatefulWidget {
  AddActSetting({
    super.key,
    required this.actInfo,
  });

  ActInfoClass actInfo;

  @override
  State<AddActSetting> createState() => _AddActSettingState();
}

class _AddActSettingState extends State<AddActSetting> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<ActBox> actBox;

  TextEditingController nameController = TextEditingController();
  DateTime startActDateTime = DateTime.now();
  DateTime? endActDateTime;
  bool isAlarm = true;
  late DateTime alarmTime;
  late DateTime timeValue;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    nameController.text = widget.actInfo.subActTitle;
    alarmTime = DateTime(now.year, now.month, now.day, 10, 30);
    startActDateTime = DateTime.now();

    userBox = Hive.box<UserBox>('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');
    actBox = Hive.box<ActBox>('actBox');
  }

  @override
  Widget build(BuildContext context) {
    buttonEnabled() {
      return nameController.text != '';
    }

    onChangedText(_) {
      setState(() {});
    }

    onPressedBottomNavigationButton() {
      final provider = context.read<DietInfoProvider>();
      final userInfoState = provider.getUserInfo();
      final recordInfoState = provider.getRecordInfo();
      final now = DateTime.now();

      if (buttonEnabled()) {
        context.read<ImportDateTimeProvider>().setImportDateTime(now);

        userBox.put(
          'userBox',
          UserBox(
            userId: const Uuid().v1(),
            tall: userInfoState.tall,
            goalWeight: userInfoState.goalWeight,
            recordStartDateTime: now,
          ),
        );

        recordBox.put(
          getDateTimeToInt(now),
          RecordBox(
            recordDateTime: now,
            weight: recordInfoState.weight,
            actList: [widget.actInfo.id],
            memo: null,
          ),
        );

        actBox.put(
          widget.actInfo.id,
          ActBox(
            id: widget.actInfo.id,
            mainActType: widget.actInfo.mainActType.toString(),
            mainActTitle: widget.actInfo.mainActTitle,
            subActType: widget.actInfo.subActType,
            subActTitle: widget.actInfo.subActTitle,
            startActDateTime: startActDateTime,
            isAlarm: isAlarm,
          ),
        );

        return Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-container',
          (_) => false,
        );
      }

      return null;
    }

    titleWidgets(String type) {
      final String text = type == 'start' ? '시작일' : '종료일';
      final Color color = type == 'start' ? buttonBackgroundColor : Colors.red;

      return [
        Text(
          '$text을 선택해주세요.',
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
          title: '알림 시간 설정',
          widgets: [
            DefaultTimePicker(
              initialDateTime: alarmTime,
              mode: CupertinoDatePickerMode.time,
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
      setState(() => isAlarm = newValue);
    }

    onCounterText() {
      if (widget.actInfo.subActType == 'custom') {
        return mainActTypeCounterText[widget.actInfo.mainActType]!;
      }

      return '* 종류 이름은 언제든지 수정이 가능해요.';
    }

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 4),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '${widget.actInfo.mainActTitle} 실천 계획을 세워보세요.'),
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
                  counterText: onCounterText(),
                  onChanged: onChangedText,
                  errorText: null,
                  keyboardType: TextInputType.text,
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
                  isEnabledAlarm: isAlarm,
                  actInfo: widget.actInfo,
                  onChanged: onChangedSwitch,
                ),
                SpaceHeight(height: smallSpace),
                isAlarm
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

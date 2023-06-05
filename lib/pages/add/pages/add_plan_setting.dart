import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_default_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/add_title_widget.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_app_weight_management/widgets/date_time_range_input_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../components/picker/default_date_time_picker.dart';

class AddPlanSetting extends StatefulWidget {
  AddPlanSetting({
    super.key,
    required this.planInfo,
  });

  PlanInfoClass planInfo;

  @override
  State<AddPlanSetting> createState() => _AddPlanSettingState();
}

class _AddPlanSettingState extends State<AddPlanSetting> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;

  TextEditingController nameController = TextEditingController();
  DateTime startDateTime = DateTime.now();
  DateTime? endActDateTime;
  bool isAlarm = true;
  late DateTime alarmTime;
  late DateTime timeValue;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    nameController.text = widget.planInfo.name;
    alarmTime = DateTime(now.year, now.month, now.day, 10, 30);
    startDateTime = DateTime.now();

    userBox = Hive.box<UserBox>('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');
    planBox = Hive.box<PlanBox>('planBox');
  }

  @override
  Widget build(BuildContext context) {
    final screenPoint =
        ModalRoute.of(context)!.settings.arguments as argmentsTypeEnum;

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
      final uuidV1 = const Uuid().v1();
      final uuidV4 = const Uuid().v4();

      if (buttonEnabled()) {
        context.read<ImportDateTimeProvider>().setImportDateTime(now);

        if (screenPoint == argmentsTypeEnum.start) {
          userBox.put(
            'userBox',
            UserBox(
              userId: uuidV1,
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
            ),
          );
        }

        planBox.put(
          uuidV4,
          PlanBox(
            id: uuidV4,
            type: widget.planInfo.type.toString(),
            title: widget.planInfo.title,
            name: widget.planInfo.name,
            startDateTime: startDateTime,
            endDateTime: endActDateTime,
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
          type == 'start' ? startDateTime = object : endActDateTime = object;
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
          minDate: type == 'end' ? startDateTime : null,
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
          height: 380,
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
      if (widget.planInfo.id == 'custom') {
        return planTypeDetailInfo[widget.planInfo.type]!.counterText;
      }

      return '* 이름은 언제든지 수정이 가능해요.';
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitleWidget(
            argmentsType: screenPoint,
            step: 4,
            title: '나만의 ${widget.planInfo.title} 계획을 세워보세요.',
          ),
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(text: '이름'),
                SpaceHeight(height: smallSpace),
                TextInput(
                  controller: nameController,
                  autofocus: true,
                  maxLength: 12,
                  prefixIcon: Icons.edit,
                  suffixText: '',
                  hintText: '이름을 입력해주세요.',
                  counterText: onCounterText(),
                  onChanged: onChangedText,
                  errorText: null,
                  keyboardType: TextInputType.text,
                ),
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '기간'),
                SpaceHeight(height: smallSpace),
                DateTimeRangeInputWidget(
                  startDateTime: startDateTime,
                  endDateTime: endActDateTime,
                  onTapInput: onTapInput,
                ),
                SpaceHeight(height: regularSapce + smallSpace),
                ContentsTitleText(text: '알림'),
                SpaceHeight(height: regularSapce),
                AlarmItemWidget(
                  id: 'alarm-setting',
                  title: '${widget.planInfo.title} 실천 알림',
                  desc: '설정한 시간에 실천 알림을 보내드려요.',
                  isEnabled: isAlarm,
                  alarmTime: alarmTime,
                  onTap: onTapAlarm,
                  onChanged: onChangedSwitch,
                  chipBackgroundColor: dialogBackgroundColor,
                  iconBackgroundColor: dialogBackgroundColor,
                )
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

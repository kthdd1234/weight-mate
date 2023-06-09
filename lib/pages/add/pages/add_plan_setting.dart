import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_default_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/add_title_widget.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/date_time_range_input_widget.dart';
import 'package:flutter_app_weight_management/widgets/name_text_input.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPlanSetting extends StatefulWidget {
  const AddPlanSetting({super.key});

  @override
  State<AddPlanSetting> createState() => _AddPlanSettingState();
}

class _AddPlanSettingState extends State<AddPlanSetting> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime timeValue;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box<UserBox>('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');
    planBox = Hive.box<PlanBox>('planBox');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DietInfoProvider>();
    final planInfo = provider.getPlanInfo();
    final argmentsType =
        ModalRoute.of(context)!.settings.arguments as argmentsTypeEnum;

    buttonEnabled() {
      return planInfo.name != '';
    }

    onChanged(String str) {
      planInfo.name = str;

      setState(() {});
    }

    onPressedBottomNavigationButton() {
      final userInfoState = provider.getUserInfo();
      final recordInfoState = provider.getRecordInfo();
      final now = DateTime.now();
      final uuidV1 = const Uuid().v1();
      final uuidV4 = const Uuid().v4();
      final setId =
          argmentsType == argmentsTypeEnum.edit ? planInfo.id : uuidV4;

      final notifyWeightUid = UniqueKey().hashCode;
      final notifyPlanUid = UniqueKey().hashCode;

      if (buttonEnabled()) {
        context.read<ImportDateTimeProvider>().setImportDateTime(now);

        if (argmentsType == argmentsTypeEnum.start) {
          userBox.put(
            'userBox',
            UserBox(
              userId: uuidV1,
              tall: userInfoState.tall,
              goalWeight: userInfoState.goalWeight,
              recordStartDateTime: now,
              isWeightAlarm: userInfoState.isWeightAlarm,
              weightAlarmTime: userInfoState.isWeightAlarm
                  ? userInfoState.weightAlarmTime
                  : null,
              alarmId: userInfoState.isWeightAlarm ? notifyWeightUid : null,
            ),
          );

          recordBox.put(
            getDateTimeToInt(now),
            RecordBox(
              recordDateTime: now,
              weight: recordInfoState.weight,
            ),
          );

          // todo: userInfoState.isWeightAlarm 이 true 라면 알람 추가
          if (userInfoState.isWeightAlarm) {
            NotificationService().addNotification(
              id: notifyWeightUid,
              alarmTime: userInfoState.weightAlarmTime!,
              title: '체중 기록 알림',
              body: '오늘의 체중을 입력 할 시간이에요.',
            );
          }
        }

        planBox.put(
          setId,
          PlanBox(
            id: setId,
            type: planInfo.type.toString(),
            title: planInfo.title,
            name: planInfo.name,
            startDateTime: planInfo.startDateTime,
            endDateTime: planInfo.endDateTime,
            isAlarm: planInfo.isAlarm,
            alarmTime: planInfo.isAlarm ? planInfo.alarmTime : null,
          ),
        );

        if (planInfo.isAlarm) {
          NotificationService().addNotification(
            id: notifyPlanUid,
            alarmTime: planInfo.alarmTime!,
            title: '계획 실천 알림',
            body: '오늘의 계획을 실천해보세요.',
          );
        } else {
          if (argmentsType == argmentsTypeEnum.edit) {
            // todo:
          }
        }

        provider.initDietInfoProvider();

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
      if (object is DateTime) {
        type == 'start'
            ? planInfo.startDateTime = object
            : planInfo.endDateTime = object;

        setState(() {});
      }

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
          minDate: type == 'end' ? planInfo.startDateTime : null,
        ),
      );
    }

    onDateTimeChanged(DateTime value) {
      setState(() => timeValue = value);
    }

    onSubmit() {
      planInfo.alarmTime = timeValue;
      setState(() {});
      closeDialog(context);
    }

    onTapAlarm(String id) {
      showAlarmBottomSheet(
        context: context,
        initialDateTime: planInfo.alarmTime!,
        onDateTimeChanged: onDateTimeChanged,
        onSubmit: onSubmit,
      );
    }

    onChangedSwitch(bool newValue) async {
      if (newValue) {
        final isPermission = await NotificationService().permissionNotification;

        if (isPermission == false) {
          // ignore: use_build_context_synchronously
          showSnackBar(
            context: context,
            width: 270,
            text: '알림 권한이 없어요.',
            buttonName: '설정창으로 이동',
            onPressed: openAppSettings,
          );
        }
      }

      planInfo.isAlarm = newValue;
      setState(() {});
    }

    onCounterText() {
      if (planInfo.id == 'custom') {
        return planTypeDetailInfo[planInfo.type]!.counterText;
      }

      return '* 이름은 언제든지 수정이 가능해요.';
    }

    setPageTitle() {
      return argmentsType == argmentsTypeEnum.edit ? '계획 편집' : null;
    }

    setAppTitleWidget() {
      return argmentsType == argmentsTypeEnum.edit
          ? const EmptyArea()
          : AddTitleWidget(
              argmentsType: argmentsType,
              step: 4,
              title: '나만의 ${planInfo.title} 계획을 세워보세요.',
            );
    }

    setBottomWidget() {
      return argmentsType == argmentsTypeEnum.edit
          ? const EmptyArea()
          : Column(
              children: [
                SpaceHeight(height: regularSapce),
                BottomText(bottomText: '기록 페이지에서 여러개의 계획을 추가할 수 있어요.')
              ],
            );
    }

    setBottomButtonText() {
      return argmentsType == argmentsTypeEnum.edit ? '수정하기' : '완료';
    }

    return AddContainer(
      title: setPageTitle(),
      body: Column(
        children: [
          setAppTitleWidget(),
          ContentsBox(
            contentsWidget: Column(
              children: [
                nameTextInput(
                  name: planInfo.name,
                  onCounterText: onCounterText,
                  onChanged: onChanged,
                ),
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '기간'),
                SpaceHeight(height: smallSpace),
                DateTimeRangeInputWidget(
                  startDateTime: planInfo.startDateTime,
                  endDateTime: planInfo.endDateTime,
                  onTapInput: onTapInput,
                ),
                SpaceHeight(height: regularSapce + smallSpace),
                ContentsTitleText(text: '알림'),
                SpaceHeight(height: regularSapce),
                AlarmItemWidget(
                  id: 'alarm-setting',
                  title: '${planInfo.title} 실천 알림',
                  desc: '설정한 시간에 실천 알림을 보내드려요.',
                  icon: Icons.notifications_active,
                  isEnabled: planInfo.isAlarm,
                  alarmTime: planInfo.alarmTime,
                  onTap: planInfo.alarmTime != null ? onTapAlarm : (_) {},
                  onChanged: onChangedSwitch,
                  chipBackgroundColor: dialogBackgroundColor,
                  iconBackgroundColor: dialogBackgroundColor,
                )
              ],
            ),
          ),
          setBottomWidget()
        ],
      ),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: setBottomButtonText(),
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

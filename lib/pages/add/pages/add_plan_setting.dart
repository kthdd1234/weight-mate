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

    timeValue = initAlarmDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final importProvider = context.read<ImportDateTimeProvider>();
    final infoProvider = context.read<DietInfoProvider>();
    final planInfo = infoProvider.getPlanInfo();
    final notifyWeightUid = UniqueKey().hashCode;
    final notifyPlanUid = UniqueKey().hashCode;
    final argmentsType =
        ModalRoute.of(context)!.settings.arguments as ArgmentsTypeEnum;

    buttonEnabled() {
      return planInfo.name != '';
    }

    onChanged(String str) {
      planInfo.name = str;

      setState(() {});
    }

    addPlanNotification({int? planId}) {
      NotificationService().addNotification(
        id: planId ?? notifyPlanUid,
        alarmTime: planInfo.alarmTime!,
        title: '계획 실천 알림',
        body: '${planInfo.name} 실천해보세요.',
      );
    }

    setStartPage() {
      final userInfoState = infoProvider.getUserInfo();
      final recordInfoState = infoProvider.getRecordInfo();
      final uuidV1 = const Uuid().v1();

      notification.cancelAll();

      userBox.put(
        'userProfile',
        UserBox(
          userId: uuidV1,
          tall: userInfoState.tall,
          goalWeight: userInfoState.goalWeight,
          createDateTime: now,
          isAlarm: userInfoState.isAlarm,
          alarmTime: userInfoState.isAlarm ? userInfoState.alarmTime : null,
          alarmId: userInfoState.isAlarm ? notifyWeightUid : null,
        ),
      );

      recordBox.put(
        getDateTimeToInt(now),
        RecordBox(
          createDateTime: now,
          weightDateTime: now,
          weight: recordInfoState.weight,
        ),
      );

      if (userInfoState.isAlarm) {
        NotificationService().addNotification(
          id: notifyWeightUid,
          alarmTime: userInfoState.alarmTime!,
          title: '체중 기록 알림',
          body: '오늘의 체중을 입력 할 시간이에요.',
        );
      }

      if (planInfo.isAlarm) {
        addPlanNotification();
      }

      importProvider.setImportDateTime(now);
    }

    setAddPage() {
      if (planInfo.isAlarm) {
        addPlanNotification();
      }
    }

    setEditPage() async {
      final notificationIds =
          await NotificationService().pendingNotificationIds;

      if (planInfo.isAlarm) {
        bool isContainId = notificationIds.contains(planInfo.alarmId);
        addPlanNotification(planId: isContainId ? planInfo.alarmId : null);
      } else {
        NotificationService().deleteMultipleAlarm([
          planInfo.alarmId.toString(),
        ]);
      }
    }

    onPressedBottomNavigationButton() async {
      final planInfoId = argmentsType == ArgmentsTypeEnum.edit
          ? planInfo.id
          : const Uuid().v4();
      final argmentsTypeMaps = {
        ArgmentsTypeEnum.start: setStartPage,
        ArgmentsTypeEnum.add: setAddPage,
        ArgmentsTypeEnum.edit: setEditPage
      };

      if (buttonEnabled()) {
        argmentsTypeMaps[argmentsType]!();

        planBox.put(
          planInfoId,
          PlanBox(
            id: planInfoId,
            type: planInfo.type.toString(),
            title: planInfo.title,
            name: planInfo.name,
            startDateTime: planInfo.startDateTime,
            endDateTime: planInfo.endDateTime,
            isAlarm: planInfo.isAlarm,
            alarmTime: planInfo.isAlarm ? planInfo.alarmTime : null,
            alarmId: planInfo.isAlarm ? notifyPlanUid : null,
          ),
        );

        infoProvider.setInitPlanInfo();

        Navigator.pushNamedAndRemoveUntil(
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

    onTapAlarm(dynamic id) {
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

        planInfo.alarmTime ??= initAlarmDateTime;
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
      return argmentsType == ArgmentsTypeEnum.edit ? '계획 편집' : null;
    }

    setAppTitleWidget() {
      return argmentsType == ArgmentsTypeEnum.edit
          ? const EmptyArea()
          : AddTitleWidget(
              argmentsType: argmentsType,
              step: 4,
              title: '나만의 ${planInfo.title} 계획을 세워보세요.',
            );
    }

    setBottomWidget() {
      return argmentsType == ArgmentsTypeEnum.edit
          ? const EmptyArea()
          : Column(
              children: [
                SpaceHeight(height: regularSapce),
                BottomText(bottomText: '기록 화면에서 여러 계획을 추가할 수 있어요.')
              ],
            );
    }

    setBottomButtonText() {
      return argmentsType == ArgmentsTypeEnum.edit ? '수정하기' : '완료';
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
                  desc: '매일 실천 알림을 드려요.',
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

      // final userInfoState = provider.getUserInfo();
      // final recordInfoState = provider.getRecordInfo();
      // final now = DateTime.now();
      // final uuidV1 = const Uuid().v1();

        // if (argmentsType == argmentsTypeEnum.start) {
        //   userBox.put(
        //     'userBox',
        //     UserBox(
        //       userId: uuidV1,
        //       tall: userInfoState.tall,
        //       goalWeight: userInfoState.goalWeight,
        //       recordStartDateTime: now,
        //       isWeightAlarm: userInfoState.isWeightAlarm,
        //       weightAlarmTime: userInfoState.isWeightAlarm
        //           ? userInfoState.weightAlarmTime
        //           : null,
        //       alarmId: userInfoState.isWeightAlarm ? notifyWeightUid : null,
        //     ),
        //   );

        //   recordBox.put(
        //     getDateTimeToInt(now),
        //     RecordBox(
        //       recordDateTime: now,
        //       weight: recordInfoState.weight,
        //     ),
        //   );

        //   if (userInfoState.isWeightAlarm) {
        //     NotificationService().addNotification(
        //       id: notifyWeightUid,
        //       alarmTime: userInfoState.weightAlarmTime!,
        //       title: '체중 기록 알림',
        //       body: '오늘의 체중을 입력 할 시간이에요.',
        //     );
        //   }
        // }


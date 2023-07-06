import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/add_title_widget.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/name_text_input.dart';
import 'package:flutter_app_weight_management/widgets/plan_item_widget.dart';
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
    final importProvider = context.watch<ImportDateTimeProvider>();
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

    addPlanNotification({required int alarmId, required DateTime dateTime}) {
      NotificationService().addNotification(
        id: alarmId,
        dateTime: dateTime,
        alarmTime: planInfo.alarmTime!,
        title: planNotifyTitle(),
        body: planNotifyBody(title: planInfo.title, body: planInfo.name),
        payload: 'plan',
      );
    }

    setStartPage() {
      final userInfoState = infoProvider.getUserInfo();
      final recordInfoState = infoProvider.getRecordInfo();
      final uuidV1 = const Uuid().v1();
      final now = DateTime.now();

      NotificationService().notification.cancelAll();

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
          dateTime: now,
          title: weightNotifyTitle(),
          body: weightNotifyBody(),
          payload: 'weight',
        );
      }

      if (planInfo.isAlarm) {
        addPlanNotification(alarmId: notifyPlanUid, dateTime: now);
      }
    }

    setEditPage() async {
      final notificationIds =
          await NotificationService().pendingNotificationIds;

      if (planInfo.isAlarm) {
        bool isAlarmId = notificationIds.contains(planInfo.alarmId);

        addPlanNotification(
          alarmId: isAlarmId ? planInfo.alarmId! : notifyPlanUid,
          dateTime: importProvider.getImportDateTime(),
        );
      } else {
        NotificationService().deleteMultipleAlarm([
          planInfo.alarmId.toString(),
        ]);
      }
    }

    onPressedBottomNavigationButton() async {
      final planInfoId =
          argmentsType == ArgmentsTypeEnum.edit ? planInfo.id : getUUID();
      final argmentsTypeMaps = {
        ArgmentsTypeEnum.start: setStartPage,
        ArgmentsTypeEnum.edit: setEditPage
      };
      final createDateTime = argmentsType == ArgmentsTypeEnum.edit
          ? planInfo.createDateTime
          : DateTime.now();

      if (buttonEnabled()) {
        argmentsTypeMaps[argmentsType]!();

        planBox.put(
          planInfoId,
          PlanBox(
            id: planInfoId,
            type: planInfo.type.toString(),
            title: planInfo.title,
            name: planInfo.name,
            priority: planInfo.priority.toString(),
            isAlarm: planInfo.isAlarm,
            alarmTime: planInfo.isAlarm ? planInfo.alarmTime : null,
            alarmId: planInfo.isAlarm ? notifyPlanUid : null,
            createDateTime: createDateTime,
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
        } else {
          infoProvider.changeIsPlanAlarm(newValue);
        }

        planInfo.alarmTime ??= initAlarmDateTime;
      } else {
        infoProvider.changeIsPlanAlarm(newValue);
      }

      setState(() {});
    }

    onCounterText() {
      if (planInfo.id == 'custom') {
        return planTypeDetailInfo[planInfo.type]!.counterText;
      }

      return '* 이름은 언제든지 수정이 가능해요.';
    }

    setPageTitle() {
      return argmentsType == ArgmentsTypeEnum.edit ? '계획 수정하기' : null;
    }

    setAppTitleWidget() {
      return argmentsType == ArgmentsTypeEnum.edit
          ? const EmptyArea()
          : AddTitleWidget(
              argmentsType: argmentsType,
              step: 4,
              title: '오늘의 ${planInfo.title} 계획을 세워보세요.',
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

    onTapItem(enumId) {
      setState(() => planInfo.priority = enumId);
    }

    setPlanPriority(int index) {
      final item = planPriorityInfos[index]!;

      return Expanded(
        child: PlanItemWidget(
          id: item['id'] as PlanPriorityEnum,
          name: item['name'] as String,
          desc: item['desc'] as String,
          icon: item['icon'] as IconData,
          isEnabled: item['id'] == planInfo.priority,
          onTap: onTapItem,
        ),
      );
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
                ContentsTitleText(text: '우선 순위'),
                SpaceHeight(height: smallSpace),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      setPlanPriority(0),
                      SpaceWidth(width: smallSpace),
                      setPlanPriority(1),
                      SpaceWidth(width: smallSpace),
                      setPlanPriority(2),
                    ],
                  ),
                ),
                SpaceHeight(height: regularSapce + smallSpace),
                ContentsTitleText(text: '알림'),
                SpaceHeight(height: regularSapce),
                AlarmItemWidget(
                  id: 'alarm-setting',
                  title: '계획 실천 알림',
                  desc: '정해진 시간에 실천 알림을 드려요.',
                  icon: Icons.notifications_active,
                  isEnabled: planInfo.isAlarm,
                  alarmTime: planInfo.alarmTime,
                  onTap: planInfo.alarmTime != null ? onTapAlarm : (_) {},
                  chipBackgroundColor: dialogBackgroundColor,
                  iconBackgroundColor: dialogBackgroundColor,
                  onChanged: onChangedSwitch,
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

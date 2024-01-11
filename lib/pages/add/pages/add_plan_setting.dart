import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_body_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/alarm_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
// import 'package:flutter_app_weight_management/etc/widgets/add_title_widget.dart';
// import 'package:flutter_app_weight_management/etc/widgets/name_text_input.dart';
// import 'package:flutter_app_weight_management/etc/widgets/plan_item_widget.dart';
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
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime timeValue;

  @override
  void initState() {
    super.initState();

    recordBox = Hive.box<RecordBox>('recordBox');
    planBox = Hive.box<PlanBox>('planBox');

    timeValue = initDateTime();
  }

  @override
  Widget build(BuildContext context) {
    final importProvider = context.watch<ImportDateTimeProvider>();
    final infoProvider = context.read<DietInfoProvider>();
    final planInfo = infoProvider.getPlanInfo();
    final newUserAlarmtUid = UniqueKey().hashCode;
    final newPlanAlarmUid = UniqueKey().hashCode;
    final argmentsType =
        ModalRoute.of(context)!.settings.arguments as ArgmentsTypeEnum;
    final argmentsTypeIdx = ArgmentsTypeEnum.start == argmentsType
        ? 0
        : ArgmentsTypeEnum.add == argmentsType
            ? 1
            : 2;
    final argmentsTypeList = [
      ArgmentsTypeClass(
        pageTitle: null,
        contentsTitleWidget: AddTitleWidget(
          argmentsType: argmentsType,
          step: 2,
          title: '간단하게 계획을 세워보세요.',
        ),
        createDateTime: DateTime.now(),
        planId: uuid(),
        buttonText: '완료',
      ),
      ArgmentsTypeClass(
        pageTitle: '계획 추가',
        contentsTitleWidget: const EmptyArea(),
        createDateTime: DateTime.now(),
        planId: uuid(),
        buttonText: '추가',
      ),
      ArgmentsTypeClass(
        pageTitle: '계획 수정',
        contentsTitleWidget: const EmptyArea(),
        createDateTime: planInfo.createDateTime,
        planId: planInfo.id,
        buttonText: '수정',
      )
    ];

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

    start() {
      final userInfoState = infoProvider.getUserInfo();
      final recordInfoState = infoProvider.getRecordInfo();
      final uuidV1 = const Uuid().v1();
      final now = DateTime.now();

      userRepository.updateUser(
        UserBox(
          userId: uuidV1,
          tall: userInfoState.tall,
          goalWeight: userInfoState.goalWeight,
          createDateTime: now,
          isAlarm: userInfoState.isAlarm,
          alarmTime: userInfoState.isAlarm ? userInfoState.alarmTime : null,
          alarmId: userInfoState.isAlarm ? newUserAlarmtUid : null,
          filterList: initFilterList,
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
          id: newUserAlarmtUid,
          alarmTime: userInfoState.alarmTime!,
          dateTime: now,
          title: weightNotifyTitle(),
          body: weightNotifyBody(),
          payload: 'weight',
        );
      }

      if (planInfo.isAlarm) {
        addPlanNotification(alarmId: newPlanAlarmUid, dateTime: now);
      }
    }

    add() {
      if (planInfo.isAlarm) {
        addPlanNotification(
          alarmId: newPlanAlarmUid,
          dateTime: importProvider.getImportDateTime(),
        );
      }
    }

    edit() async {
      final notificationIds =
          await NotificationService().pendingNotificationIds;

      if (planInfo.isAlarm) {
        bool isAlarmId = notificationIds.contains(planInfo.alarmId);

        addPlanNotification(
          alarmId: isAlarmId ? planInfo.alarmId! : newPlanAlarmUid,
          dateTime: importProvider.getImportDateTime(),
        );
      } else {
        NotificationService().deleteMultipleAlarm([
          planInfo.alarmId.toString(),
        ]);
      }
    }

    onPressedBottomNavigationButton() async {
      final data = argmentsTypeList[argmentsTypeIdx];

      bool isStart = ArgmentsTypeEnum.start == argmentsType;
      bool isEdit = ArgmentsTypeEnum.edit == argmentsType;

      if (planInfo.name != '') {
        isStart
            ? start()
            : isEdit
                ? edit()
                : add();

        planBox.put(
          data.planId,
          PlanBox(
            id: data.planId,
            type: planInfo.type.toString(),
            title: planInfo.title,
            name: planInfo.name,
            priority: planInfo.priority.toString(),
            isAlarm: planInfo.isAlarm,
            alarmTime: planInfo.isAlarm ? planInfo.alarmTime : null,
            alarmId: planInfo.isAlarm ? newPlanAlarmUid : null,
            createDateTime: data.createDateTime,
          ),
        );

        infoProvider.setInitPlanInfo();

        if (argmentsType == ArgmentsTypeEnum.start) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home-page',
            (_) => false,
          );
        } else {
          Navigator.pop(context);
        }
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

        planInfo.alarmTime ??= initDateTime();
      } else {
        infoProvider.changeIsPlanAlarm(newValue);
      }

      setState(() {});
    }

    onTapItem(type) {
      setState(() => planInfo.type = type);
    }

    planWidget(PlanTypeEnum type) {
      final item = planTypeDetailInfo[type]!;

      return Expanded(
        child: PlanItemWidget(
          id: type,
          name: item.title,
          desc: item.desc,
          icon: item.icon,
          isEnabled: type == planInfo.type,
          onTap: onTapItem,
        ),
      );
    }

    return AddContainer(
      title: argmentsTypeList[argmentsTypeIdx].pageTitle,
      body: Column(
        children: [
          argmentsTypeList[argmentsTypeIdx].contentsTitleWidget,
          ContentsBox(
            contentsWidget: Column(
              children: [
                nameTextInput(
                  name: planInfo.name,
                  onChanged: onChanged,
                ),
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '유형'),
                SpaceHeight(height: smallSpace),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      planWidget(PlanTypeEnum.diet),
                      SpaceWidth(width: smallSpace),
                      planWidget(PlanTypeEnum.exercise),
                      SpaceWidth(width: smallSpace),
                      planWidget(PlanTypeEnum.lifestyle),
                    ],
                  ),
                ),
                SpaceHeight(height: regularSapce + smallSpace),
                ContentsTitleText(text: '알림'),
                SpaceHeight(height: regularSapce),
                AlarmItemWidget(
                  id: 'alarm-setting',
                  title: '실천 알림',
                  desc: '매일 실천 알림을 보내드려요.',
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
        ],
      ),
      buttonEnabled: planInfo.name != '',
      bottomSubmitButtonText: argmentsTypeList[argmentsTypeIdx].buttonText,
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}

class PlanItemWidget extends StatelessWidget {
  PlanItemWidget({
    super.key,
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    this.width,
  });

  dynamic id;
  String name;
  String desc;
  IconData icon;
  bool isEnabled;
  Function(dynamic id) onTap;
  double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      child: ContentsBox(
        width: width,
        backgroundColor: isEnabled ? themeColor : typeBackgroundColor,
        contentsWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? buttonTextColor : primaryColor,
                    ),
                  ),
                  SpaceHeight(height: tinySpace),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isEnabled ? enabledTypeColor : disEnabledTypeColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularIcon(
                  icon: icon,
                  size: 50,
                  borderRadius: 40,
                  backgroundColor: dialogBackgroundColor,
                  onTap: (_) => onTap(id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class nameTextInput extends StatefulWidget {
  nameTextInput({
    super.key,
    required this.name,
    required this.onChanged,
    this.onCounterText,
  });

  String name;
  Function()? onCounterText;
  Function(String str) onChanged;

  @override
  State<nameTextInput> createState() => _nameTextInputState();
}

class _nameTextInputState extends State<nameTextInput> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentsTitleText(text: '이름'),
        SpaceHeight(height: smallSpace),
        TextInput(
          controller: nameController,
          autofocus: true,
          maxLength: 30,
          prefixIcon: Icons.edit,
          suffixText: '',
          hintText: '이름을 입력해주세요.',
          counterText: null,
          helperText:
              widget.onCounterText != null ? widget.onCounterText!() : '',
          onChanged: widget.onChanged,
          errorText: null,
          keyboardType: TextInputType.text,
        )
      ],
    );
  }
}

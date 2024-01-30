// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_body_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/alarm_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/todo_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class AddAlarmPermission extends StatefulWidget {
  const AddAlarmPermission({super.key});

  @override
  State<AddAlarmPermission> createState() => _AddAlarmPermissionState();
}

class _AddAlarmPermissionState extends State<AddAlarmPermission> {
  bool isWeightAlarm = false;
  DateTime weightDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // ImportDateTimeProvider importProvider =
    //     context.read<ImportDateTimeProvider>();
    // TitleDateTimeProvider titleDateTimeProvider =
    //     context.read<TitleDateTimeProvider>();
    // DietInfoProvider readProvider = context.read<DietInfoProvider>();
    DietInfoProvider dietInfo = context.watch<DietInfoProvider>();

    // onTimeSetting() async {
    //   bool? isResult = await NotificationService().requestPermission();

    //   if (isResult == true) {
    //     int newId = UniqueKey().hashCode;

    //     showAlarmBottomSheet(
    //       context: context,
    //       initialDateTime: dietInfo.getAlarmTime() ?? DateTime.now(),
    //       onDateTimeChanged: (DateTime dateTime) {
    //         readProvider.changeAlarmTime(dateTime);
    //       },
    //       onSubmit: () async {
    //         readProvider.changeIsAlarm(true);
    //         readProvider.changeAlarmTime(dietInfo.getAlarmTime());
    //         readProvider.changeAlarmId(dietInfo.getAlarmId() ?? newId);

    //         setState(() => displayAlarmTime = dietInfo.getAlarmTime());

    //         print('${dietInfo.getAlarmTime()}');

    //         NotificationService().addNotification(
    //           id: dietInfo.getAlarmId() ?? newId,
    //           dateTime: DateTime.now(),
    //           alarmTime: dietInfo.getAlarmTime() ?? DateTime.now(),
    //           title: weightNotifyTitle(),
    //           body: weightNotifyBody(),
    //           payload: 'weight',
    //         );

    //         closeDialog(context);
    //       },
    //     );
    //   } else {
    //     showDialog(
    //       context: context,
    //       builder: (context) => const PermissionPopup(),
    //     );
    //   }
    // }

    onCompleted() async {
      DateTime now = DateTime.now();
      RecordInfoClass recordInfo = dietInfo.getRecordInfo();
      List<String> planItemList = dietInfo.planItemList;
      int alarmId = UniqueKey().hashCode;

      userRepository.updateUser(
        UserBox(
          userId: dietInfo.getUserInfo().userId,
          tall: dietInfo.getUserInfo().tall,
          goalWeight: dietInfo.getUserInfo().goalWeight,
          createDateTime: now,
          isAlarm: isWeightAlarm,
          alarmTime: isWeightAlarm ? weightDateTime : null,
          alarmId: isWeightAlarm ? alarmId : null,
          filterList: initOpenList,
          displayList: initDisplayList,
        ),
      );

      if (isWeightAlarm) {
        await NotificationService().addNotification(
          id: alarmId,
          dateTime: now,
          alarmTime: weightDateTime,
          title: weightNotifyTitle(),
          body: weightNotifyBody(),
          payload: 'weight',
        );
      }

      await recordRepository.recordBox.put(
        getDateTimeToInt(now),
        RecordBox(
          createDateTime: now,
          weightDateTime: now,
          weight: recordInfo.weight,
        ),
      );

      planItemList.forEach(
        (name) {
          String id = uuid().toString();
          PlanItemClass planItem = initPlanItemList.firstWhere(
            (initItem) => initItem.name == name,
          );

          planRepository.planBox.put(
            id,
            PlanBox(
              id: id,
              type: planItem.type,
              title: '',
              priority: '',
              name: planItem.name,
              isAlarm: false,
              createDateTime: now,
            ),
          );
        },
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-page',
        (_) => false,
      );
    }

    onDateTimeChanged(DateTime dateTime) {
      setState(() => weightDateTime = dateTime);
    }

    onSwitchChanged(bool isEnabled) async {
      if (isEnabled) {
        bool? isResult = await NotificationService().requestPermission();

        if (isResult == false) {
          await showDialog(
            context: context,
            builder: (context) => const PermissionPopup(),
          );
        }

        setState(() => isWeightAlarm = isResult == true);
      } else {
        setState(() => isWeightAlarm = false);
      }
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitle(
            step: 3,
            title: '꾸준한 체중 기록을 위해 알림을 받아 보는 건 어떠세요?',
          ),
          ContentsBox(
            contentsWidget: Column(
              children: [
                AlarmRow(
                  icon: Icons.alarm_rounded,
                  iconBackgroundColor: dialogBackgroundColor,
                  title: '체중 기록 알림',
                  desc: '매일 체중 기록 알림을 드려요',
                  isEnabled: isWeightAlarm,
                  onChanged: onSwitchChanged,
                ),
                isWeightAlarm
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: DefaultTimePicker(
                          initialDateTime: weightDateTime,
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: onDateTimeChanged,
                        ),
                      )
                    : const EmptyArea()
              ],
            ),
          )
          // CommonText(
          //   text: '정해진 시간에 체중을 기록하는 습관을 만들어드려요 :)',
          //   size: 13,
          //   color: themeColor,
          // ),

          // InkWell(
          //   onTap: onTimeSetting,
          //   child: ContentsBox(
          //     width: 200,
          //     isBoxShadow: true,
          //     contentsWidget: CommonText(
          //       text: dietInfo.getUserInfo().isAlarm
          //           ? timeToString(displayAlarmTime ?? DateTime.now())
          //           : '알림 시간 설정하기',
          //       size: 15,
          //       isCenter: true,
          //       isBold: true,
          //     ),
          //   ),
          // ),
          // SpaceHeight(height: 10),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onCompleted,
    );
  }
}

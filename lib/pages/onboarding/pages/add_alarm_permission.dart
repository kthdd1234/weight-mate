// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/onboarding/add_container.dart';
import 'package:flutter_app_weight_management/etc/add_body_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/alarm_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/todo_container.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_start_screen.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    DietInfoProvider dietInfo = context.watch<DietInfoProvider>();

    onCompleted() async {
      DateTime now = DateTime.now();
      List<String> planItemList = dietInfo.planItemList;
      UserInfoClass user = dietInfo.getUserInfo();
      String userId = UniqueKey().hashCode.toString();
      int alarmId = UniqueKey().hashCode;

      userRepository.updateUser(
        UserBox(
          userId: userId,
          tall: user.tall,
          goalWeight: user.goalWeight,
          createDateTime: now,
          isAlarm: isWeightAlarm,
          alarmTime: isWeightAlarm ? weightDateTime : null,
          alarmId: isWeightAlarm ? alarmId : null,
          filterList: initOpenList,
          displayList: initDisplayList,
          weightUnit: user.weightUnit,
          tallUnit: user.tallUnit,
          language: context.locale.toString(),
        ),
      );

      if (isWeightAlarm) {
        await NotificationService().addNotification(
          id: alarmId,
          dateTime: now,
          alarmTime: weightDateTime,
          title: weightNotifyTitle().tr(),
          body: weightNotifyBody().tr(),
          payload: 'weight',
        );
      }

      await recordRepository.recordBox.put(
        getDateTimeToInt(now),
        RecordBox(
          weight: user.weight,
          createDateTime: now,
          weightDateTime: now,
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
              name: planItem.name.tr(),
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
        bool isResult = await NotificationService().permissionNotification;

        if (isResult == false) {
          await showDialog(
            context: context,
            builder: (context) => const PermissionPopup(),
          );
        }

        setState(() => isWeightAlarm = isResult);
      } else {
        setState(() => isWeightAlarm = false);
      }
    }

    return AddContainer(
      body: Column(
        children: [
          PageTitle(
            step: 4,
            title: '꾸준한 체중 기록을 위해 알림을 받아 보는 건 어떠세요?',
          ),
          ContentsBox(
            contentsWidget: Column(
              children: [
                AlarmRow(
                  icon: Icons.alarm_rounded,
                  iconBackgroundColor: whiteBgBtnColor,
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
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onCompleted,
    );
  }
}

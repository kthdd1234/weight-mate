// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_body_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/todo_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAlarmPermission extends StatefulWidget {
  const AddAlarmPermission({super.key});

  @override
  State<AddAlarmPermission> createState() => _AddAlarmPermissionState();
}

class _AddAlarmPermissionState extends State<AddAlarmPermission> {
  DateTime? displayAlarmTime;

  @override
  Widget build(BuildContext context) {
    ImportDateTimeProvider importProvider =
        context.read<ImportDateTimeProvider>();
    TitleDateTimeProvider titleDateTimeProvider =
        context.read<TitleDateTimeProvider>();
    DietInfoProvider readProvider = context.read<DietInfoProvider>();
    DietInfoProvider dietInfo = context.watch<DietInfoProvider>();

    onTimeSetting() async {
      bool? isResult = await NotificationService().requestPermission();

      if (isResult == true) {
        int newId = UniqueKey().hashCode;

        showAlarmBottomSheet(
          context: context,
          initialDateTime: dietInfo.getAlarmTime() ?? DateTime.now(),
          onDateTimeChanged: (DateTime dateTime) {
            readProvider.changeAlarmTime(dateTime);
          },
          onSubmit: () async {
            readProvider.changeIsAlarm(true);
            readProvider.changeAlarmTime(dietInfo.getAlarmTime());
            readProvider.changeAlarmId(dietInfo.getAlarmId() ?? newId);

            setState(() => displayAlarmTime = dietInfo.getAlarmTime());

            print('${dietInfo.getAlarmTime()}');

            NotificationService().addNotification(
              id: dietInfo.getAlarmId() ?? newId,
              dateTime: DateTime.now(),
              alarmTime: dietInfo.getAlarmTime() ?? DateTime.now(),
              title: weightNotifyTitle(),
              body: weightNotifyBody(),
              payload: 'weight',
            );

            closeDialog(context);
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const PermissionPopup(),
        );
      }
    }

    onCompleted() {
      DateTime now = DateTime.now();
      RecordInfoClass recordInfo = dietInfo.getRecordInfo();
      List<String> planItemList = dietInfo.planItemList;

      userRepository.updateUser(
        UserBox(
          userId: dietInfo.getUserInfo().userId,
          tall: dietInfo.getUserInfo().tall,
          goalWeight: dietInfo.getUserInfo().goalWeight,
          createDateTime: now,
          isAlarm: dietInfo.getUserInfo().isAlarm,
          alarmTime: dietInfo.getUserInfo().alarmTime,
          alarmId: dietInfo.getUserInfo().alarmId,
          filterList: initOpenList,
          displayList: initDisplayList,
        ),
      );

      recordRepository.recordBox.put(
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

          PlanItemClass planItem =
              initPlanItemList.firstWhere((initItem) => initItem.name == name);

          planRepository.planBox.put(
            id,
            PlanBox(
              id: id,
              type: planItem.type,
              title: '',
              priority: '',
              name: planItem.name,
              isAlarm: false,
              createDateTime: DateTime.now(),
            ),
          );
        },
      );

      titleDateTimeProvider.setTitleDateTime(now);
      importProvider.setImportDateTime(now);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-page',
        (_) => false,
      );
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitle(
            step: 3,
            title: '꾸준한 체중 기록을 위해\n알림을 받아 보는 건 어떠세요?',
          ),
          CommonText(
            text: '정해진 시간에 체중을 기록하는 습관을\n만들어드려요:)',
            size: 13,
            color: themeColor,
          ),
          SpaceHeight(height: 200),
          InkWell(
            onTap: onTimeSetting,
            child: ContentsBox(
              width: 200,
              isBoxShadow: true,
              contentsWidget: CommonText(
                text: dietInfo.getUserInfo().isAlarm
                    ? timeToString(displayAlarmTime ?? DateTime.now())
                    : '알림 시간 설정하기',
                size: 15,
                isCenter: true,
                isBold: true,
              ),
            ),
          ),
          SpaceHeight(height: 10),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onCompleted,
    );
  }
}

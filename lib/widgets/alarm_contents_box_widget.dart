import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmContentsBoxWidget extends StatefulWidget {
  AlarmContentsBoxWidget(
      {super.key,
      required this.boxType,
      required this.alarmId,
      required this.title,
      required this.desc,
      required this.isAlarm,
      required this.alarmTime,
      this.userBox,
      this.planBox,
      this.name});

  String boxType;
  String title, desc;
  bool isAlarm;
  int? alarmId;
  DateTime? alarmTime;
  UserBox? userBox;
  PlanBox? planBox;
  String? name;

  @override
  State<AlarmContentsBoxWidget> createState() => _AlarmContentsBoxWidgetState();
}

class _AlarmContentsBoxWidgetState extends State<AlarmContentsBoxWidget> {
  late DateTime timeValue;

  @override
  void initState() {
    timeValue = widget.alarmTime ?? initAlarmDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox? userBox = widget.userBox ?? widget.userBox;
    PlanBox? planBox = widget.planBox ?? widget.planBox;

    addWeightNotification(DateTime? time) {
      NotificationService().addNotification(
        id: widget.alarmId ?? UniqueKey().hashCode,
        alarmTime: time ?? initAlarmDateTime,
        title: '체중 기록 알림',
        body: '오늘의 체중을 입력 할 시간이에요.',
      );
    }

    addPlanNotification(DateTime? time) {
      NotificationService().addNotification(
        id: widget.alarmId ?? UniqueKey().hashCode,
        alarmTime: time ?? initAlarmDateTime,
        title: '계획 실천 알림',
        body: '${widget.name} 실천해보세요.',
      );
    }

    onSubmit() {
      if (widget.boxType == 'weight') {
        userBox?.alarmTime = timeValue;
        userBox?.save();

        addWeightNotification(timeValue);
      } else if (widget.boxType == 'plan') {
        planBox?.alarmTime = timeValue;
        planBox?.save();

        addPlanNotification(timeValue);
      }

      closeDialog(context);
    }

    onDateTimeChanged(DateTime dateTime) {
      setState(() => timeValue = dateTime);
    }

    onTap(dynamic id) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: '알림 시간 설정',
          height: 380,
          contents: DefaultTimePicker(
            initialDateTime: timeValue,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: onDateTimeChanged,
          ),
          isEnabled: true,
          submitText: '완료',
          onSubmit: onSubmit,
        ),
      );
    }

    setWeightNotification(bool newValue) {
      if (newValue) {
        userBox?.alarmTime = widget.alarmTime ?? initAlarmDateTime;
        addWeightNotification(timeValue);
      } else {
        NotificationService().deleteMultipleAlarm([
          widget.alarmId.toString(),
        ]);
      }

      userBox?.isAlarm = newValue;
      userBox?.save();
    }

    setPlanNotification(bool newValue) {
      if (newValue) {
        planBox?.alarmTime = widget.alarmTime ?? initAlarmDateTime;
        addPlanNotification(timeValue);
      } else {
        NotificationService().deleteMultipleAlarm([
          widget.alarmId.toString(),
        ]);
      }

      planBox?.isAlarm = newValue;
      planBox?.save();
    }

    onChanged(bool newValue) async {
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

      if (widget.boxType == 'weight') {
        setWeightNotification(newValue);
      } else if (widget.boxType == 'plan') {
        setPlanNotification(newValue);
      }
    }

    return Column(
      children: [
        ContentsBox(
          backgroundColor: dialogBackgroundColor,
          contentsWidget: AlarmItemWidget(
            id: widget.alarmId.toString(),
            title: widget.title,
            desc: widget.desc,
            alarmTime: widget.alarmTime,
            isEnabled: widget.isAlarm,
            onChanged: onChanged,
            onTap: onTap,
            iconBackgroundColor: typeBackgroundColor,
            chipBackgroundColor: typeBackgroundColor,
          ),
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}

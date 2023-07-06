import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmContentsBoxWidget extends StatefulWidget {
  AlarmContentsBoxWidget({
    super.key,
    required this.dateTime,
    required this.alarmId,
    required this.title,
    required this.desc,
    required this.isAlarm,
    required this.alarmTime,
    this.userBox,
    this.name,
  });

  String title, desc;
  bool isAlarm;
  DateTime dateTime;
  int? alarmId;
  DateTime? alarmTime;
  UserBox? userBox;
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

    addWeightNotification(DateTime? time) {
      NotificationService().addNotification(
        id: widget.alarmId ?? UniqueKey().hashCode,
        alarmTime: time ?? initAlarmDateTime,
        dateTime: widget.dateTime,
        title: weightNotifyTitle(),
        body: weightNotifyBody(),
        payload: 'weight',
      );
    }

    onSubmit() {
      userBox?.alarmTime = timeValue;
      userBox?.save();

      addWeightNotification(timeValue);
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

      setWeightNotification(newValue);
    }

    return Column(
      children: [
        ContentsBox(
          contentsWidget: AlarmItemWidget(
            id: widget.alarmId.toString(),
            title: widget.title,
            desc: widget.desc,
            alarmTime: widget.alarmTime,
            isEnabled: widget.isAlarm,
            onChanged: onChanged,
            onTap: onTap,
            iconBackgroundColor: dialogBackgroundColor,
            chipBackgroundColor: dialogBackgroundColor,
          ),
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonAlarmPage extends StatefulWidget {
  const CommonAlarmPage({super.key});

  @override
  State<CommonAlarmPage> createState() => _CommonAlarmPageState();
}

class _CommonAlarmPageState extends State<CommonAlarmPage> {
  late Box<UserBox> userBox;
  late DateTime timeValue;

  UserBox? userProfile;

  @override
  void initState() {
    userBox = Hive.box<UserBox>('userBox');
    userProfile = userBox.get('userProfile')!;
    timeValue = userProfile?.alarmTime ?? initDateTime();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addWeightNotification(DateTime? time, int alarmId) {
      NotificationService().addNotification(
        id: alarmId,
        dateTime: DateTime.now(),
        alarmTime: timeValue,
        title: weightNotifyTitle(),
        body: weightNotifyBody(),
        payload: 'weight',
      );
    }

    setWeightNotification(bool newValue) {
      if (newValue) {
        int newAlarmId = UniqueKey().hashCode;

        userProfile!.isAlarm = true;
        userProfile!.alarmTime = timeValue;
        userProfile!.alarmId = newAlarmId;

        addWeightNotification(timeValue, newAlarmId);
      } else {
        if (userProfile!.alarmId != null) {
          NotificationService().deleteAlarm(userProfile!.alarmId!);
        }

        userProfile!.isAlarm = false;
        userProfile!.alarmId = null;
        userProfile!.alarmTime = null;
      }

      userProfile!.save();
    }

    onSubmit() {
      setWeightNotification(true);
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

    onChanged(bool newValue) async {
      if (newValue) {
        bool isPermission = await NotificationService().permissionNotification;

        isPermission
            ? setWeightNotification(newValue)
            : showSnackBar(
                context: context,
                width: 270,
                text: '알림 권한이 없어요.',
                buttonName: '설정창으로 이동',
                onPressed: openAppSettings,
              );
      } else {
        setWeightNotification(newValue);
      }
    }

    return MultiValueListenableBuilder(
      valueListenables: [userBox.listenable()],
      builder: (context, boxs, widget) {
        return AddContainer(
          title: '알림 설정',
          body: Column(
            children: [
              ContentsTitleText(text: '기록 알림'),
              SpaceHeight(height: smallSpace),
              ContentsBox(
                contentsWidget: AlarmItemWidget(
                  id: userProfile!.alarmId.toString(),
                  title: '체중 기록',
                  desc: '매일 정해진 시간에 알림을 드려요.',
                  alarmTime: userProfile!.alarmTime,
                  isEnabled: userProfile!.isAlarm,
                  onChanged: onChanged,
                  onTap: onTap,
                  iconBackgroundColor: dialogBackgroundColor,
                  chipBackgroundColor: dialogBackgroundColor,
                ),
              ),
              SpaceHeight(height: smallSpace),
            ],
          ),
          buttonEnabled: true,
          bottomSubmitButtonText: '',
        );
      },
    );
  }
}

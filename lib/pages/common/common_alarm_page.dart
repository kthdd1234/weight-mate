import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/alarm_contents_box_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class CommonAlarmPage extends StatefulWidget {
  const CommonAlarmPage({super.key});

  @override
  State<CommonAlarmPage> createState() => _CommonAlarmPageState();
}

class _CommonAlarmPageState extends State<CommonAlarmPage> {
  late Box<UserBox> userBox;

  @override
  void initState() {
    userBox = Hive.box<UserBox>('userBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox? userProfile = userBox.get('userProfile');

    return MultiValueListenableBuilder(
      valueListenables: [userBox.listenable()],
      builder: (context, boxs, widget) {
        return AddContainer(
          title: '알림 설정',
          body: Column(
            children: [
              ContentsTitleText(text: '기록 알림'),
              SpaceHeight(height: smallSpace),
              AlarmContentsBoxWidget(
                dateTime: DateTime.now(),
                alarmId: userProfile?.alarmId,
                title: '체중 기록',
                desc: '매일 정해진 시간에 알림을 드려요.',
                isAlarm: userProfile!.isAlarm,
                alarmTime: userProfile.alarmTime,
                userBox: userProfile,
              ),
            ],
          ),
          buttonEnabled: true,
          bottomSubmitButtonText: '',
        );
      },
    );
  }
}

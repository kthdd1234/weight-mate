import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/custom_alarm_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';

class CommonAlarmPage extends StatelessWidget {
  const CommonAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    onDateTimeChanged(DateTime dateTime) {}

    onChangedSwitch(bool isChecked) {}

    onTapButton() {}

    onTapAlarm(String id) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: '알림 시간 설정',
          height: 380,
          widgets: [
            DefaultTimePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: onDateTimeChanged,
            )
          ],
          isEnabled: true,
          submitText: '완료',
          onSubmit: onTapButton,
        ),
      );
    }

    onPressedBottomNavigationButton() {}

    alarmContentsBox({
      required String id,
      required String title,
      required String desc,
      required DateTime alarmTime,
      required bool isEnabled,
    }) {
      return ContentsBox(
        backgroundColor: dialogBackgroundColor,
        contentsWidget: AlarmItemWidget(
          id: id,
          title: title,
          desc: desc,
          alarmTime: alarmTime,
          isEnabled: isEnabled,
          onChanged: onChangedSwitch,
          onTap: onTapAlarm,
          iconBackgroundColor: typeBackgroundColor,
          chipBackgroundColor: typeBackgroundColor,
        ),
      );
    }

    return AddContainer(
      title: '알림 설정',
      body: Column(
        children: [
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(text: '기록 알림'),
                SpaceHeight(height: smallSpace),
                alarmContentsBox(
                  id: 'test-1',
                  title: '체중 기록',
                  desc: '기록 누락 방지용 알림',
                  alarmTime: DateTime.now(),
                  isEnabled: true,
                ),
              ],
            ),
          ),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(text: '실천 알림'),
                SpaceHeight(height: regularSapce),
                alarmContentsBox(
                  id: 'test-2',
                  title: '간헐적 단식 16:8',
                  desc: '식이요법',
                  alarmTime: DateTime.now(),
                  isEnabled: true,
                ),
                SpaceHeight(height: smallSpace),
                alarmContentsBox(
                  id: 'test-3',
                  title: '저녁에 샐러드 먹기',
                  desc: '식이요법',
                  alarmTime: DateTime.now(),
                  isEnabled: true,
                ),
              ],
            ),
          ),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}

  // SpaceHeight(height: regularSapce),
          // ContentsBox(
          //   contentsWidget: CustomAlarmWidget(),
          // )
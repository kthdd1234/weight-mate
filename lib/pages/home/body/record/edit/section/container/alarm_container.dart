import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';

class AlarmContainer extends StatelessWidget {
  AlarmContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.isEnabled,
    required this.alarmTime,
    required this.onChanged,
    required this.onCompleted,
    required this.onDateTimeChanged,
  });

  IconData icon;
  String title, desc;
  bool isEnabled;
  DateTime alarmTime;
  Function(bool newValue) onChanged;
  Function(DateTime dateTime) onDateTimeChanged;
  Function() onCompleted;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: Colors.white,
      contentsWidget: Column(
        children: [
          AlarmRow(
            icon: icon,
            title: title,
            iconBackgroundColor: dialogBackgroundColor,
            desc: desc,
            isEnabled: isEnabled,
            onChanged: onChanged,
          ),
          isEnabled
              ? Column(
                  children: [
                    DefaultTimePicker(
                      initialDateTime: alarmTime,
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: onDateTimeChanged,
                    ),
                    Row(
                      children: [
                        CommonButton(
                          text: '완료',
                          fontSize: 13,
                          bgColor: themeColor,
                          radious: 10,
                          textColor: Colors.white,
                          onTap: onCompleted,
                          isBold: true,
                        ),
                      ],
                    )
                  ],
                )
              : const EmptyArea()
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

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
    this.nameArgs,
  });

  IconData icon;
  String title, desc;
  bool isEnabled;
  DateTime alarmTime;
  Map<String, String>? nameArgs;
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
            nameArgs: nameArgs,
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

class AlarmItemWidget extends StatelessWidget {
  AlarmItemWidget({
    super.key,
    required this.id,
    required this.isEnabled,
    required this.title,
    required this.desc,
    this.alarmTime,
    required this.onChanged,
    required this.onTap,
    required this.iconBackgroundColor,
    required this.chipBackgroundColor,
    this.icon,
  });
  dynamic id;
  String title, desc;
  bool isEnabled;
  DateTime? alarmTime;
  Color iconBackgroundColor, chipBackgroundColor;
  IconData? icon;
  Function(bool newValue) onChanged;
  Function(dynamic id) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AlarmRow(
          icon: icon,
          iconBackgroundColor: iconBackgroundColor,
          title: title,
          desc: desc,
          isEnabled: isEnabled,
          onChanged: onChanged,
        ),
        isEnabled
            ? TimeChipWidget(
                id: id,
                time: alarmTime ?? initDateTime(),
                backgroundColor: chipBackgroundColor,
                onTap: onTap,
              )
            : const EmptyArea()
      ],
    );
  }
}

class AlarmRow extends StatelessWidget {
  AlarmRow({
    super.key,
    this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.desc,
    required this.isEnabled,
    required this.onChanged,
    this.nameArgs,
  });

  IconData? icon;
  Color iconBackgroundColor;
  String title;
  String desc;
  bool isEnabled;
  Map<String, String>? nameArgs;
  Function(bool newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            icon != null
                ? Row(
                    children: [
                      CircularIcon(
                        size: 40,
                        borderRadius: 10,
                        icon: icon,
                        backgroundColor: iconBackgroundColor,
                      ),
                      SpaceWidth(width: 15),
                    ],
                  )
                : const EmptyArea(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(text: title, size: 15, nameArgs: nameArgs),
                SpaceHeight(height: 2),
                CommonText(text: desc, size: 12, color: Colors.grey)
              ],
            ),
          ],
        ),
        CupertinoSwitch(
          activeColor: themeColor,
          value: isEnabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class TimeChipWidget extends StatelessWidget {
  TimeChipWidget(
      {super.key,
      required this.id,
      required this.onTap,
      required this.time,
      required this.backgroundColor});

  String id;
  DateTime time;
  Function(String id) onTap;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            SpaceHeight(height: smallSpace),
            InkWell(
              onTap: () => onTap(id),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    timeToString(time),
                    style: const TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/date_time_tap_widget.dart';

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
  const AlarmRow({
    super.key,
    this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.desc,
    required this.isEnabled,
    required this.onChanged,
  });

  final IconData? icon;
  final Color iconBackgroundColor;
  final String title;
  final String desc;
  final bool isEnabled;
  final Function(bool newValue) onChanged;

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
                CommonText(text: title, size: 15),
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

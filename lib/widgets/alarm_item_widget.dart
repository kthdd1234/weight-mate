import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
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
    required this.icon,
  });

  String id, title, desc;
  bool isEnabled;
  DateTime? alarmTime;
  Color iconBackgroundColor, chipBackgroundColor;
  IconData icon;
  Function(bool newValue) onChanged;
  Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircularIcon(
                  size: 40,
                  borderRadius: 10,
                  icon: icon,
                  backgroundColor: iconBackgroundColor,
                ),
                SpaceWidth(width: regularSapce),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15)),
                    SpaceHeight(height: tinySpace),
                    BodySmallText(text: desc),
                  ],
                ),
              ],
            ),
            CupertinoSwitch(
              activeColor: buttonBackgroundColor,
              value: isEnabled,
              onChanged: onChanged,
            ),
          ],
        ),
        isEnabled && alarmTime != null
            ? TimeChipWidget(
                id: id,
                time: alarmTime!,
                backgroundColor: chipBackgroundColor,
                onTap: onTap,
              )
            : const EmptyArea()
      ],
    );
  }
}

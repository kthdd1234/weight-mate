import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class ActAlarm extends StatelessWidget {
  ActAlarm({
    super.key,
    required this.isEnabledAlarm,
    required this.actType,
    required this.onChanged,
  });

  bool isEnabledAlarm;
  ActTypeEnum actType;
  Function(bool newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircularIcon(
              widthAndHeight: 40,
              borderRadius: 10,
              icon: Icons.notifications_active,
              backgroundColor: dialogBackgroundColor,
            ),
            SpaceWidth(width: regularSapce),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${actTitles[actType]} 실천 알림',
                  style: const TextStyle(fontSize: 15),
                ),
                SpaceHeight(height: tinySpace),
                BodySmallText(text: '설정한 시간에 실천 알림을 보내드려요.')
              ],
            ),
          ],
        ),
        CupertinoSwitch(
          activeColor: buttonBackgroundColor,
          value: isEnabledAlarm,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

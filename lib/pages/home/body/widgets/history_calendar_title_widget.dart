import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistoryCalendarTitleWidget extends StatelessWidget {
  const HistoryCalendarTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsTitleText(
      text: '기록한 날',
      icon: Icons.calendar_month,
      sub: [
        //  ColorTextInfo(
        //   width: smallSpace,
        //   height: smallSpace,
        //   text: '체중',
        //   color: weightColor,
        // ),
        // SpaceWidth(width: 7.5),
        // ColorTextInfo(
        //   width: smallSpace,
        //   height: smallSpace,
        //   text: '계획',
        //   color: planDotColor,
        // ),
        // SpaceWidth(width: 7.5),
        // ColorTextInfo(
        //   width: smallSpace,
        //   height: smallSpace,
        //   text: '메모',
        //   color: memoDotColor,
        // ),
      ],
    );
  }
}

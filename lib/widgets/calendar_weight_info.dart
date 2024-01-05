import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/calendar_contents_box.dart';

class CalendarWeightInfo extends StatelessWidget {
  CalendarWeightInfo({
    super.key,
    required this.weight,
    required this.weightDateTime,
  });

  String weight;
  String weightDateTime;

  @override
  Widget build(BuildContext context) {
    setRowWidgets(List<Widget> children) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      );
    }

    return CalendarContentsBox(color: weightColor, rowWidgetList: [
      setRowWidgets([
        ContentsTitleText(text: '체중 기록'),
        Dot(size: 10, color: weightColor),
      ]),
      SpaceHeight(height: smallSpace),
      setRowWidgets([
        Text('$weight kg', style: const TextStyle(fontSize: 16)),
        BodySmallText(text: '$weightDateTime 기록 완료'),
      ]),
    ]);
  }
}

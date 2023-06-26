import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/calendar_contents_box.dart';
import 'package:hive/hive.dart';
import '../components/area/empty_area.dart';

class CalendarActionInfo extends StatelessWidget {
  CalendarActionInfo({
    super.key,
    required this.planBox,
    required this.actions,
  });

  Box<PlanBox> planBox;
  List<Map<String, dynamic>> actions;

  @override
  Widget build(BuildContext context) {
    setRowWidgets(List<Widget> children, double hegiht) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
          SpaceHeight(height: hegiht),
        ],
      );
    }

    final actionListView = ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final planId = actions[index]['id'];
        final planInfo = planBox.get(planId);

        return setRowWidgets(
          [Text(planInfo!.name), const Icon(Icons.task_alt, size: 20)],
          smallSpace,
        );
      },
    );

    return CalendarContentsBox(
      color: actionColor,
      rowWidgetList: [
        setRowWidgets(
          [
            ContentsTitleText(text: '계획 실천'),
            ColorDot(width: 10, height: 10, color: actionColor),
          ],
          smallSpace,
        ),
        actionListView,
        SpaceHeight(height: smallSpace),
        setRowWidgets(
          [
            const EmptyArea(),
            BodySmallText(text: '총 실천 ${actions.length}회'),
          ],
          0,
        ),
      ],
    );
  }
}

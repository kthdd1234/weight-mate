import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';

class CustomAlarmWidget extends StatefulWidget {
  const CustomAlarmWidget({super.key});

  @override
  State<CustomAlarmWidget> createState() => _CustomAlarmWidgetState();
}

class _CustomAlarmWidgetState extends State<CustomAlarmWidget> {
  @override
  Widget build(BuildContext context) {
    onTapSwitch(MoreSeeItem moreSeeItem, bool value) {}

    List<MoreSeeItemClass> customAlarmClassList = [];

    List<MoreSeeItemWidget> customAlarmWidgetList = customAlarmClassList
        .map((item) => MoreSeeItemWidget(
              index: item.index,
              id: item.id,
              icon: item.icon,
              title: item.title,
              value: item.value,
              widgetType: item.widgetType,
            ))
        .toList();

    setAlarmWidgetList() {
      if (customAlarmWidgetList.isEmpty) {
        return EmptyTextVerticalArea(
          icon: Icons.notification_important,
          title: '맞춤 알림이 없어요.',
        );
      }

      return ContentsBox(
        width: MediaQuery.of(context).size.width,
        backgroundColor: dialogBackgroundColor,
        contentsWidget: Column(
          children: customAlarmWidgetList,
        ),
      );
    }

    onTapAddAlarm() {}

    return Column(
      children: [
        ContentsTitleText(
          text: '맞춤 알림',
          icon: Icons.notifications_active,
        ),
        SpaceHeight(height: regularSapce),
        setAlarmWidgetList(),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}
//  MoreSeeItemClass(
//       id: MoreSeeItem.mySetting,
//       index: 0,
//       icon: Icons.more_time,
//       title: '나만의 맞춤 알림',
//       value: false,
//       widgetType: MoreSeeWidgetTypes.switching,
//       onTapSwitch: onTapSwitch,
//     ),

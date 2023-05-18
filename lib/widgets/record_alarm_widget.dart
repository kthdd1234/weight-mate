import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';

class RecordAlarmWidget extends StatefulWidget {
  const RecordAlarmWidget({super.key});

  @override
  State<RecordAlarmWidget> createState() => _RecordAlarmWidgetState();
}

class _RecordAlarmWidgetState extends State<RecordAlarmWidget> {
  bool isTodayWeightAlarm = false;
  bool isTodayActionAlarm = false;
  bool isTodayDietWiseSayingAlarm = false;

  @override
  Widget build(BuildContext context) {
    onTapSwitch(MoreSeeItem moreSeeItem, bool value) {
      setState(() {
        if (moreSeeItem == MoreSeeItem.setWeight) {
          isTodayWeightAlarm = value;
        } else if (moreSeeItem == MoreSeeItem.checkPlan) {
          isTodayActionAlarm = value;
        } else if (moreSeeItem == MoreSeeItem.dietWiseSaying) {
          isTodayDietWiseSayingAlarm = value;
        }
      });
    }

    onTapDateTime(id, dateTimeStr) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => DefaultDateTimePicker(),
      );
    }

    List<MoreSeeItemClass> moreSeeAlarmItems = [
      MoreSeeItemClass(
        id: MoreSeeItem.setWeight,
        index: 0,
        icon: Icons.edit_notifications_outlined,
        title: '오늘의 체중 입력 알림',
        value: isTodayWeightAlarm,
        widgetType: MoreSeeWidgetTypes.switching,
        bottomWidget: isTodayWeightAlarm ? 'dateTime' : null,
        dateTimeStr: isTodayWeightAlarm ? '오전 8:00' : null,
        onTapSwitch: onTapSwitch,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.checkPlan,
        index: 1,
        icon: Icons.alarm_on_outlined,
        title: '오늘의 실천 체크 알림',
        value: isTodayActionAlarm,
        widgetType: MoreSeeWidgetTypes.switching,
        bottomWidget: isTodayActionAlarm ? 'dateTime' : null,
        dateTimeStr: isTodayActionAlarm ? '오후 10:00' : null,
        onTapSwitch: onTapSwitch,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.dietWiseSaying,
        index: 2,
        icon: Icons.tips_and_updates_outlined,
        title: '오늘의 다이어트 명언 알림',
        value: isTodayDietWiseSayingAlarm,
        widgetType: MoreSeeWidgetTypes.switching,
        bottomWidget: isTodayDietWiseSayingAlarm ? 'dateTime' : null,
        dateTimeStr: isTodayDietWiseSayingAlarm ? '오전 10:00' : null,
        onTapSwitch: onTapSwitch,
      ),
    ];

    List<MoreSeeItemWidget> moreSeeAlarmWidgets = moreSeeAlarmItems
        .map((item) => MoreSeeItemWidget(
              index: item.index,
              id: item.id,
              icon: item.icon,
              title: item.title,
              value: item.value,
              widgetType: item.widgetType,
              dateTimeStr: item.dateTimeStr,
              bottomWidget: item.bottomWidget,
              onTapSwitch: item.onTapSwitch,
              onTapDateTime: onTapDateTime,
            ))
        .toList();

    return Column(
      children: [
        ContentsTitleText(
          text: '기본 알림',
          icon: Icons.notifications_none_outlined,
        ),
        SpaceHeight(height: regularSapce),
        ContentsBox(
          width: MediaQuery.of(context).size.width,
          backgroundColor: dialogBackgroundColor,
          contentsWidget: Column(children: moreSeeAlarmWidgets),
        ),
      ],
    );
  }
}

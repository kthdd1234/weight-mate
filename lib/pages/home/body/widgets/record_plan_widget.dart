import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_item_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_check_item.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_group_item.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class RecordPlanWidget extends StatefulWidget {
  RecordPlanWidget({
    super.key,
    required this.seletedRecordIconType,
  });

  RecordIconTypes seletedRecordIconType;

  @override
  State<RecordPlanWidget> createState() => _RecordPlanWidgetState();
}

class _RecordPlanWidgetState extends State<RecordPlanWidget> {
  SegmentedTypes selectedSegment = SegmentedTypes.groupList;

  @override
  Widget build(BuildContext context) {
    List<RecordIconClass> recordIconClassList = [
      RecordIconClass(
        enumId: RecordIconTypes.addPlan,
        icon: Icons.add,
      ),
      RecordIconClass(
        enumId: RecordIconTypes.alarmPlan,
        icon: Icons.notifications,
      ),
      RecordIconClass(
        enumId: RecordIconTypes.removePlan,
        icon: Icons.delete,
      ),
    ];

    onSubmitAlarm() {}

    onTapIcon(enumId) {
      switch (enumId) {
        case RecordIconTypes.addPlan:
          Navigator.pushNamed(context, '/add-act-type',
              arguments: screenPointEnum.record);
          break;

        case RecordIconTypes.alarmPlan:
          Navigator.pushNamed(context, '/common-alarm');
          break;

        case RecordIconTypes.removePlan:
          // todo
          break;
        default:
      }
    }

    List<Widget> subWidgets = recordIconClassList
        .map(
          (element) => RecordContentsTitleIcon(
            id: element.enumId,
            icon: element.icon,
            onTap: onTapIcon,
          ),
        )
        .toList();

    onSegmentedChanged(SegmentedTypes? type) {
      setState(() => selectedSegment = type!);
    }

    segmentedWidget({required String text, required IconData icon}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          '$text 4',
          style: const TextStyle(fontSize: 12, color: buttonBackgroundColor),
        ),
      );
    }

    Map<SegmentedTypes, Widget> segmentedTypes = {
      SegmentedTypes.groupList: segmentedWidget(
        text: '그룹 목록',
        icon: Icons.format_list_bulleted_outlined,
      ),
      SegmentedTypes.myPlan: segmentedWidget(
        text: '나의 계획',
        icon: Icons.abc,
      ),
      SegmentedTypes.planAct: segmentedWidget(
        text: '실천 체크',
        icon: Icons.check_outlined,
      )
    };

    onTapPlanItem(String id) {
      print(id);
    }

    onTapCheckItem(String id) {
      print(id);
    }

    setSegmentedWidget() {
      final segmentedInfo = {
        SegmentedTypes.groupList: Column(
          children: [
            PlanGroupItem(
              icon: Icons.self_improvement,
              title: '식이요법',
              planList: ['1', '2', '3'],
            )
          ],
        ),
        SegmentedTypes.myPlan: Column(
          children: [
            Column(
              children: [
                PlanItemInfo(
                  id: 'plan-1',
                  groupName: '식이요법',
                  icon: Icons.self_improvement,
                  itemName: '간헐적 단식 16:8',
                  startDateTime: DateTime.now(),
                  endDateTime: DateTime.now(),
                  isAct: false,
                  onTap: onTapPlanItem,
                ),
                PlanItemInfo(
                  id: 'plan-2',
                  groupName: '운동',
                  icon: Icons.pool,
                  itemName: '수영 강습 받기',
                  startDateTime: DateTime.now(),
                  endDateTime: DateTime.now(),
                  isAct: true,
                  onTap: onTapPlanItem,
                ),
              ],
            )
          ],
        ),
        SegmentedTypes.planAct: Column(
          children: [
            PlanCheckItem(
              id: 'item-1',
              icon: Icons.alarm,
              groupName: '생활습관',
              itemName: '아침에 체중 기록하기',
              isChecked: true,
              onTap: onTapCheckItem,
            ),
            PlanCheckItem(
              id: 'item-2',
              icon: Icons.no_food,
              groupName: '식이요법',
              itemName: '간헐적 단식 16:8',
              isChecked: true,
              onTap: onTapCheckItem,
            ),
            PlanCheckItem(
              id: 'item-3',
              icon: Icons.pool,
              groupName: '운동',
              itemName: '수영 강습 받기',
              isChecked: false,
              onTap: onTapCheckItem,
            ),
          ],
        ),
      };

      return segmentedInfo[selectedSegment]!;
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '오늘의 계획',
            icon: Icons.task_alt,
            sub: subWidgets,
          ),
          SpaceHeight(height: regularSapce),
          DefaultSegmented(
            selectedSegment: selectedSegment,
            children: segmentedTypes,
            onSegmentedChanged: onSegmentedChanged,
          ),
          SpaceHeight(height: smallSpace),
          setSegmentedWidget()
        ],
      ),
    );
  }
}

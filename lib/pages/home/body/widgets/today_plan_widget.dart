import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_remove_contents.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_check.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_types.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_items.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class TodayPlanWidget extends StatefulWidget {
  TodayPlanWidget({
    super.key,
    required this.seletedRecordIconType,
    required this.importDateTime,
  });

  RecordIconTypes seletedRecordIconType;
  DateTime importDateTime;

  @override
  State<TodayPlanWidget> createState() => _TodayPlanWidgetState();
}

class _TodayPlanWidgetState extends State<TodayPlanWidget> {
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;

  SegmentedTypes selectedSegment = SegmentedTypes.planTypes;

  @override
  void initState() {
    recordBox = Hive.box<RecordBox>('recordBox');
    planBox = Hive.box<PlanBox>('planBox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recordBoxList = recordBox.values.toList();
    final planInfoList = planBox.values
        .map((item) => PlanInfoClass(
              type: planTypeEnumToString(item.type),
              title: item.title,
              id: item.id,
              name: item.name,
              startDateTime: item.startDateTime,
              endDateTime: item.endDateTime,
              isAlarm: item.isAlarm,
              alarmTime: item.alarmTime,
              alarmId: item.alarmId,
            ))
        .toList();

    final recordInfo = recordBox.get(getDateTimeToInt(widget.importDateTime));

    navigateToPage() {
      Navigator.pushNamed(
        context,
        '/add-plan-type',
        arguments: ArgmentsTypeEnum.add,
      );
    }

    onTapIcon(enumId) {
      switch (enumId) {
        case RecordIconTypes.addPlan:
          navigateToPage();
          break;

        case RecordIconTypes.alarmPlan:
          if (planInfoList.isEmpty) {
            return showSnackBar(
              context: context,
              text: '알림을 드릴 계획이 없어요.',
              buttonName: '확인',
            );
          }

          Navigator.pushNamed(context, '/common-alarm');
          break;

        case RecordIconTypes.removePlan:
          if (planInfoList.isEmpty) {
            return showSnackBar(
                context: context, text: '삭제할 계획이 없어요.', buttonName: '확인');
          }

          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return PlanRemoveContents(
                  recordBox: recordBox,
                  planBox: planBox,
                  recordBoxList: recordBoxList,
                  planInfoList: planInfoList,
                );
              });
          break;
        default:
      }
    }

    onSegmentedChanged(SegmentedTypes? type) {
      setState(() => selectedSegment = type!);
    }

    segmentedItem({
      required SegmentedTypes type,
      required String text,
      required IconData icon,
    }) {
      int count = 0;

      switch (type) {
        case SegmentedTypes.planTypes:
          Set<PlanTypeEnum> set = {};

          for (var element in planInfoList) {
            set.add(element.type);
          }

          count = set.length;
          break;

        case SegmentedTypes.planItems:
          count = planInfoList.length;
          break;

        case SegmentedTypes.planCheck:
          if (recordInfo?.actions != null) count = recordInfo!.actions.length;
          break;
        default:
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          '$text $count',
          style: const TextStyle(fontSize: 12, color: buttonBackgroundColor),
        ),
      );
    }

    setSegmenteItem() {
      Map<SegmentedTypes, StatelessWidget> segmentedInfo = {
        SegmentedTypes.planTypes: TodayPlanTypes(
          actions: recordInfo?.actions,
          planInfoList: planInfoList,
        ),
        SegmentedTypes.planItems: TodayPlanItems(
          planInfoList: planInfoList,
        ),
        SegmentedTypes.planCheck: TodayPlanCheck(
          recordBox: recordBox,
          recordInfo: recordInfo,
          importDateTime: widget.importDateTime,
          planInfoList: planInfoList,
        ),
      };

      return segmentedInfo[selectedSegment]!;
    }

    Map<SegmentedTypes, Widget> segmentedTypes = {
      SegmentedTypes.planTypes: segmentedItem(
        type: SegmentedTypes.planTypes,
        text: '그룹 목록',
        icon: Icons.format_list_bulleted_outlined,
      ),
      SegmentedTypes.planItems: segmentedItem(
        type: SegmentedTypes.planItems,
        text: '나의 계획',
        icon: Icons.abc,
      ),
      SegmentedTypes.planCheck: segmentedItem(
        type: SegmentedTypes.planCheck,
        text: '실천 체크',
        icon: Icons.check_outlined,
      )
    };

    List<Widget> iconWidgets = recordIconClassList
        .map(
          (element) => RecordContentsTitleIcon(
            id: element.enumId,
            icon: element.icon,
            onTap: onTapIcon,
          ),
        )
        .toList();

    setBodyWidgets() {
      return planInfoList.isEmpty
          ? Column(
              children: [
                SpaceHeight(height: smallSpace + 5),
                EmptyTextArea(
                  text: '오늘의 계획을 추가해보세요.',
                  icon: Icons.add,
                  topHeight: 30,
                  downHeight: 30,
                  onTap: navigateToPage,
                ),
              ],
            )
          : Column(
              children: [
                SpaceHeight(height: smallSpace + 5),
                DefaultSegmented(
                  selectedSegment: selectedSegment,
                  children: segmentedTypes,
                  onSegmentedChanged: onSegmentedChanged,
                ),
                SpaceHeight(height: smallSpace),
                setSegmenteItem(),
              ],
            );
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '오늘의 계획',
            icon: Icons.task_alt,
            sub: iconWidgets,
          ),
          setBodyWidgets(),
        ],
      ),
    );
  }
}

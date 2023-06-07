import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/remove_plan_contents_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_check.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_types.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_items.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

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
    final recordInfo = Hive.box<RecordBox>('recordBox')
        .get(getDateTimeToInt(widget.importDateTime));
    final actions = recordInfo?.actions;
    final planInfoList = Hive.box<PlanBox>('planBox')
        .values
        .map((item) => PlanInfoClass(
              type: planTypeEnumToString(item.type),
              title: item.title,
              id: item.id,
              name: item.name,
              startDateTime: item.startDateTime,
              endDateTime: item.endDateTime,
              isAlarm: item.isAlarm,
              alarmTime: item.alarmTime,
            ))
        .toList();

    onTapIcon(enumId) {
      switch (enumId) {
        case RecordIconTypes.addPlan:
          Navigator.pushNamed(
            context,
            '/add-plan-type',
            arguments: argmentsTypeEnum.record,
          );
          break;

        case RecordIconTypes.alarmPlan:
          Navigator.pushNamed(context, '/common-alarm');
          break;

        case RecordIconTypes.removePlan:
          setRemoveSubmit() {
            //
          }

          setRemoveBtnEnabled() {
            return false;
          }

          setRemoveSubmitText() {
            return '삭제';
          }

          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return DefaultBottomSheet(
                  title: '계획 삭제',
                  height: 380,
                  widgets: const [Scrollbar(child: RemovePlanContentsBox())],
                  isEnabled: false,
                  submitText: setRemoveSubmitText(),
                  onSubmit: setRemoveSubmit,
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
          if (actions != null) count = actions!.length;
          break;
        default:
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          '$text $count',
          style: const TextStyle(fontSize: 12, color: buttonBackgroundColor),
        ),
      );
    }

    setSegmentedWidget() {
      Map<SegmentedTypes, StatelessWidget> segmentedInfo = {
        SegmentedTypes.planTypes:
            TodayPlanTypes(actions: actions, planInfoList: planInfoList),
        SegmentedTypes.planItems: TodayPlanItems(planInfoList: planInfoList),
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
        text: '전체 계획',
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

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '오늘의 계획',
            icon: Icons.task_alt,
            sub: iconWidgets,
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

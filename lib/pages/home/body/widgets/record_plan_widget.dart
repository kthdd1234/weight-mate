import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diet_plan_action_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diet_plan_delete_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diet_plan_list_widget.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  SegmentedTypes selectedSegment = SegmentedTypes.planList;

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

    onTapIcon(enumId) {
      //
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

    onTapTextArea() {
      //
    }

    type_1() {
      return Row(
        children: [
          // SfRadialGauge(
          //   title: GaugeTitle(
          //     text: 'Speedometer',
          //     textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          //   ),
          // )
        ],
      );
    }

    onSegmentedChanged(SegmentedTypes? type) {
      setState(() => selectedSegment = type!);
    }

    segmentedWidget({required String text, required IconData icon}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: buttonBackgroundColor,
              ),
            ),
            SpaceWidth(width: tinySpace),
            Text('4'),
          ],
        ),
      );
    }

    Map<SegmentedTypes, Widget> segmentedTypes = {
      SegmentedTypes.planList: segmentedWidget(
        text: '전체 리스트',
        icon: Icons.format_list_bulleted_outlined,
      ),
      SegmentedTypes.planAct: segmentedWidget(
        text: '실천 체크',
        icon: Icons.check_outlined,
      )
    };

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
          ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Row(
              children: [type_1()],
            ),
          ),
        ],
      ),
    );
  }
}

//  CircularIcon(
//             size: 40,
//             borderRadius: 10,
//             icon: Icons.alarm_on_rounded,
//             backgroundColor: typeBackgroundColor,
//           ),
//           SpaceWidth(width: regularSapce),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '잊지않고 체중 기록하기',
//                 style: TextStyle(color: buttonBackgroundColor),
//               ),
//               SpaceHeight(height: tinySpace),
//               BodySmallText(text: '2023.04.31 ~ 2023.06.31'),
//             ],
//           )

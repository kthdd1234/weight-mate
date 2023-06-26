import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/analyze_action_record.dart';
import 'package:flutter_app_weight_management/widgets/graph_chart.dart';
import 'package:flutter_app_weight_management/widgets/segmented_widget.dart';
import 'package:hive/hive.dart';

import '../../../model/plan_box/plan_box.dart';
import '../../../model/record_box/record_box.dart';
import '../../../model/user_box/user_box.dart';

class AnalyzeBody extends StatefulWidget {
  const AnalyzeBody({super.key});

  @override
  State<AnalyzeBody> createState() => _AnalyzeBodyState();
}

class _AnalyzeBodyState extends State<AnalyzeBody> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;

  SegmentedTypes selectedRecordTypeSegment = SegmentedTypes.weight;
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;

  @override
  void initState() {
    userBox = Hive.box('userBox');
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planbox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<SegmentedTypes, Widget> recordTypeChildren = {
      SegmentedTypes.weight:
          SegmentedWidget(title: '체중 변화', color: weightColor),
      SegmentedTypes.action:
          SegmentedWidget(title: '실천 기록', color: actionColor),
    };

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: SegmentedWidget(title: '일주일'),
      SegmentedTypes.month: SegmentedWidget(title: '한달'),
      SegmentedTypes.threeMonth: SegmentedWidget(title: '3개월'),
      SegmentedTypes.sixMonth: SegmentedWidget(title: '6개월'),
      SegmentedTypes.custom: SegmentedWidget(title: '커스텀'),
    };

    onSegmentedRecordTypeChanged(SegmentedTypes? segmented) {
      setState(() {
        selectedRecordTypeSegment = segmented!;
        selectedDateTimeSegment = SegmentedTypes.week;
      });
    }

    setInfoText() {
      if (selectedDateTimeSegment == SegmentedTypes.custom) {
        return const EmptyArea();
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.swipe, size: 15, color: Colors.grey),
              SpaceWidth(width: tinySpace),
              BodySmallText(text: '좌우로 움직여 날짜를 변경 해보세요.'),
            ],
          ),
          SpaceHeight(height: smallSpace),
        ],
      );
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      setState(() => selectedDateTimeSegment = segmented!);
    }

    setAnalyzeContents() {
      if (selectedRecordTypeSegment == SegmentedTypes.weight) {
        return Column(
          children: [
            GraphChart(
              recordBox: recordBox,
              userBox: userBox,
              selectedDateTimeSegment: selectedDateTimeSegment,
            ),
            setInfoText(),
            DefaultSegmented(
              selectedSegment: selectedDateTimeSegment,
              children: dateTimeChildren,
              backgroundColor: typeBackgroundColor,
              thumbColor: dialogBackgroundColor,
              onSegmentedChanged: onSegmentedDateTimeChanged,
            ),
          ],
        );
      }

      return AnalyzeActionRecord(recordBox: recordBox, planBox: planBox);
    }

    return Column(
      children: [
        DefaultSegmented(
          selectedSegment: selectedRecordTypeSegment,
          children: recordTypeChildren,
          backgroundColor: typeBackgroundColor,
          thumbColor: dialogBackgroundColor,
          onSegmentedChanged: onSegmentedRecordTypeChanged,
        ),
        setAnalyzeContents(),
      ],
    );
  }
}

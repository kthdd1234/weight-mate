import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/graph_chart.dart';
import 'package:flutter_app_weight_management/widgets/segmented_widget.dart';

class AnalyzeBody extends StatefulWidget {
  const AnalyzeBody({super.key});

  @override
  State<AnalyzeBody> createState() => _AnalyzeBodyState();
}

class _AnalyzeBodyState extends State<AnalyzeBody> {
  SegmentedTypes selectedRecordTypeSegment = SegmentedTypes.weight;
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;

  @override
  Widget build(BuildContext context) {
    Map<SegmentedTypes, Widget> recordTypeChildren = {
      SegmentedTypes.weight:
          SegmentedWidget(title: '체중 변화 (kg)', color: weightColor),
      SegmentedTypes.action:
          SegmentedWidget(title: ' 실천 횟수 (회)', color: actionColor),
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
          SpaceHeight(height: smallSpace + tinySpace),
        ],
      );
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      setState(() => selectedDateTimeSegment = segmented!);
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
        GraphChart(
          selectedDateTimeSegment: selectedDateTimeSegment,
          selectedRecordTypeSegment: selectedRecordTypeSegment,
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
}

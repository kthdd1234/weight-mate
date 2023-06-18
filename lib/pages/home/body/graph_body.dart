import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/graph_chart.dart';

class GraphBody extends StatefulWidget {
  const GraphBody({super.key});

  @override
  State<GraphBody> createState() => _GraphBodyState();
}

class _GraphBodyState extends State<GraphBody> {
  SegmentedTypes selectedRecordTypeSegment = SegmentedTypes.weight;
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    segmentedWidget({
      required String title,
      Color? color,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          color != null
              ? ColorDot(width: 7.5, height: 7.5, color: color)
              : const EmptyArea(),
          color != null ? SpaceWidth(width: tinySpace) : const EmptyArea(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: buttonBackgroundColor,
            ),
          ),
        ],
      );
    }

    Map<SegmentedTypes, Widget> recordTypeChildren = {
      SegmentedTypes.weight:
          segmentedWidget(title: '체중 변화', color: weightColor),
      SegmentedTypes.action:
          segmentedWidget(title: ' 실천 횟수', color: actionColor),
    };

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: segmentedWidget(title: '일주일'),
      SegmentedTypes.month: segmentedWidget(title: '한달'),
      SegmentedTypes.threeMonth: segmentedWidget(title: '3개월'),
      SegmentedTypes.sixMonth: segmentedWidget(title: '6개월'),
      SegmentedTypes.custom: segmentedWidget(title: '커스텀'),
    };

    onSegmentedRecordTypeChanged(SegmentedTypes? segmented) {
      setState(() => selectedRecordTypeSegment = segmented!);
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      setState(() => selectedDateTimeSegment = segmented!);
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

    return Column(
      children: [
        DefaultSegmented(
          selectedSegment: selectedRecordTypeSegment,
          children: recordTypeChildren,
          backgroundColor: typeBackgroundColor,
          thumbColor: dialogBackgroundColor,
          onSegmentedChanged: onSegmentedRecordTypeChanged,
        ),
        SpaceHeight(height: smallSpace),
        GraphChart(
          selectedRecordTypeSegment: selectedRecordTypeSegment,
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
}
// const AnalyzeWeightInfoWidget(),
// SpaceHeight(height: regularSapce),
// const AnalyzePlanInfoWidget(),
// SpaceHeight(height: regularSapce),
// ContentsBox(
//     contentsWidget: Column(
//   children: [
//     ContentsTitleText(text: '실천 순위'),
//     SpaceHeight(height: regularSapce),
//     AnalyzePlanDataWidget(),
//   ],
// )),
// SpaceHeight(height: regularSapce),
// const AnalyzeDietStatusWidget(),
// SpaceHeight(height: regularSapce),

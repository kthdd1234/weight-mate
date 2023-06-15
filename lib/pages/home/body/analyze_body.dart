import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/analyze_weight_chart_widget.dart';

class AnalyzeBody extends StatefulWidget {
  const AnalyzeBody({super.key});

  @override
  State<AnalyzeBody> createState() => _AnalyzeBodyState();
}

class _AnalyzeBodyState extends State<AnalyzeBody> {
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
          segmentedWidget(title: ' 계획 실천', color: actionColor),
    };

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: segmentedWidget(title: '일주일'),
      SegmentedTypes.month: segmentedWidget(title: '한달'),
      SegmentedTypes.threeMonth: segmentedWidget(title: '3개월'),
      SegmentedTypes.sixMonth: segmentedWidget(title: '6개월'),
      SegmentedTypes.oneYear: segmentedWidget(title: '1년'),
    };

    onSegmentedRecordTypeChanged(SegmentedTypes? segmented) {
      setState(() => selectedRecordTypeSegment = segmented!);
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
        SpaceHeight(height: smallSpace),
        AnalyzeWeightChartWidget(
          selectedRecordTypeSegment: selectedRecordTypeSegment,
        ),
        SpaceHeight(height: smallSpace),
        DefaultSegmented(
          selectedSegment: selectedDateTimeSegment,
          children: dateTimeChildren,
          backgroundColor: dialogBackgroundColor,
          thumbColor: dialogBackgroundColor,
          onSegmentedChanged: onSegmentedDateTimeChanged,
        ),
        SpaceHeight(height: regularSapce),
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
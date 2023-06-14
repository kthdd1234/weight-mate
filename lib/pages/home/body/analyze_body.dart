import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_plan_info_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_diet_status_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_weight_info_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/analyze_plan_data_widget.dart';
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
  Widget build(BuildContext context) {
    segmentedWidget({required String title, required double horizontal}) {
      return Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: buttonBackgroundColor,
        ),
      );
    }

    Map<SegmentedTypes, Widget> recordTypeChildren = {
      SegmentedTypes.weight: segmentedWidget(title: '체중 변화', horizontal: 50),
      SegmentedTypes.action: segmentedWidget(title: ' 계획 실천', horizontal: 50),
    };

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: segmentedWidget(title: '일주일', horizontal: 10),
      SegmentedTypes.month: segmentedWidget(title: '한달', horizontal: 10),
      SegmentedTypes.threeMonth: segmentedWidget(title: '3개월', horizontal: 10),
      SegmentedTypes.sixMonth: segmentedWidget(title: '6개월', horizontal: 10),
      SegmentedTypes.custom: segmentedWidget(title: '커스텀', horizontal: 10),
    };

    onSegmentedRecordTypeChanged(SegmentedTypes? segmented) {
      setState(() => selectedRecordTypeSegment = segmented!);
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      setState(() => selectedDateTimeSegment = segmented!);
    }

    return SingleChildScrollView(
      child: Column(
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
            selectedBodyInfoSegment: selectedRecordTypeSegment,
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
      ),
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
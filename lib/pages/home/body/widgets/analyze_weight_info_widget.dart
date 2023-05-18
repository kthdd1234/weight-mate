import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_weight_title_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/analyze_weight_data_widget.dart';
import 'package:flutter_app_weight_management/widgets/analyze_weight_datetime_widget.dart';
import 'package:flutter_app_weight_management/widgets/analyze_weight_chart_widget.dart';

class AnalyzeWeightInfoWidget extends StatefulWidget {
  const AnalyzeWeightInfoWidget({super.key});

  @override
  State<AnalyzeWeightInfoWidget> createState() =>
      _AnalyzeWeightInfoWidgetState();
}

class _AnalyzeWeightInfoWidgetState extends State<AnalyzeWeightInfoWidget> {
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;
  SegmentedTypes selectedBodyInfoSegment = SegmentedTypes.weight;

  @override
  Widget build(BuildContext context) {
    segmentedWidget({required String title, required double horizontal}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: buttonBackgroundColor,
          ),
        ),
      );
    }

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: segmentedWidget(title: '일주일', horizontal: 10),
      SegmentedTypes.month: segmentedWidget(title: '한달', horizontal: 10),
      SegmentedTypes.threeMonth: segmentedWidget(title: '3개월', horizontal: 10),
      SegmentedTypes.sixMonth: segmentedWidget(title: '6개월', horizontal: 10),
      SegmentedTypes.custom: segmentedWidget(title: '커스텀', horizontal: 10),
    };

    Map<SegmentedTypes, Widget> bodyInfoChildren = {
      SegmentedTypes.weight: segmentedWidget(title: '체중', horizontal: 60),
      SegmentedTypes.bodyFat: segmentedWidget(title: '체지방', horizontal: 60),
    };

    onSegmentedBodyInfoChanged(SegmentedTypes? segmented) {
      setState(() => selectedBodyInfoSegment = segmented!);
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      setState(() => selectedDateTimeSegment = segmented!);
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          const AnalyzeWeightTitleWidget(),
          SpaceHeight(height: regularSapce),
          DefaultSegmented(
            selectedSegment: selectedBodyInfoSegment,
            children: bodyInfoChildren,
            onSegmentedChanged: onSegmentedBodyInfoChanged,
          ),
          SpaceHeight(height: smallSpace),
          DefaultSegmented(
            selectedSegment: selectedDateTimeSegment,
            children: dateTimeChildren,
            onSegmentedChanged: onSegmentedDateTimeChanged,
          ),
          SpaceHeight(height: smallSpace),
          AnalyzeWeightChartWidget(
            selectedBodyInfoSegment: selectedBodyInfoSegment,
          ),
          // SpaceHeight(height: smallSpace),
          // WidthDivider(
          //   width: MediaQuery.of(context).size.width - 90,
          //   color: Colors.grey[300],
          // ),
          // SpaceHeight(height: smallSpace),
          // AnalyzeWeightDataWidget()
        ],
      ),
    );
  }
}

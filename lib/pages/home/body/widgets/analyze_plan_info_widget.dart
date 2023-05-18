import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/%08segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/chart/default_chart.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/analyze_plan_chart_widget.dart';
import 'package:flutter_app_weight_management/widgets/analyze_plan_data_widget.dart';

class AnalyzePlanInfoWidget extends StatefulWidget {
  const AnalyzePlanInfoWidget({super.key});

  @override
  State<AnalyzePlanInfoWidget> createState() => _AnalyzePlanInfoWidgetState();
}

class _AnalyzePlanInfoWidgetState extends State<AnalyzePlanInfoWidget> {
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;

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

  onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
    setState(() => selectedDateTimeSegment = segmented!);
  }

  @override
  Widget build(BuildContext context) {
    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: segmentedWidget(title: '일주일', horizontal: 20),
      SegmentedTypes.month: segmentedWidget(title: '한달', horizontal: 20),
      SegmentedTypes.threeMonth: segmentedWidget(title: '3개월', horizontal: 20),
      SegmentedTypes.sixMonth: segmentedWidget(title: '6개월', horizontal: 20),
    };

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '실천 그래프',
            sub: [
              IconText(
                icon: Icons.bar_chart,
                iconColor: Colors.purple,
                iconSize: 17,
                text: '실천율(%)',
                textColor: disEnabledTypeColor,
                textSize: 13,
              )
            ],
          ),
          SpaceHeight(height: regularSapce),
          DefaultSegmented(
            selectedSegment: selectedDateTimeSegment,
            children: dateTimeChildren,
            onSegmentedChanged: onSegmentedDateTimeChanged,
          ),
          SpaceHeight(height: smallSpace),
          AnalyzePlanChartWidget(),
          // SpaceHeight(height: smallSpace),
          // WidthDivider(
          //   width: MediaQuery.of(context).size.width - 90,
          //   color: Colors.grey[300],
          // ),
          // SpaceHeight(height: smallSpace),
          // AnalyzePlanDataWidget()
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/graph_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_title_datetime.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_weight_view.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_steps_view.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class GraphChart extends StatelessWidget {
  GraphChart({
    super.key,
    required this.graphCategory,
    required this.graphType,
    required this.selectedDateTimeSegment,
    required this.startDateTime,
    required this.endDateTime,
    required this.setChartSwipeDirectionStart,
    required this.setChartSwipeDirectionEnd,
  });

  String graphType, graphCategory;
  SegmentedTypes selectedDateTimeSegment;
  DateTime startDateTime, endDateTime;
  Function() setChartSwipeDirectionStart, setChartSwipeDirectionEnd;

  int get range {
    if (graphType == eGraphCustom) {
      int days = daysBetween(
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );

      return days;
    }

    return countInfo[selectedDateTimeSegment]!;
  }

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    bool isWeek = selectedDateTimeSegment == SegmentedTypes.week ||
        selectedDateTimeSegment == SegmentedTypes.twoWeek;
    bool isVisible = isWeek && (graphType == eGraphDefault);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GraphTitleDateTime(
              startDateTime: startDateTime,
              endDateTime: endDateTime,
            ),
            Expanded(
              child: graphCategory == cGraphWeight
                  ? GraphWeightView(
                      graphType: graphType,
                      isWeek: isWeek,
                      isVisible: isVisible,
                      range: range,
                      selectedDateTimeSegment: selectedDateTimeSegment,
                      startDateTime: startDateTime,
                      endDateTime: endDateTime,
                      setChartSwipeDirectionStart: setChartSwipeDirectionStart,
                      setChartSwipeDirectionEnd: setChartSwipeDirectionEnd,
                    )
                  : GraphStepsView(
                      locale: locale,
                      graphType: graphType,
                      isVisible: isVisible,
                      isWeek: isWeek,
                      range: range,
                      selectedDateTimeSegment: selectedDateTimeSegment,
                      startDateTime: startDateTime,
                      endDateTime: endDateTime,
                      setChartSwipeDirectionStart: setChartSwipeDirectionStart,
                      setChartSwipeDirectionEnd: setChartSwipeDirectionEnd,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

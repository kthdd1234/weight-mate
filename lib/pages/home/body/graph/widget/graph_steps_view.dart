// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/popup/LoadingPopup.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/services/health_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
// import 'package:health/health.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphStepsView extends StatefulWidget {
  GraphStepsView({
    super.key,
    required this.locale,
    required this.graphType,
    required this.selectedDateTimeSegment,
    required this.startDateTime,
    required this.endDateTime,
    required this.isVisible,
    required this.isWeek,
    required this.range,
    required this.setChartSwipeDirectionStart,
    required this.setChartSwipeDirectionEnd,
  });

  String locale, graphType;
  bool isVisible, isWeek;
  int range;
  SegmentedTypes selectedDateTimeSegment;
  DateTime startDateTime, endDateTime;
  Function() setChartSwipeDirectionStart, setChartSwipeDirectionEnd;

  @override
  State<GraphStepsView> createState() => _GraphStepsViewState();
}

class _GraphStepsViewState extends State<GraphStepsView> {
  UserBox user = userRepository.user;
  double? stepsMaximum, stepsMinimum;
  List<GraphData> dataSource = [];

  // getSteps() async {
  //   dataSource = [];

  //   HealthService health = HealthService();
  //   bool isPermission = await health.isPermission;
  //   DateTime startDateTime = DateTime(
  //     widget.startDateTime.year,
  //     widget.startDateTime.month,
  //     widget.startDateTime.day,
  //     0,
  //     0,
  //   );
  //   DateTime endDateTime = DateTime(
  //     widget.endDateTime.year,
  //     widget.endDateTime.month,
  //     widget.endDateTime.day,
  //     23,
  //     59,
  //   );

  //   if (isPermission == false) {
  //     await health.requestAuthorization();
  //   }

  //   List<HealthDataPoint> healthSteps = await health.getHealthSteps(
  //     ctx: context,
  //     startDateTime: startDateTime,
  //     endDateTime: endDateTime,
  //   );
  //   List<GraphData> graphDataList = [];
  //   List<double> stepList = [];

  //   for (var i = 0; i < widget.range; i++) {
  //     DateTime subtractDateTime = jumpDayDateTime(
  //       type: jumpDayTypeEnum.subtract,
  //       dateTime: endDateTime,
  //       days: i,
  //     );
  //     String x = getGraphX(
  //       locale: widget.locale,
  //       isWeek: widget.isWeek,
  //       graphType: widget.graphType,
  //       dateTime: subtractDateTime,
  //     );
  //     double y = 0;
  //     healthSteps.forEach((data) {
  //       bool isEqual =
  //           getDateTimeToInt(data.dateTo) == getDateTimeToInt(subtractDateTime);

  //       if (isEqual) {
  //         Map<String, dynamic> json = data.value.toJson();
  //         double steps = json['numeric_value'];

  //         y += steps;
  //       }
  //     });

  //     graphDataList.add(GraphData(x, y));
  //     stepList.add(y);
  //   }

  //   dataSource = graphDataList.reversed.toList();
  //   stepsMaximum =
  //       stepList.isEmpty ? 100.0 : (stepList.reduce(max) + 100).floorToDouble();
  //   stepsMinimum =
  //       stepList.isEmpty ? 0.0 : stepList.reduce(min).floorToDouble();

  //   setState(() {});
  // }

  @override
  void initState() {
    // getSteps();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GraphStepsView oldWidget) {
    // getSteps();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    onPlotAreaSwipe(ChartSwipeDirection direction) {
      setState(() {
        switch (direction) {
          case ChartSwipeDirection.start:
            widget.setChartSwipeDirectionStart();

            break;
          case ChartSwipeDirection.end:
            widget.setChartSwipeDirectionEnd();

            break;
          default:
        }
      });
    }

    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        header: '',
        enable: true,
        format: 'point.x: point.y',
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        maximum: stepsMaximum ?? 100,
        minimum: stepsMinimum ?? 0,
      ),
      series: [
        FastLineSeries(
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
          dataSource: dataSource,
          color: blue.s300,
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          markerSettings: MarkerSettings(isVisible: widget.isVisible),
          dataLabelSettings: DataLabelSettings(
            isVisible: widget.isVisible,
            useSeriesColor: true,
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      onPlotAreaSwipe: onPlotAreaSwipe,
    );
  }
}

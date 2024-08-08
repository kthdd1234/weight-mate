import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphWeightView extends StatefulWidget {
  GraphWeightView({
    super.key,
    required this.graphType,
    required this.isWeek,
    required this.isVisible,
    required this.range,
    required this.selectedDateTimeSegment,
    required this.startDateTime,
    required this.endDateTime,
    required this.setChartSwipeDirectionStart,
    required this.setChartSwipeDirectionEnd,
  });

  String graphType;
  bool isWeek, isVisible;
  int range;
  SegmentedTypes selectedDateTimeSegment;
  DateTime startDateTime, endDateTime;
  Function() setChartSwipeDirectionStart, setChartSwipeDirectionEnd;

  @override
  State<GraphWeightView> createState() => _GraphWeightViewState();
}

class _GraphWeightViewState extends State<GraphWeightView> {
  double? weightMinimum, weightMaximum;
  List<RecordBox?> recordInfoList = [];

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String locale = context.locale.toString();
    List<PlotBand> plotBandList = <PlotBand>[
      PlotBand(
        borderWidth: 1.0,
        borderColor: disabledButtonTextColor,
        isVisible: true,
        text: '목표 체중: '.tr(
          namedArgs: {
            "weight": '${user.goalWeight}',
            'unit': '${user.weightUnit}'
          },
        ),
        textStyle: const TextStyle(color: disabledButtonTextColor),
        start: user.goalWeight,
        end: user.goalWeight,
        dashArray: const <double>[4, 5],
      )
    ];

    getRecordInfo(DateTime datatime) {
      int recordKey = getDateTimeToInt(datatime);
      return recordRepository.recordBox.get(recordKey);
    }

    onSeriesDateTime({required DateTime endPoint}) {
      List<GraphData> seriesData = [];
      List<double> weightList = [];

      for (var i = 0; i <= widget.range; i++) {
        DateTime subtractDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.subtract,
          dateTime: endPoint,
          days: i,
        );
        RecordBox? recordInfo = getRecordInfo(subtractDateTime);
        String x = getGraphX(
          locale: locale,
          isWeek: widget.isWeek,
          graphType: widget.graphType,
          dateTime: subtractDateTime,
        );
        double? y = recordInfo?.weight;
        GraphData chartData = GraphData(x, y);

        if (recordInfo?.weight != null) {
          weightList.add(recordInfo!.weight!);
        }

        seriesData.add(chartData);
      }

      return [seriesData, weightList];
    }

    fastLineSeries() {
      final seriesData = onSeriesDateTime(endPoint: widget.endDateTime);
      final fastLineSeriesData = seriesData[0] as List<GraphData>;
      final weightList = seriesData[1] as List<double>;

      setState(() {
        if (weightList.isEmpty) {
          weightMinimum = 0.0;
          weightMaximum = 100.0;
        } else {
          weightMinimum = (weightList.reduce(min) - 1).floorToDouble();
          weightMaximum = (weightList.reduce(max) + 1).floorToDouble();
        }
      });

      return fastLineSeriesData.reversed.toList();
    }

    setFastLineSeries() {
      return FastLineSeries(
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: fastLineSeries(),
        color: indigo.s300,
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
      );
    }

    fastLineSeries();

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
        format: 'point.x: point.y${user.weightUnit}',
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: weightMinimum,
        maximum: weightMaximum,
        plotBands: plotBandList,
      ),
      series: [setFastLineSeries()],
      onPlotAreaSwipe: onPlotAreaSwipe,
    );
  }
}

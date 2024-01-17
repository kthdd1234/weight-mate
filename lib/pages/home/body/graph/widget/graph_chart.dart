import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/graph_body.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class GraphData {
  GraphData(this.x, this.y);

  final String x;
  final double? y;
}

class GraphChart extends StatefulWidget {
  GraphChart({
    super.key,
    required this.selectedDateTimeSegment,
    required this.recordBox,
    required this.userBox,
    required this.startDateTime,
    required this.endDateTime,
    required this.setChartSwipeDirectionStart,
    required this.setChartSwipeDirectionEnd,
  });

  SegmentedTypes selectedDateTimeSegment;
  Box<RecordBox> recordBox;
  Box<UserBox> userBox;
  DateTime startDateTime, endDateTime;
  Function() setChartSwipeDirectionStart, setChartSwipeDirectionEnd;

  @override
  State<GraphChart> createState() => _GraphChartState();
}

class _GraphChartState extends State<GraphChart> {
  double? weightMinimum, weightMaximum, actionMinimum, actionMaximum;
  List<RecordBox?> recordInfoList = [];

  @override
  Widget build(BuildContext context) {
    final userProfile = widget.userBox.get('userProfile');
    final plotBandList = <PlotBand>[
      PlotBand(
        borderWidth: 1.0,
        borderColor: disabledButtonTextColor,
        isVisible: true,
        text: '목표 체중: ${userProfile!.goalWeight}kg',
        textStyle: const TextStyle(color: disabledButtonTextColor),
        start: userProfile.goalWeight,
        end: userProfile.goalWeight,
        dashArray: const <double>[4, 5],
      )
    ];

    getRecordInfo(DateTime datatime) {
      return widget.recordBox.get(getDateTimeToInt(datatime));
    }

    List<GraphData> setLineSeriesDateTime({
      required int count,
      required String format,
    }) {
      List<GraphData> lineSeriesData = [];
      List<double> weightList = [];

      for (var i = 0; i <= count; i++) {
        DateTime subtractDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.subtract,
          dateTime: widget.endDateTime,
          days: i,
        );
        RecordBox? recordInfo = getRecordInfo(subtractDateTime);
        String formatterDay =
            dateTimeFormatter(format: format, dateTime: subtractDateTime);
        GraphData chartData = GraphData(formatterDay, recordInfo?.weight);

        if (recordInfo?.weight != null) {
          weightList.add(recordInfo!.weight!);
        }

        lineSeriesData.add(chartData);
      }

      setState(() {
        if (weightList.isEmpty) {
          weightMinimum = 0.0;
          weightMaximum = 100.0;
        } else {
          weightMinimum = (weightList.reduce(min) - 1).floorToDouble();
          weightMaximum = (weightList.reduce(max) + 1).floorToDouble();
        }
      });

      return lineSeriesData.reversed.toList();
    }

    setCount() {
      if (widget.selectedDateTimeSegment == SegmentedTypes.custom) {
        int days = daysBetween(
          startDateTime: widget.startDateTime,
          endDateTime: widget.endDateTime,
        );

        return days;
      }

      return countInfo[widget.selectedDateTimeSegment];
    }

    List<GraphData> setLineSeriesData() {
      List<GraphData> lineSeriesData = setLineSeriesDateTime(
        count: setCount()!,
        format: widget.selectedDateTimeSegment == SegmentedTypes.week
            ? 'd일'
            : 'M.d',
      );

      return lineSeriesData;
    }

    setLineSeries() {
      return FastLineSeries(
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: setLineSeriesData(),
        color: Colors.indigo.shade200,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        markerSettings: MarkerSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
        ),
        dataLabelSettings: DataLabelSettings(
          showZeroValue: false,
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
          useSeriesColor: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    setLineSeriesData();

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

    String titleDateTime = '${dateTimeFormatter(
      dateTime: widget.startDateTime,
      format: 'M월 d일',
    )} ~ ${dateTimeFormatter(
      dateTime: widget.endDateTime,
      format: 'M월 d일',
    )}';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SfCartesianChart(
          legend: const Legend(
            position: LegendPosition.top,
            alignment: ChartAlignment.center,
          ),
          title: ChartTitle(
            text: titleDateTime,
            alignment: ChartAlignment.far,
            textStyle: const TextStyle(fontSize: 10),
          ),
          tooltipBehavior: TooltipBehavior(
            header: '',
            enable: true,
            format: 'point.x: point.ykg',
          ),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: weightMinimum,
            maximum: weightMaximum,
            plotBands: plotBandList,
          ),
          series: [setLineSeries()],
          onPlotAreaSwipe: onPlotAreaSwipe,
        ),
      ),
    );
  }
}

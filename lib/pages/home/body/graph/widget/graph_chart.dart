import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
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
  double? weightMinimum, weightMaximum;
  List<RecordBox?> recordInfoList = [];

  @override
  Widget build(BuildContext context) {
    final user = userRepository.user;
    final isShowPreviousGraph = user.isShowPreviousGraph ?? false;
    final plotBandList = <PlotBand>[
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
    String locale = context.locale.toString();

    getRecordInfo(DateTime datatime) {
      return widget.recordBox.get(getDateTimeToInt(datatime));
    }

    lange() {
      if (widget.selectedDateTimeSegment == SegmentedTypes.custom) {
        int days = daysBetween(
          startDateTime: widget.startDateTime,
          endDateTime: widget.endDateTime,
        );

        return days;
      }

      return countInfo[widget.selectedDateTimeSegment]!;
    }

    onSeriesDateTime({required DateTime endPoint}) {
      List<GraphData> seriesData = [];
      List<double> weightList = [];

      int count = lange();
      String format =
          widget.selectedDateTimeSegment == SegmentedTypes.week ? 'd' : 'md';

      for (var i = 0; i <= count; i++) {
        DateTime subtractDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.subtract,
          dateTime: endPoint,
          days: i,
        );
        RecordBox? recordInfo = getRecordInfo(subtractDateTime);
        String formatterDay = format == 'd'
            ? d(locale: locale, dateTime: subtractDateTime)
            : m_d(locale: locale, dateTime: subtractDateTime);
        GraphData chartData = GraphData(formatterDay, recordInfo?.weight);

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

      if (isShowPreviousGraph == true) {
        final beforeSeriesData =
            onSeriesDateTime(endPoint: widget.startDateTime);
        final beforeFastLineSeriesData = beforeSeriesData[0] as List<GraphData>;
        final beforeWeightList = beforeSeriesData[1] as List<double>;

        fastLineSeriesData.addAll(beforeFastLineSeriesData);
        weightList.addAll(beforeWeightList);
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

      return fastLineSeriesData.reversed.toList();
    }

    setFastLineSeries() {
      return FastLineSeries(
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: fastLineSeries(),
        color: Colors.indigo.shade200,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        markerSettings: MarkerSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
        ),
        dataLabelSettings: DataLabelSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
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

    onTapShowPreviousGraph() async {
      user.isShowPreviousGraph = !isShowPreviousGraph;

      await user.save();
      setState(() {});
    }

    String bDataTime = '${md(
      locale: locale,
      dateTime: jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: widget.startDateTime,
        days: lange(),
      ),
    )} ~ ${md(
      locale: locale,
      dateTime: widget.startDateTime,
    )}';

    String cDateTime = '${md(
      locale: locale,
      dateTime: widget.startDateTime,
    )} ~ ${md(
      locale: locale,
      dateTime: widget.endDateTime,
    )}';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SpaceHeight(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonTag(
                    color: isShowPreviousGraph ? 'whiteIndigo' : 'whiteGrey',
                    text: isShowPreviousGraph ? bDataTime : '이전 기간 표시하기',
                    isNotTr: isShowPreviousGraph,
                    onTap: onTapShowPreviousGraph,
                  ),
                  SpaceWidth(width: 5),
                  CommonTag(
                    color: 'whiteIndigo',
                    text: cDateTime,
                    isNotTr: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                legend: const Legend(
                  position: LegendPosition.top,
                  alignment: ChartAlignment.center,
                ),
                tooltipBehavior: TooltipBehavior(
                  header: '',
                  enable: true,
                  format: 'point.x: point.y${user.weightUnit}',
                ),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  minimum: weightMinimum,
                  maximum: weightMaximum,
                  plotBands: plotBandList,
                ),
                series: [setFastLineSeries()],
                onPlotAreaSwipe: onPlotAreaSwipe,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/pages/home/graph/graph_body.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class GraphView extends StatefulWidget {
  GraphView({
    super.key,
    required this.locale,
    required this.graphType,
    required this.selectedDateTimeSegment,
    required this.recordBox,
    required this.userBox,
    required this.startDateTime,
    required this.endDateTime,
    required this.setChartSwipeDirectionStart,
    required this.setChartSwipeDirectionEnd,
  });

  String locale, graphType;
  SegmentedTypes selectedDateTimeSegment;
  Box<RecordBox> recordBox;
  Box<UserBox> userBox;
  DateTime startDateTime, endDateTime;
  Function() setChartSwipeDirectionStart, setChartSwipeDirectionEnd;

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  UserBox user = userRepository.user;
  List<GraphData> morningSource = [];
  List<GraphData> nightSource = [];
  double? maximum, minimum;

  getRecordInfo(DateTime datatime) {
    int recordKey = getDateTimeToInt(datatime);
    return widget.recordBox.get(recordKey);
  }

  lange() {
    if (widget.graphType == eGraphCustom) {
      int days = daysBetween(
        startDateTime: widget.startDateTime,
        endDateTime: widget.endDateTime,
      );

      return days;
    }

    return countInfo[widget.selectedDateTimeSegment]!;
  }

  onSeriesDateTime({required DateTime endPoint}) {
    List<GraphData> morningData = [];
    List<GraphData> nightData = [];

    List<double> morningWeightList = [];
    List<double> nightWeightList = [];

    bool isGraphDefault = user.graphType == eGraphDefault;
    bool isGraphCustom = user.graphType == eGraphCustom;

    for (var i = 0; i <= lange(); i++) {
      DateTime subtractDateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: endPoint,
        days: i,
      );
      RecordBox? recordInfo = getRecordInfo(subtractDateTime);
      String x = getIsWeek() && isGraphDefault
          ? d(locale: widget.locale, dateTime: subtractDateTime)
          : isGraphCustom
              ? yyyyUnderMd(locale: widget.locale, dateTime: subtractDateTime)
              : m_d(locale: widget.locale, dateTime: subtractDateTime);

      double? morningY = recordInfo?.weight;
      double? nightY = recordInfo?.weightNight;

      GraphData morningGraphData = GraphData(x, morningY);
      GraphData nightGraphData = GraphData(x, nightY);

      if (recordInfo?.weight != null) {
        morningWeightList.add(recordInfo!.weight!);
      } else if (recordInfo?.weightNight != null) {
        nightWeightList.add(recordInfo!.weightNight!);
      }

      morningData.add(morningGraphData);
      nightData.add(nightGraphData);
    }

    return [
      [morningData, morningWeightList],
      [nightData, nightWeightList]
    ];
  }

  fastLineDataSource() {
    final seriesDataList = onSeriesDateTime(endPoint: widget.endDateTime);

    final morningSeriesData = seriesDataList[0][0] as List<GraphData>;
    final morningWeightList = seriesDataList[0][1] as List<double>;

    final nightSeriesData = seriesDataList[1][0] as List<GraphData>;
    final nightWeightList = seriesDataList[1][1] as List<double>;

    if (morningWeightList.isEmpty) {
      minimum = 0.0;
      maximum = 100.0;
    } else {
      minimum = getMaxGraph(
        morningList: morningWeightList,
        nightList: nightWeightList,
      );
      maximum = getMinGraph(
        morningList: morningWeightList,
        nightList: nightWeightList,
      );
    }

    morningSource = morningSeriesData.reversed.toList();
    nightSource = nightSeriesData.reversed.toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fastLineDataSource();
  }

  @override
  void didUpdateWidget(covariant GraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    fastLineDataSource();
  }

  getIsWeek() {
    return widget.selectedDateTimeSegment == SegmentedTypes.week ||
        widget.selectedDateTimeSegment == SegmentedTypes.twoWeek;
  }

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    bool isGraphDefault = user.graphType == eGraphDefault;
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

    fastLineSeries({
      required List<GraphData> dataSource,
      required ColorClass color,
    }) {
      bool isVisible = getIsWeek() && isGraphDefault;

      return FastLineSeries(
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: dataSource,
        color: color.s200,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        markerSettings: MarkerSettings(isVisible: isVisible),
        dataLabelSettings: DataLabelSettings(
          isVisible: isVisible,
          useSeriesColor: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

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
                  CommonText(
                    text: '${ymd(
                      locale: locale,
                      dateTime: widget.startDateTime,
                    )} ~ ${ymd(
                      locale: locale,
                      dateTime: widget.endDateTime,
                    )}',
                    size: 12,
                    color: Colors.grey.shade700,
                    isNotTr: true,
                  )
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
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  minimum: minimum,
                  maximum: maximum,
                  plotBands: plotBandList,
                ),
                series: [
                  fastLineSeries(dataSource: morningSource, color: indigo),
                  fastLineSeries(dataSource: nightSource, color: pink),
                ],
                onPlotAreaSwipe: onPlotAreaSwipe,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

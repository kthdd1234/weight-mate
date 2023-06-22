import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dialog/action_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/graph_date_time_custom.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import '../components/area/empty_area.dart';

class GraphData {
  GraphData(this.x, this.y);

  final String x;
  final double? y;
}

class ColumnData {
  ColumnData(this.x, this.y1, this.y2, this.y3);

  final String x;
  final int? y1;
  final int? y2;
  final int? y3;
}

final countInfo = {
  SegmentedTypes.week: 6,
  SegmentedTypes.month: 29,
  SegmentedTypes.threeMonth: 59,
  SegmentedTypes.sixMonth: 89,
  SegmentedTypes.custom: 0,
};

class GraphChart extends StatefulWidget {
  GraphChart({
    super.key,
    required this.selectedRecordTypeSegment,
    required this.selectedDateTimeSegment,
  });

  SegmentedTypes selectedDateTimeSegment, selectedRecordTypeSegment;

  @override
  State<GraphChart> createState() => _GraphChartState();
}

class _GraphChartState extends State<GraphChart> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime startDateTime, endDateTime;

  double? weightMinimum, weightMaximum, actionMinimum, actionMaximum;

  @override
  void initState() {
    userBox = Hive.box('userBox');
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planbox');

    DateTime now = DateTime.now();

    startDateTime = jumpDayDateTime(
      type: jumpDayTypeEnum.subtract,
      dateTime: now,
      days: countInfo[widget.selectedDateTimeSegment]!,
    );
    endDateTime = now;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GraphChart oldWidget) {
    final now = DateTime.now();

    startDateTime = jumpDayDateTime(
      type: jumpDayTypeEnum.subtract,
      dateTime: now,
      days: countInfo[widget.selectedDateTimeSegment]!,
    );
    endDateTime = now;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = userBox.get('userProfile');
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
      return recordBox.get(getDateTimeToInt(datatime));
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
          dateTime: endDateTime,
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
        int days =
            daysBetween(startDateTime: startDateTime, endDateTime: endDateTime);

        return days;
      }

      return countInfo[widget.selectedDateTimeSegment];
    }

    List<GraphData> setLineSeriesData() {
      return setLineSeriesDateTime(
        count: setCount()!,
        format: widget.selectedDateTimeSegment == SegmentedTypes.week
            ? 'dd일'
            : 'MM월\ndd일',
      );
    }

    setLineSeries() {
      return LineSeries(
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: setLineSeriesData(),
        color: weightColor,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        name: '체중 기록',
        markerSettings: MarkerSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
        ),
        dataLabelSettings: DataLabelSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
        ),
      );
    }

    setStackedLineSeriesDateTime({
      required int count,
      required String format,
    }) {
      List<ColumnData> columnSeriesData = [];
      List<PlanBox> planInfoList = planBox.values.toList();
      String dietToString = PlanTypeEnum.diet.toString();
      String exerciseToString = PlanTypeEnum.exercise.toString();
      String lifeStyleToString = PlanTypeEnum.lifestyle.toString();
      Map<String, int> planIndexInfo = {
        dietToString: 0,
        exerciseToString: 1,
        lifeStyleToString: 2
      };
      List<int> planTypeList = [0, 0, 0];

      for (var i = 0; i < planInfoList.length; i++) {
        PlanBox planBox = planInfoList[i];
        planTypeList[planIndexInfo[planBox.type]!] += 1;
      }

      for (var i = 0; i <= count; i++) {
        List<int> actionCountList = [0, 0, 0];
        DateTime subtractDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.subtract,
          dateTime: endDateTime,
          days: i,
        );
        RecordBox? recordInfo = getRecordInfo(subtractDateTime);
        String formatterDay =
            dateTimeFormatter(format: format, dateTime: subtractDateTime);
        List<String?>? titleList =
            recordInfo?.actions?.map((e) => planBox.get(e)?.type).toList();

        if (titleList != null) {
          titleList.forEach(
              (element) => actionCountList[planIndexInfo[element]!] += 1);
        }

        setState(() {
          actionMaximum = (planTypeList.reduce(max) + 2).floorToDouble();
          actionMinimum = 0;
          // print(actionMaximum);
        });

        ColumnData columnData = ColumnData(
          formatterDay,
          actionCountList[0],
          actionCountList[1],
          actionCountList[2],
        );

        columnSeriesData.add(columnData);
      }

      return columnSeriesData.reversed.toList();
    }

    setStackedLineSeriesData() {
      return setStackedLineSeriesDateTime(
        count: setCount()!,
        format: widget.selectedDateTimeSegment == SegmentedTypes.week
            ? 'dd일'
            : 'MM월\ndd일',
      );
    }

    setStackedLineSeries({
      required String yValue,
      required String lValue,
    }) {
      return ColumnSeries(
        name: lValue,
        legendItemText: lValue,
        dataSource: setStackedLineSeriesData(),
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => yValue == 'y1'
            ? data.y1
            : yValue == 'y2'
                ? data.y2
                : data.y3,
      );
    }

    setLineSeriesData();
    setStackedLineSeriesData();

    setChartSwipeDirectionStart() {
      if (widget.selectedDateTimeSegment == SegmentedTypes.custom) {
        return;
      }

      endDateTime = startDateTime;
      startDateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: endDateTime,
        days: countInfo[widget.selectedDateTimeSegment]!,
      );
    }

    setChartSwipeDirectionEnd() {
      if (widget.selectedDateTimeSegment == SegmentedTypes.custom) {
        return;
      } else if (getDateTimeToInt(endDateTime) >=
          getDateTimeToInt(DateTime.now())) {
        return showSnackBar(
          context: context,
          text: '미래의 날짜를 불러올 순 없어요.',
          buttonName: '확인',
        );
      }

      startDateTime = endDateTime;
      endDateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.add,
        dateTime: startDateTime,
        days: countInfo[widget.selectedDateTimeSegment]!,
      );
    }

    onPlotAreaSwipe(ChartSwipeDirection direction) {
      setState(() {
        switch (direction) {
          case ChartSwipeDirection.start:
            setChartSwipeDirectionStart();

            break;
          case ChartSwipeDirection.end:
            setChartSwipeDirectionEnd();

            break;
          default:
        }
      });
    }

    setSizeBoxHeight() {
      final height =
          widget.selectedDateTimeSegment == SegmentedTypes.custom ? 410 : 347;

      return MediaQuery.of(context).size.height - height;
    }

    onSubmit({type, object}) {
      setState(() {
        type == 'start' ? startDateTime = object : endDateTime = object;
      });

      closeDialog(context);
    }

    setSeries() {
      return widget.selectedRecordTypeSegment == SegmentedTypes.weight
          ? [setLineSeries()]
          : [
              setStackedLineSeries(yValue: 'y1', lValue: '식이요법'),
              setStackedLineSeries(yValue: 'y2', lValue: '운동'),
              setStackedLineSeries(yValue: 'y3', lValue: '생활습관'),
            ];
    }

    onTooltipRender(TooltipArgs tooltipArgs) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          showDialog(
            context: context,
            builder: (context) => ActionDialog(title: '6월 21일 실천'),
          );
        },
      );
    }

    List<PlotBand>? plotBands =
        widget.selectedRecordTypeSegment == SegmentedTypes.weight
            ? plotBandList
            : null;
    double? setMinimum =
        widget.selectedRecordTypeSegment == SegmentedTypes.weight
            ? weightMinimum
            : actionMinimum;
    double? setMaximum =
        widget.selectedRecordTypeSegment == SegmentedTypes.weight
            ? weightMaximum
            : actionMaximum;
    bool setLegendVisible =
        widget.selectedRecordTypeSegment == SegmentedTypes.action;
    String titleDateTime =
        '${dateTimeFormatter(dateTime: startDateTime, format: 'MM월 dd일')} ~ ${dateTimeFormatter(dateTime: endDateTime, format: 'MM월 dd일')}';

    String tooltipText =
        widget.selectedRecordTypeSegment == SegmentedTypes.weight
            ? ' kg'
            : '회 실천';

    return Column(
      children: [
        SizedBox(
          height: setSizeBoxHeight(),
          child: SfCartesianChart(
            onTooltipRender: onTooltipRender,
            legend: Legend(
              isVisible: setLegendVisible,
              position: LegendPosition.top,
              alignment: ChartAlignment.center,
            ),
            title: ChartTitle(
              text: titleDateTime,
              alignment: ChartAlignment.far,
              textStyle: const TextStyle(fontSize: 10),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.y$tooltipText',
            ),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: setMinimum,
              maximum: setMaximum,
              plotBands: plotBands,
            ),
            series: setSeries(),
            onPlotAreaSwipe: onPlotAreaSwipe,
          ),
        ),
        SpaceHeight(height: smallSpace),
        widget.selectedDateTimeSegment == SegmentedTypes.custom
            ? GraphDateTimeCustom(
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                onSubmit: onSubmit,
              )
            : const EmptyArea(),
      ],
    );
  }
}

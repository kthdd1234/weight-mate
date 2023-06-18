import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
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

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double? y;
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

  SegmentedTypes selectedRecordTypeSegment, selectedDateTimeSegment;

  @override
  State<GraphChart> createState() => _GraphChartState();
}

class _GraphChartState extends State<GraphChart> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime startDateTime, endDateTime;

  double? minimum, maximum;

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
    final plotBands = widget.selectedRecordTypeSegment == SegmentedTypes.weight
        ? plotBandList
        : null;

    getRecordInfo(DateTime datatime) {
      return recordBox.get(getDateTimeToInt(datatime));
    }

    List<ChartData> setDayDateTime({
      required int count,
      required String format,
    }) {
      List<ChartData> lineSeriesData = [];
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
        ChartData chartData = ChartData(formatterDay, recordInfo?.weight);

        if (recordInfo?.weight != null) {
          weightList.add(recordInfo!.weight!);
        }

        lineSeriesData.add(chartData);
      }

      setState(() {
        if (weightList.isEmpty) {
          minimum = 0.0;
          maximum = 100.0;
        } else {
          minimum = (weightList.reduce(min) - 1).floorToDouble();
          maximum = (weightList.reduce(max) + 1).floorToDouble();
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

    List<ChartData> setLineSeriesData() {
      return setDayDateTime(
        count: setCount()!,
        format: widget.selectedDateTimeSegment == SegmentedTypes.week
            ? 'dd일'
            : 'MM월\ndd일',
      );
    }

    List<ChartData> setColumnSeriesData() {
      return [];
    }

    // final List<ChartData> columnSeriesData = [
    //   ChartData('16일', 70),
    //   ChartData('17일', 30),
    //   ChartData('18일', 50),
    //   ChartData('19일', 44),
    //   ChartData('20일', 72.3),
    //   ChartData('21일', 91.9),
    //   ChartData('22일', 22.3),
    // ];

    final series = {
      SegmentedTypes.weight: LineSeries(
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
      ),
      SegmentedTypes.action: ColumnSeries(
        dataSource: setColumnSeriesData(),
        color: actionColor,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    };

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

    setMinimum() {
      return widget.selectedRecordTypeSegment == SegmentedTypes.weight
          ? minimum
          : 0.0;
    }

    setMaximum() {
      return widget.selectedRecordTypeSegment == SegmentedTypes.weight
          ? maximum
          : 100.0;
    }

    String titleDateTime =
        '${dateTimeFormatter(dateTime: startDateTime, format: 'MM월 dd일')} ~ ${dateTimeFormatter(dateTime: endDateTime, format: 'MM월 dd일')}';

    return Column(
      children: [
        SizedBox(
          height: setSizeBoxHeight(),
          child: SfCartesianChart(
            title: ChartTitle(
              text: titleDateTime,
              alignment: ChartAlignment.far,
              textStyle: const TextStyle(fontSize: 10),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: setMinimum(),
              maximum: setMaximum(),
              plotBands: plotBands,
            ),
            series: [
              series[widget.selectedRecordTypeSegment]!,
            ],
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

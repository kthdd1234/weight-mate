import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/widget(etc)/analyze_body.dart';
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
  // late DateTime startDateTime, endDateTime;

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
        color: weightColor.shade300,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        name: '체중 기록', // todo: "체중 기록" 을 "00월 00일" 로 변경
        markerSettings: MarkerSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
        ),
        dataLabelSettings: DataLabelSettings(
          isVisible: widget.selectedDateTimeSegment == SegmentedTypes.week,
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

    // setSizeBoxHeight() {
    //   final height =
    //       widget.selectedDateTimeSegment == SegmentedTypes.custom ? 410 : 347;

    //   return MediaQuery.of(context).size.height - height;
    // }

    // onSubmit({type, object}) {
    //   setState(() {
    //     type == 'start' ? startDateTime = object : endDateTime = object;
    //   });

    //   closeDialog(context);
    // }

    String titleDateTime =
        '${dateTimeFormatter(dateTime: widget.startDateTime, format: 'MM월 dd일')} ~ ${dateTimeFormatter(dateTime: widget.endDateTime, format: 'MM월 dd일')}';

    return SfCartesianChart(
      legend: Legend(
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
        format: 'point.y kg',
      ),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: weightMinimum,
        maximum: weightMaximum,
        plotBands: plotBandList,
      ),
      series: [setLineSeries()],
      onPlotAreaSwipe: onPlotAreaSwipe,
    );
  }
}

  // SpaceHeight(height: smallSpace),
  //       widget.selectedDateTimeSegment == SegmentedTypes.custom
  //           ? GraphDateTimeCustom(
  //               startDateTime: startDateTime,
  //               endDateTime: endDateTime,
  //               onSubmit: onSubmit,
  //             )
  //           : const EmptyArea(),

    // String dietToString = PlanTypeEnum.diet.toString();
    // String exerciseToString = PlanTypeEnum.exercise.toString();
    // String lifeStyleToString = PlanTypeEnum.lifestyle.toString();
    // Map<String, int> planIndexInfo = {
    //   dietToString: 0,
    //   exerciseToString: 1,
    //   lifeStyleToString: 2
    // };
    //     onTooltipRender(TooltipArgs tooltipArgs) {
    //   WidgetsBinding.instance.addPostFrameCallback(
    //     (timeStamp) {
    //       if (widget.selectedRecordTypeSegment == SegmentedTypes.action) {
    //         List<Map<String, dynamic>> typeInfos = [
    //           {'type': dietToString, 'color': dietColor},
    //           {'type': exerciseToString, 'color': exerciseColor},
    //           {'type': lifeStyleToString, 'color': lifeStyleColor},
    //         ];
    //         int typeIndex = tooltipArgs.seriesIndex;
    //         num pointIndex = tooltipArgs.pointIndex ?? -1;
    //         RecordBox? recordInfo = recordInfoList[pointIndex.toInt()];
    //         String type = typeInfos[typeIndex]['type'];
    //         Color color = typeInfos[typeIndex]['color'];

    //         if (recordInfo != null) {
    //           List<String>? actions = recordInfo.actions;
    //           List<String> names = [];

    //           if (actions != null) {
    //             for (var i = 0; i < actions.length; i++) {
    //               PlanBox? planInfo = planBox.get(actions[i]);

    //               if (planInfo != null && planInfo.type == type) {
    //                 names.add(planInfo.name);
    //               }
    //             }
    //           }

    //           showDialog(
    //             context: context,
    //             builder: (context) => ActionDialog(
    //               dayTitle:
    //                   '${dateTimeFormatter(format: 'MM월 dd일', dateTime: recordInfo.createDateTime)} 실천',
    //               contentsTitle: tooltipArgs.header!,
    //               names: names,
    //               color: color,
    //               count: names.length,
    //             ),
    //           );
    //         }
    //       }
    //     },
    //   );
    // }
    //     double? setMinimum =
    //     widget.selectedRecordTypeSegment == SegmentedTypes.weight
    //         ? weightMinimum
    //         : actionMinimum;
    // double? setMaximum =
    //     widget.selectedRecordTypeSegment == SegmentedTypes.weight
    //         ? weightMaximum
    //         : actionMaximum;

        // String tooltipText =
        // widget.selectedRecordTypeSegment == SegmentedTypes.weight
        //     ? ' kg'
        //     : '회 실천';


    // setStackedLineSeriesDateTime({
    //   required int count,
    //   required String format,
    // }) {
    //   List<ColumnData> columnSeriesData = [];
    //   List<PlanBox> planInfoList = planBox.values.toList();

    //   List<int> planTypeList = [0, 0, 0];
    //   List<RecordBox?> infoList = [];

    //   for (var i = 0; i < planInfoList.length; i++) {
    //     PlanBox planBox = planInfoList[i];
    //     planTypeList[planIndexInfo[planBox.type]!] += 1;
    //   }

    //   for (var i = 0; i <= count; i++) {
    //     List<int> actionCountList = [0, 0, 0];
    //     DateTime subtractDateTime = jumpDayDateTime(
    //       type: jumpDayTypeEnum.subtract,
    //       dateTime: endDateTime,
    //       days: i,
    //     );
    //     RecordBox? recordInfo = getRecordInfo(subtractDateTime);
    //     String formatterDay =
    //         dateTimeFormatter(format: format, dateTime: subtractDateTime);

    //     List<String?>? titleList =
    //         recordInfo?.actions?.map((e) => planBox.get(e)?.type).toList();

    //     infoList.add(recordInfo);

    //     if (titleList != null) {
    //       titleList.forEach(
    //           (element) => actionCountList[planIndexInfo[element]!] += 1);
    //     }

    //     setState(() {
    //       actionMaximum = (planTypeList.reduce(max) + 2).floorToDouble();
    //       actionMinimum = 0;
    //     });

    //     ColumnData columnData = ColumnData(
    //       formatterDay,
    //       actionCountList[0],
    //       actionCountList[1],
    //       actionCountList[2],
    //     );

    //     columnSeriesData.add(columnData);
    //   }

    //   setState(() => recordInfoList = infoList.reversed.toList());
    //   return columnSeriesData.reversed.toList();
    // }

    // setStackedLineSeriesData() {
    //   return setStackedLineSeriesDateTime(
    //     count: setCount()!,
    //     format: widget.selectedDateTimeSegment == SegmentedTypes.week
    //         ? 'dd일'
    //         : 'MM월\ndd일',
    //   );
    // }

    // setStackedLineSeries({
    //   required String yValue,
    //   required String lValue,
    //   required Color color,
    // }) {
    //   return StackedColumnSeries(
    //     color: color,
    //     name: lValue,
    //     legendItemText: lValue,
    //     dataSource: setStackedLineSeriesData(),
    //     xValueMapper: (data, _) => data.x,
    //     yValueMapper: (data, _) => yValue == 'y1'
    //         ? data.y1
    //         : yValue == 'y2'
    //             ? data.y2
    //             : data.y3,
    //   );
    // }
    //    setSeries() {
    //   return widget.selectedRecordTypeSegment == SegmentedTypes.weight
    //       ? [setLineSeries()]
    //       : [
    //           setStackedLineSeries(
    //             yValue: 'y1',
    //             lValue: '식이요법',
    //             color: dietColor,
    //           ),
    //           setStackedLineSeries(
    //             yValue: 'y2',
    //             lValue: '운동',
    //             color: exerciseColor,
    //           ),
    //           setStackedLineSeries(
    //             yValue: 'y3',
    //             lValue: '생활습관',
    //             color: lifeStyleColor,
    //           ),
    //         ];
    // }

// class ColumnData {
//   ColumnData(this.x, this.y1, this.y2, this.y3);

//   final String x;
//   final int? y1;
//   final int? y2;
//   final int? y3;
// }

  // @override
  // void initState() {
  //   DateTime now = DateTime.now();

  //   startDateTime = jumpDayDateTime(
  //     type: jumpDayTypeEnum.subtract,
  //     dateTime: now,
  //     days: countInfo[widget.selectedDateTimeSegment]!,
  //   );
  //   endDateTime = now;
  //   super.initState();
  // }

  // @override
  // void didUpdateWidget(covariant GraphChart oldWidget) {
  //   final now = DateTime.now();

  //   startDateTime = jumpDayDateTime(
  //     type: jumpDayTypeEnum.subtract,
  //     dateTime: now,
  //     days: countInfo[widget.selectedDateTimeSegment]!,
  //   );
  //   endDateTime = now;
  //   super.didUpdateWidget(oldWidget);
  // }
   // setStackedLineSeriesData();

    // setChartSwipeDirectionStart() {
    //   if (widget.selectedDateTimeSegment == SegmentedTypes.custom) {
    //     return;
    //   }

    //   endDateTime = startDateTime;
    //   startDateTime = jumpDayDateTime(
    //     type: jumpDayTypeEnum.subtract,
    //     dateTime: endDateTime,
    //     days: countInfo[widget.selectedDateTimeSegment]!,
    //   );
    // }

    // setChartSwipeDirectionEnd() {
    //   if (widget.selectedDateTimeSegment == SegmentedTypes.custom) {
    //     return;
    //   } else if (getDateTimeToInt(endDateTime) >=
    //       getDateTimeToInt(DateTime.now())) {
    //     return showSnackBar(
    //       context: context,
    //       text: '미래의 날짜를 불러올 순 없어요.',
    //       buttonName: '확인',
    //     );
    //   }

    //   startDateTime = endDateTime;
    //   endDateTime = jumpDayDateTime(
    //     type: jumpDayTypeEnum.add,
    //     dateTime: startDateTime,
    //     days: countInfo[widget.selectedDateTimeSegment]!,
    //   );
    // }
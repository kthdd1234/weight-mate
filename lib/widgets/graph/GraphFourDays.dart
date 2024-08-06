// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables
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

class GraphFourDays extends StatefulWidget {
  GraphFourDays({
    super.key,
    required this.locale,
    required this.weightType,
    required this.importDateTime,
    required this.weight,
    required this.weightNight,
    required this.goalWeight,
    required this.onTapWeight,
    // required this.onTapGoalWeight,
  });

  String locale, weightType;
  DateTime importDateTime;
  double? weight, weightNight, goalWeight;
  Function(String) onTapWeight;

  @override
  State<GraphFourDays> createState() => _GraphFourDaysState();
}

class _GraphFourDaysState extends State<GraphFourDays> {
  List<GraphData> morningSource = [];
  List<GraphData> nightSource = [];
  double? maximum, minimum;

  void initDataSource() {
    List<GraphData> morningDataList = [];
    List<GraphData> nightDataList = [];

    List<double> morningWeightList = [];
    List<double> nightWeightList = [];

    for (var i = 0; i <= 3; i++) {
      DateTime subtractDateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: widget.importDateTime,
        days: i,
      );
      bool isToday = isCheckToday(subtractDateTime);
      int recordKey = getDateTimeToInt(subtractDateTime);
      RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
      String formatterDay = isToday
          ? '오늘'.tr()
          : d(locale: widget.locale, dateTime: subtractDateTime);
      GraphData morningData = GraphData(formatterDay, recordInfo?.weight);
      GraphData nightData = GraphData(formatterDay, recordInfo?.weightNight);

      if (recordInfo?.weight != null) {
        morningWeightList.add(recordInfo!.weight!);
      } else if (recordInfo?.weightNight != null) {
        nightWeightList.add(recordInfo!.weightNight!);
      }

      morningDataList.add(morningData);
      nightDataList.add(nightData);
    }

    maximum = getMaxGraph(
      morningList: morningWeightList,
      nightList: nightWeightList,
    );
    minimum = getMinGraph(
      morningList: morningWeightList,
      nightList: nightWeightList,
    );

    morningSource = morningDataList.reversed.toList();
    nightSource = nightDataList.reversed.toList();

    setState(() {});
  }

  @override
  void initState() {
    initDataSource();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GraphFourDays oldWidget) {
    initDataSource();
    super.didUpdateWidget(oldWidget);
  }

  FastLineSeries fastLineSeries({
    required ColorClass color,
    required List<GraphData> dataSource,
  }) {
    return FastLineSeries(
      emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
      enableTooltip: true,
      markerSettings: const MarkerSettings(isVisible: true),
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        useSeriesColor: true,
        color: color.s50,
        textStyle: TextStyle(
          color: color.s300,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      color: color.s100,
      dataSource: dataSource,
      xValueMapper: (data, _) => data.x,
      yValueMapper: (data, _) => data.y,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String weightUnit = user.weightUnit ?? 'kg';

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      height: 300,
      child: SfCartesianChart(
        enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          maximum: maximum,
          minimum: minimum,
          plotBands: [
            PlotBand(
              dashArray: const [5, 5],
              borderWidth: 1.0,
              borderColor: disabledButtonTextColor,
              isVisible: true,
              text: '목표 체중: '.tr(
                namedArgs: {
                  'weight': '${widget.goalWeight}',
                  'unit': weightUnit
                },
              ),
              textStyle: const TextStyle(color: disabledButtonTextColor),
              start: widget.goalWeight,
              end: widget.goalWeight,
            )
          ],
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          format: 'point.x: point.y$weightUnit',
        ),
        series: [
          fastLineSeries(color: indigo, dataSource: morningSource),
          fastLineSeries(color: pink, dataSource: nightSource)
        ],
      ),
    );
  }
}

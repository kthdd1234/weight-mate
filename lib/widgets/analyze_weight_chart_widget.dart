import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class AnalyzeWeightChartWidget extends StatefulWidget {
  AnalyzeWeightChartWidget({
    super.key,
    required this.selectedRecordTypeSegment,
  });

  SegmentedTypes selectedRecordTypeSegment;

  @override
  State<AnalyzeWeightChartWidget> createState() =>
      _AnalyzeWeightChartWidgetState();
}

class _AnalyzeWeightChartWidgetState extends State<AnalyzeWeightChartWidget> {
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime endTargetDateTime;

  @override
  void initState() {
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planbox');
    endTargetDateTime = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recordValueList = recordBox.values.toList();
    final recordKeyList = recordBox.keys.toList();

    print(recordValueList);
    print(recordKeyList);

    // for 문을 돌려서 day 에 + 1 더하고 7이 되었을 때 for문을 중지한다.

    final List<ChartData> lineSeriesData = [
      ChartData('16일', 71),
      ChartData('17일', null),
      ChartData('18일', null),
      ChartData('19일', 71.8),
      ChartData('20일', 71.5),
      ChartData('21일', null),
      ChartData('22일', 71.2),
    ];

    final List<ChartData> chartData = [
      ChartData('16일', 70),
      ChartData('17일', 30),
      ChartData('18일', 50),
      ChartData('19일', 44),
      ChartData('20일', 72.3),
      ChartData('21일', 91.9),
      ChartData('22일', 22.3),
    ];

    final plotBandList = <PlotBand>[
      PlotBand(
        borderWidth: 1.0,
        borderColor: disabledButtonTextColor,
        isVisible: true,
        text: '목표 체중: 69.5kg',
        textStyle: const TextStyle(color: disabledButtonTextColor),
        start: 70.5,
        end: 70.5,
        dashArray: const <double>[4, 5],
      )
    ];

    final plotBands = widget.selectedRecordTypeSegment == SegmentedTypes.weight
        ? plotBandList
        : null;
    final minimum =
        widget.selectedRecordTypeSegment == SegmentedTypes.weight ? 70.0 : 0.0;
    final maximum = widget.selectedRecordTypeSegment == SegmentedTypes.weight
        ? 73.0
        : 100.0;

    final series = {
      SegmentedTypes.weight: LineSeries(
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: lineSeriesData,
        color: weightColor,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
      SegmentedTypes.action: ColumnSeries(
        dataSource: chartData,
        color: actionColor,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    };

    return SizedBox(
      height: MediaQuery.of(context).size.height - 337,
      child: SfCartesianChart(
        onPlotAreaSwipe: (ChartSwipeDirection direction) {
          print(direction);
        },
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          minimum: minimum,
          maximum: maximum,
          plotBands: plotBands,
        ),
        series: <CartesianSeries>[
          series[widget.selectedRecordTypeSegment]!,
        ],
      ),
    );
  }
}

// primaryYAxis: CategoryAxis(),
// primaryYAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 0)),
// primaryYAxis: CategoryAxis(isVisible: false),

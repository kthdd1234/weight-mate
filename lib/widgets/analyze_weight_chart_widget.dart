import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class AnalyzeWeightChartWidget extends StatelessWidget {
  AnalyzeWeightChartWidget({
    super.key,
    required this.selectedBodyInfoSegment,
  });

  SegmentedTypes selectedBodyInfoSegment;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> lineSeriesData = [
      ChartData('16일', 71),
      ChartData('17일', 71.9),
      ChartData('18일', 71.4),
      ChartData('19일', 71.8),
      ChartData('20일', 71.5),
      ChartData('21일', 71.5),
      ChartData('22일', 71.2),
    ];

    final List<ChartData> columnSeriesData = [
      ChartData('16일', 35),
      ChartData('17일', 23),
      ChartData('18일', 34),
      ChartData('19일', 25),
      ChartData('20일', 70),
      ChartData('21일', 40),
      ChartData('22일', 10),
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
          dashArray: const <double>[4, 5])
    ];

    final series = {
      SegmentedTypes.weight: LineSeries(
        dataSource: lineSeriesData,
        color: Colors.blue,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
      SegmentedTypes.bodyFat: ColumnSeries(
        dataSource: columnSeriesData,
        color: Colors.orange,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
      ),
    };

    final plotBands =
        selectedBodyInfoSegment == SegmentedTypes.weight ? plotBandList : null;

    final minimum =
        selectedBodyInfoSegment == SegmentedTypes.weight ? 70.0 : bodyFatMin;
    final maximum =
        selectedBodyInfoSegment == SegmentedTypes.weight ? 73.0 : bodyFatMax;

    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            minimum: minimum, maximum: maximum, plotBands: plotBands),
        series: <CartesianSeries>[
          series[selectedBodyInfoSegment]!,
        ],
      ),
    );
  }
}

// primaryYAxis: CategoryAxis(),
// primaryYAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 0)),
// primaryYAxis: CategoryAxis(isVisible: false),

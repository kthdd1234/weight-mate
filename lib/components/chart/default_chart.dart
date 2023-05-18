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

class DefaultChart extends StatelessWidget {
  DefaultChart({
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

    final series = {
      SegmentedTypes.weight: LineSeries(
        dataSource: lineSeriesData,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
      SegmentedTypes.bodyFat: ColumnSeries(
          dataSource: columnSeriesData,
          color: Colors.orange,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y),
    };

    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(plotBands: <PlotBand>[
          PlotBand(
              isVisible: true,
              text: '목표 체중',
              start: 71,
              end: 71,
              borderWidth: 2,
              dashArray: const <double>[4, 5])
        ]),
        series: <CartesianSeries>[
          series[selectedBodyInfoSegment]!,
        ],
      ),
    );
  }
}

// primaryYAxis: CategoryAxis(),
//primaryYAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 0)),
// primaryYAxis: CategoryAxis(isVisible: false),

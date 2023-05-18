import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/chart/default_chart.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyzePlanChartWidget extends StatelessWidget {
  const AnalyzePlanChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> columnSeriesData = [
      ChartData('16일', 35),
      ChartData('17일', 23),
      ChartData('18일', 34),
      ChartData('19일', 25),
      ChartData('20일', 70),
      ChartData('21일', 40),
      ChartData('22일', 10),
    ];

    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
        series: <CartesianSeries>[
          ColumnSeries(
            dataSource: columnSeriesData,
            color: Colors.purple,
            xValueMapper: (data, _) => data.x,
            yValueMapper: (data, _) => data.y,
          )
        ],
      ),
    );
  }
}

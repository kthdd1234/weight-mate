import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MaxMinAvgGraphPage extends StatelessWidget {
  const MaxMinAvgGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    DataSourceClass dataSource =
        ModalRoute.of(context)!.settings.arguments as DataSourceClass;

    stackedLineSeries({
      required List<StackGraphData> dataSource,
      required MaterialColor color,
      required String name,
    }) {
      return StackedLineSeries<StackGraphData, String>(
        name: name.tr(),
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        dataSource: dataSource,
        enableTooltip: true,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          useSeriesColor: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: color.shade200,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
      );
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            dataSource.title.tr(),
            style: const TextStyle(fontSize: 20, color: textColor),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SfCartesianChart(
              legend:
                  const Legend(isVisible: true, position: LegendPosition.top),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: CategoryAxis(isVisible: false),
              series: [
                stackedLineSeries(
                  name: '최저 체중',
                  color: Colors.blue,
                  dataSource: dataSource.min,
                ),
                stackedLineSeries(
                  name: '평균 체중',
                  color: Colors.teal,
                  dataSource: dataSource.avg,
                ),
                stackedLineSeries(
                  name: '최고 체중',
                  color: Colors.red,
                  dataSource: dataSource.max,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

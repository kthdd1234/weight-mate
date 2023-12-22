import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircleProgress extends StatelessWidget {
  const CircleProgress({super.key});

  @override
  Widget build(BuildContext context) {
    annotationWidget({
      required double paddingTop,
      required double paddingBottom,
      required String text,
      required double fontSize,
      FontWeight? fontWeight,
    }) {
      return GaugeAnnotation(
        widget: Padding(
          padding: EdgeInsets.only(
            top: paddingTop,
            bottom: paddingBottom,
            left: 12.5,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: themeColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 100,
      height: 100,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1000,
        axes: [
          RadialAxis(
            showLabels: false,
            showTicks: false,
            minimum: 0,
            maximum: 100,
            ranges: [
              GaugeRange(
                startValue: 0,
                endValue: 70,
                color: themeColor,
              ),
            ],
            annotations: [
              annotationWidget(
                paddingTop: 0,
                paddingBottom: 20,
                text: '실천율',
                fontSize: 12,
              ),
              annotationWidget(
                paddingTop: 20,
                paddingBottom: 0,
                text: '70%',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              annotationWidget(
                paddingTop: 85,
                paddingBottom: 0,
                text: '실천 14회',
                fontSize: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}

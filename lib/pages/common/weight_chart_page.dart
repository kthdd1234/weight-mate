import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonBlur.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/weight/WeightAnalyze.dart';
import 'package:flutter_app_weight_management/components/weight/WeightChart.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class WeightChartPage extends StatefulWidget {
  const WeightChartPage({super.key});

  @override
  State<WeightChartPage> createState() => _WeightChartPageState();
}

class _WeightChartPageState extends State<WeightChartPage> {
  SegmentedTypes selectedSegment = SegmentedTypes.chart;
  bool isPremium = false;

  @override
  void initState() {
    initPremium() async {
      isPremium = await isPurchasePremium();
      setState(() {});
    }

    initPremium();
    super.initState();
  }

  onSegmentedChanged(SegmentedTypes? type) {
    setState(() {
      selectedSegment = type!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '체중 모아보기', isCenter: false),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: selectedSegment == SegmentedTypes.chart
                      ? WeightChart()
                      : WeightAnalyze(),
                ),
                SpaceHeight(height: 10),
                DefaultSegmented(
                  selectedSegment: selectedSegment,
                  children: {
                    SegmentedTypes.chart: CommonName(text: '통계'),
                    SegmentedTypes.analyze: CommonName(text: '분석')
                  },
                  onSegmentedChanged: onSegmentedChanged,
                ),
              ],
            ),
            CommonBlur(),
          ],
        ),
      ),
    );
  }
}

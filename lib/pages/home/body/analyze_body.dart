import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_plan_info_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_diet_status_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/analyze_weight_info_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/analyze_plan_data_widget.dart';

class AnalyzeBody extends StatelessWidget {
  const AnalyzeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AnalyzeWeightInfoWidget(),
          SpaceHeight(height: regularSapce),
          const AnalyzePlanInfoWidget(),
          SpaceHeight(height: regularSapce),
          ContentsBox(
              contentsWidget: Column(
            children: [
              ContentsTitleText(text: '실천 순위'),
              SpaceHeight(height: regularSapce),
              AnalyzePlanDataWidget(),
            ],
          )),
          SpaceHeight(height: regularSapce),
          const AnalyzeDietStatusWidget(),
          SpaceHeight(height: regularSapce),
        ],
      ),
    );
  }
}

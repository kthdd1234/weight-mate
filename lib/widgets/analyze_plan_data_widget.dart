import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/analyze_plan_order_widget.dart';

class AnalyzePlanDataWidget extends StatelessWidget {
  const AnalyzePlanDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: Column(
        children: [
          SpaceHeight(height: tinySpace),
          AnalyzePlanOrderWidget(
            index: 1,
            count: 5,
            icon: Icons.monitor_weight,
            text: '잊지 않고 체중 기록하기',
          ),
          AnalyzePlanOrderWidget(
            index: 2,
            count: 4,
            icon: Icons.self_improvement,
            text: '아침과 저녁에 10분 명상하기',
          ),
          AnalyzePlanOrderWidget(
            index: 3,
            count: 2,
            icon: Icons.fastfood_sharp,
            text: '인스턴트 음식 먹지 않기',
          ),
          AnalyzePlanOrderWidget(
            index: 4,
            count: 1,
            icon: Icons.self_improvement,
            text: '반 공기 다이어트',
          ),
          AnalyzePlanOrderWidget(
            index: 5,
            count: 0,
            icon: Icons.fastfood_sharp,
            text: '16:8 간헐적 단식하기',
          ),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularIcon(
                  size: 30,
                  borderRadius: 30,
                  icon: Icons.arrow_back_ios_outlined,
                  backgroundColor: typeBackgroundColor,
                ),
                SpaceWidth(width: regularSapce),
                CircularIcon(
                  size: 30,
                  borderRadius: 30,
                  icon: Icons.arrow_forward_ios_outlined,
                  backgroundColor: typeBackgroundColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

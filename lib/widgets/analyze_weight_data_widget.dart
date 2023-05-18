import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/height_divider.dart';
import 'package:flutter_app_weight_management/components/info/weight_info.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzeWeightDataWidget extends StatelessWidget {
  const AnalyzeWeightDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WeightInfo(name: '최저 몸무게', value: '71.0 kg'),
          HeightDivider(height: 40, color: Colors.grey[300]),
          WeightInfo(name: '최고 몸무게', value: '71.9 kg'),
          HeightDivider(height: 40, color: Colors.grey[300]),
          WeightInfo(name: '목표 체중', value: '69.5 kg'),
        ],
      ),
    );
  }
}

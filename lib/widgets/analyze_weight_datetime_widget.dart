import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzeWeightChangeDatetimeWdiget extends StatelessWidget {
  const AnalyzeWeightChangeDatetimeWdiget({super.key});

  arrowIconButton(String arrow) {
    final arrowInfo = {
      'left': Icons.arrow_back_ios_outlined,
      'right': Icons.arrow_forward_ios_outlined
    };

    return CircularIcon(
      size: 30,
      borderRadius: 30,
      icon: arrowInfo[arrow]!,
      backgroundColor: typeBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          arrowIconButton('left'),
          const Text(
            '4월 16일 ~ 4월 23일',
            style: TextStyle(color: buttonBackgroundColor),
          ),
          arrowIconButton('right'),
        ],
      ),
    );
  }
}

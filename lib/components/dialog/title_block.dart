import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TitleBlock extends StatelessWidget {
  TitleBlock({super.key, required this.type});

  String type;

  @override
  Widget build(BuildContext context) {
    final String text = type == 'start' ? '시작일' : '종료일';
    final Color color = type == 'start' ? buttonBackgroundColor : Colors.red;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text 선택',
            style: const TextStyle(color: buttonBackgroundColor, fontSize: 17),
          ),
          Row(
            children: [
              ColorTextInfo(
                width: smallSpace,
                height: smallSpace,
                text: text,
                color: color,
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TitleBlock extends StatelessWidget {
  TitleBlock({super.key, required this.type, required this.color});

  String type;
  MaterialColor color;

  @override
  Widget build(BuildContext context) {
    final String text = type == 'start' ? '시작일' : '종료일';

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text 선택'.tr(),
            style: const TextStyle(color: themeColor, fontSize: 17),
          ),
          ColorTextInfo(
            width: smallSpace,
            height: smallSpace,
            text: text.tr(),
            color: color.shade300,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class RecordGoal extends StatelessWidget {
  const RecordGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      contentsWidget: ContentsTitleText(
        text: '⛳️ 목표 체중: 55.4kg',
        fontSize: 15,
        sub: const [
          // Icon(
          //   Icons.edit,
          //   color: themeColor,
          //   size: 18,
          // )
        ],
      ),
    );
  }
}

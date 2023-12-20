import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class RecordEdit extends StatelessWidget {
  const RecordEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
        contentsWidget: ContentsTitleText(
      text: '⛳️ 목표 체중은 55.4kg 입니다',
      fontSize: 15,
      sub: const [
        Icon(
          Icons.chevron_right_rounded,
          color: buttonBackgroundColor,
          size: 25,
        )
      ],
    ));
  }
}

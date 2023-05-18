import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzeWeightTitleWidget extends StatelessWidget {
  const AnalyzeWeightTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsTitleText(
      text: '체중 그래프',
      sub: [
        Row(
          children: [
            IconText(
              icon: Icons.commit,
              iconColor: Colors.blueAccent,
              iconSize: 17,
              text: '체중(kg)',
              textColor: disEnabledTypeColor,
              textSize: 13,
            ),
            SpaceWidth(width: 7.5),
            IconText(
              icon: Icons.bar_chart,
              iconColor: Colors.orange,
              iconSize: 17,
              text: '체지방률(%)',
              textColor: disEnabledTypeColor,
              textSize: 13,
            )
          ],
        )
      ],
    );
  }
}

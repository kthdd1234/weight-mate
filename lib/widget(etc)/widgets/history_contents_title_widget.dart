import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryContentsTitleWidget extends StatelessWidget {
  const HistoryContentsTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    subIcon(IconData iconData) {
      return Row(
        children: [
          SpaceWidth(width: smallSpace),
          FaIcon(iconData, size: 15, color: disEnabledTypeColor),
        ],
      );
    }

    return ContentsTitleText(
      text: '3월 30일',
      icon: Icons.manage_search_sharp,
      sub: [
        subIcon(FontAwesomeIcons.arrowUpFromBracket),
        subIcon(FontAwesomeIcons.penToSquare),
        subIcon(FontAwesomeIcons.rotateLeft),
      ],
    );
  }
}

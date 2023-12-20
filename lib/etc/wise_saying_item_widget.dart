import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class WiseSayingItemWidget extends StatelessWidget {
  WiseSayingItemWidget({
    super.key,
    required this.wiseSaying,
    required this.name,
  });

  String wiseSaying;
  String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(wiseSaying),
        SpaceHeight(height: smallSpace),
        BodySmallText(text: name)
      ],
    );
  }
}

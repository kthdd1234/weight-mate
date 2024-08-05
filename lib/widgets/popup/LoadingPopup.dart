import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class LoadingPopup extends StatelessWidget {
  LoadingPopup({
    super.key,
    required this.text,
    required this.color,
    this.nameArgs,
    this.subText,
  });

  String text;
  Color color;
  String? subText;
  Map<String, String>? nameArgs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(strokeWidth: 3),
        SpaceHeight(height: smallSpace),
        CommonText(
          text: text,
          size: 11,
          isCenter: true,
          color: color,
          nameArgs: nameArgs,
        ),
        SpaceHeight(height: 3),
        subText != null
            ? CommonText(
                text: subText!,
                size: 11,
                isCenter: true,
                color: color,
                nameArgs: nameArgs,
              )
            : const EmptyArea(),
      ],
    );
  }
}

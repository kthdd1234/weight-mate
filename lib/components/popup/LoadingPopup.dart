import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class LoadingPopup extends StatelessWidget {
  LoadingPopup({
    super.key,
    required this.text,
    required this.color,
    this.isLoadingIcon,
    this.nameArgs,
    this.subText,
  });

  String text;
  Color color;
  String? subText;
  bool? isLoadingIcon;
  Map<String, String>? nameArgs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoadingIcon == false
            ? const EmptyArea()
            : const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
        CommonText(
          text: text,
          size: 11,
          isCenter: true,
          isBold: true,
          color: color,
          nameArgs: nameArgs,
        ),
        SpaceHeight(height: 3),
        subText != null
            ? CommonText(
                text: subText!,
                size: 11,
                isCenter: true,
                isBold: true,
                color: color,
                nameArgs: nameArgs,
              )
            : const EmptyArea(),
      ],
    );
  }
}

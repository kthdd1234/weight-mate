import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class DefaultSegmented extends StatelessWidget {
  DefaultSegmented({
    super.key,
    required this.selectedSegment,
    required this.children,
    required this.onSegmentedChanged,
    this.backgroundColor,
    this.thumbColor,
  });

  SegmentedTypes selectedSegment;
  Map<SegmentedTypes, Widget> children;
  Color? backgroundColor;
  Color? thumbColor;
  Function(SegmentedTypes? type) onSegmentedChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoSlidingSegmentedControl(
            backgroundColor: backgroundColor ?? dialogBackgroundColor,
            thumbColor: thumbColor ?? typeBackgroundColor,
            groupValue: selectedSegment,
            children: children,
            onValueChanged: onSegmentedChanged,
          ),
        ),
      ],
    );
  }
}

onSegmentedWidget({
  required String title,
  required SegmentedTypes type,
  required SegmentedTypes selected,
  Map<String, String>? nameArgs,
}) {
  return CommonText(
    text: title,
    size: 12,
    nameArgs: nameArgs,
    color: selected == type ? themeColor : Colors.grey,
    isCenter: true,
  );
}

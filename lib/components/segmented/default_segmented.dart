import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class DefaultSegmented extends StatelessWidget {
  DefaultSegmented({
    super.key,
    required this.selectedSegment,
    required this.children,
    required this.onSegmentedChanged,
  });

  SegmentedTypes selectedSegment;
  Map<SegmentedTypes, Widget> children;
  Function(SegmentedTypes?) onSegmentedChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      backgroundColor: dialogBackgroundColor,
      thumbColor: typeBackgroundColor,
      groupValue: selectedSegment,
      children: children,
      onValueChanged: onSegmentedChanged,
    );
  }
}

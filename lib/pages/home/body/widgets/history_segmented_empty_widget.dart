import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class HistorySegmentedEmptyWidget extends StatelessWidget {
  HistorySegmentedEmptyWidget({
    super.key,
    required this.segmented,
  });

  SegmentedTypes segmented;

  @override
  Widget build(BuildContext context) {
    setIcon() {
      final icons = {
        SegmentedTypes.weight: Icons.monitor_weight,
        SegmentedTypes.action: Icons.task_alt,
        SegmentedTypes.diary: Icons.textsms
      };

      return icons[segmented];
    }

    setTitle() {
      final titles = {
        SegmentedTypes.weight: '기록된 체중 정보가 없어요.',
        SegmentedTypes.action: '실천한 계획이 없어요.',
        SegmentedTypes.diary: '기록한 메모가 없어요.'
      };

      return titles[segmented];
    }

    return EmptyTextVerticalArea(
      title: setTitle()!,
      icon: setIcon()!,
    );
  }
}

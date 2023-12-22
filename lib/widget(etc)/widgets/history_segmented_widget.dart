import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class HistorySegmentedWidget extends StatelessWidget {
  HistorySegmentedWidget({
    super.key,
    required this.selectedSegment,
    required this.onSegmentedChanged,
  });

  SegmentedTypes selectedSegment;
  Function(SegmentedTypes?) onSegmentedChanged;

  @override
  Widget build(BuildContext context) {
    segmentedWidget({
      required String name,
      required Color dotColor,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorDot(width: 8, height: 8, color: dotColor),
            SpaceWidth(width: 7.5),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                color: themeColor,
              ),
            )
          ],
        ),
      );
    }

    return DefaultSegmented(
      selectedSegment: selectedSegment,
      children: <SegmentedTypes, Widget>{
        SegmentedTypes.weight: segmentedWidget(
          name: '체중 정보',
          dotColor: weightColor,
        ),
        SegmentedTypes.action: segmentedWidget(
          name: '계획 실천',
          dotColor: actionColor,
        ),
        SegmentedTypes.diary: segmentedWidget(
          name: '',
          dotColor: diaryColor,
        )
      },
      onSegmentedChanged: onSegmentedChanged,
    );
  }
}

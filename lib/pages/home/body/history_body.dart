import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/history_segmented_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/history_calendar_month_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/history_calendar_title_widget.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'widgets/history_segmented_memo_widget.dart';
import 'widgets/history_segmented_plan_widget.dart';
import 'widgets/history_segmented_weight_widget.dart';

Map<SegmentedTypes, Color> dotColors = <SegmentedTypes, Color>{
  SegmentedTypes.weight: weightDotColor,
  SegmentedTypes.actPlan: actionDotColor,
  SegmentedTypes.memo: memoDotColor,
};

class HistoryBody extends StatefulWidget {
  const HistoryBody({super.key});

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  DateTime selectedDateTime = DateTime.now();
  SegmentedTypes selectedSegment = SegmentedTypes.weight;

  @override
  Widget build(BuildContext context) {
    onSelectionChanged(args) {
      if (args.value is DateTime) {
        DateTime dateTime = args.value;
        setState(() => selectedDateTime = dateTime);
      }
    }

    onSegmentedChanged(SegmentedTypes? value) {
      if (value != null) {
        setState(() => selectedSegment = value);
      }
    }

    onSelectedSegmentedWidget() {
      final segmentedWidgets = {
        SegmentedTypes.weight: const HistorySegmentedWeightWidget(),
        SegmentedTypes.actPlan: const HistorySegmentedPlanWidget(),
        SegmentedTypes.memo: const HistorySegmentedMemoWidget()
      };

      return segmentedWidgets[selectedSegment];
    }

    return SingleChildScrollView(
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            const HistoryCalendarTitleWidget(),
            SpaceHeight(height: regularSapce),
            HistorySegmentedWidget(
              selectedSegment: selectedSegment,
              onSegmentedChanged: onSegmentedChanged,
            ),
            SpaceHeight(height: smallSpace),
            HistoryCalendarMonthWidget(
              selectedDateTime: selectedDateTime,
              onSelectionChanged: onSelectionChanged,
            ),
            SpaceHeight(height: smallSpace),
            Container(child: onSelectedSegmentedWidget())
          ],
        ),
      ),
    );
  }
}

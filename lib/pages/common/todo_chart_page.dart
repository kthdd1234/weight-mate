import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/todo/GoalMonthlyContainer.dart';
import 'package:flutter_app_weight_management/components/todo/GoalWeeklyContainer.dart';
import 'package:flutter_app_weight_management/components/todo/RecordChart.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class TodoChartPage extends StatefulWidget {
  TodoChartPage({
    super.key,
    required this.type,
    required this.title,
  });

  String type, title;

  @override
  State<TodoChartPage> createState() => _TodoChartPageState();
}

class _TodoChartPageState extends State<TodoChartPage> {
  SegmentedTypes selectedSegment = SegmentedTypes.record;

  @override
  void initState() {
    selectedSegment =
        widget.type != eLife ? SegmentedTypes.record : SegmentedTypes.week;

    super.initState();
  }

  onSegmentedChanged(SegmentedTypes? type) {
    setState(() => selectedSegment = type!);
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.type;
    String title = widget.title;

    Map<SegmentedTypes, Widget> children1 = {
      SegmentedTypes.record: onSegmentedWidget(
        title: '$title 기록 (월)',
        type: SegmentedTypes.record,
        selected: selectedSegment,
      ),
      SegmentedTypes.week: onSegmentedWidget(
        title: '$title 목표 (주)',
        type: SegmentedTypes.week,
        selected: selectedSegment,
      ),
      SegmentedTypes.month: onSegmentedWidget(
        title: '$title 목표 (월)',
        type: SegmentedTypes.month,
        selected: selectedSegment,
      ),
    };

    Map<SegmentedTypes, Widget> children2 = {
      SegmentedTypes.week: onSegmentedWidget(
        title: '일주일',
        type: SegmentedTypes.week,
        selected: selectedSegment,
      ),
      SegmentedTypes.month: onSegmentedWidget(
        title: '한달',
        type: SegmentedTypes.month,
        selected: selectedSegment,
      ),
    };

    Widget child = {
      SegmentedTypes.record: RecordChart(type: type),
      SegmentedTypes.week: GoalWeeklyContainer(type: type),
      SegmentedTypes.month: GoalMonthlyContainer(type: type),
    }[selectedSegment]!;

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(
          title: ' 모아보기',
          nameArgs: {'type': title.tr()},
        ),
        body: Column(
          children: [
            child,
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: DefaultSegmented(
                selectedSegment: selectedSegment,
                children: type != eLife ? children1 : children2,
                onSegmentedChanged: onSegmentedChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

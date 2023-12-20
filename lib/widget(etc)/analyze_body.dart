import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/analyze_action_record.dart';
import 'package:flutter_app_weight_management/widgets/graph_chart.dart';
import 'package:flutter_app_weight_management/widgets/graph_date_time_custom.dart';
import 'package:flutter_app_weight_management/widgets/segmented_widget.dart';
import 'package:hive/hive.dart';

import '../model/plan_box/plan_box.dart';
import '../model/record_box/record_box.dart';
import '../model/user_box/user_box.dart';

final countInfo = {
  SegmentedTypes.week: 6,
  SegmentedTypes.month: 29,
  SegmentedTypes.threeMonth: 59,
  SegmentedTypes.sixMonth: 89,
  SegmentedTypes.custom: 0,
};

class AnalyzeBody extends StatefulWidget {
  const AnalyzeBody({super.key});

  @override
  State<AnalyzeBody> createState() => _AnalyzeBodyState();
}

class _AnalyzeBodyState extends State<AnalyzeBody> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime startDateTime, endDateTime;

  SegmentedTypes selectedRecordTypeSegment = SegmentedTypes.weight;
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;

  setTitleDateTime() {
    DateTime now = DateTime.now();

    startDateTime = jumpDayDateTime(
      type: jumpDayTypeEnum.subtract,
      dateTime: now,
      days: countInfo[selectedDateTimeSegment]!,
    );
    endDateTime = now;
  }

  @override
  void initState() {
    userBox = Hive.box('userBox');
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planbox');

    setTitleDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<SegmentedTypes, Widget> recordTypeChildren = {
      SegmentedTypes.weight:
          SegmentedWidget(title: '체중 변화', color: weightColor),
      SegmentedTypes.action:
          SegmentedWidget(title: '실천 기록', color: actionColor),
    };

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: SegmentedWidget(title: '일주일'),
      SegmentedTypes.month: SegmentedWidget(title: '한달'),
      SegmentedTypes.threeMonth: SegmentedWidget(title: '3개월'),
      SegmentedTypes.sixMonth: SegmentedWidget(title: '6개월'),
      SegmentedTypes.custom: SegmentedWidget(title: '커스텀'),
    };

    onSegmentedRecordTypeChanged(SegmentedTypes? segmented) {
      setState(() {
        selectedRecordTypeSegment = segmented!;
        selectedDateTimeSegment = SegmentedTypes.week;
      });
    }

    setChartSwipeDirectionStart() {
      setState(() {
        if (selectedDateTimeSegment == SegmentedTypes.custom) {
          return;
        }

        endDateTime = startDateTime;
        startDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.subtract,
          dateTime: endDateTime,
          days: countInfo[selectedDateTimeSegment]!,
        );
      });
    }

    setChartSwipeDirectionEnd() {
      setState(() {
        if (selectedDateTimeSegment == SegmentedTypes.custom) {
          return;
        } else if (getDateTimeToInt(endDateTime) >=
            getDateTimeToInt(DateTime.now())) {
          // ignore: void_checks
          return showSnackBar(
            context: context,
            text: '미래의 날짜를 불러올 순 없어요.',
            buttonName: '확인',
          );
        }

        startDateTime = endDateTime;
        endDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.add,
          dateTime: startDateTime,
          days: countInfo[selectedDateTimeSegment]!,
        );
      });
    }

    setInfoText() {
      if (selectedDateTimeSegment == SegmentedTypes.custom) {
        return const EmptyArea();
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.swipe, size: 15, color: Colors.grey),
              SpaceWidth(width: tinySpace),
              BodySmallText(text: '좌우로 움직여 날짜를 변경 해보세요.'),
            ],
          ),
          SpaceHeight(height: smallSpace),
        ],
      );
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      setState(() {
        selectedDateTimeSegment = segmented!;
        setTitleDateTime();
      });
    }

    onSubmit({type, object}) {
      setState(() {
        type == 'start' ? startDateTime = object : endDateTime = object;
      });

      closeDialog(context);
    }

    setAnalyzeContents() {
      if (selectedRecordTypeSegment == SegmentedTypes.weight) {
        return Expanded(
          child: GraphChart(
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            recordBox: recordBox,
            userBox: userBox,
            selectedDateTimeSegment: selectedDateTimeSegment,
            setChartSwipeDirectionStart: setChartSwipeDirectionStart,
            setChartSwipeDirectionEnd: setChartSwipeDirectionEnd,
          ),
        );
      }

      return AnalyzeActionRecord(recordBox: recordBox);
    }

    setAnalyzeCustom() {
      if (selectedDateTimeSegment == SegmentedTypes.custom) {
        return Column(
          children: [
            SpaceHeight(height: smallSpace),
            GraphDateTimeCustom(
              startDateTime: startDateTime,
              endDateTime: endDateTime,
              onSubmit: onSubmit,
            )
          ],
        );
      }

      return const EmptyArea();
    }

    setAnalyzeBottom() {
      if (selectedRecordTypeSegment == SegmentedTypes.weight) {
        return Column(
          children: [
            setAnalyzeCustom(),
            SpaceHeight(height: smallSpace),
            // setInfoText(),
            DefaultSegmented(
              selectedSegment: selectedDateTimeSegment,
              children: dateTimeChildren,
              backgroundColor: typeBackgroundColor,
              thumbColor: dialogBackgroundColor,
              onSegmentedChanged: onSegmentedDateTimeChanged,
            ),
          ],
        );
      }

      return const EmptyArea();
    }

    return Column(
      children: [
        // BannerWidget(),
        // SpaceHeight(height: smallSpace),
        // DefaultSegmented(
        //   selectedSegment: selectedRecordTypeSegment,
        //   children: recordTypeChildren,
        //   backgroundColor: typeBackgroundColor,
        //   thumbColor: dialogBackgroundColor,
        //   onSegmentedChanged: onSegmentedRecordTypeChanged,
        // ),
        setAnalyzeContents(),
        setAnalyzeBottom()
      ],
    );
  }
}

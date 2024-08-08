import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/AdBottomSheet.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_datetime_custom.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/graph_category_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_chart.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:hive/hive.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

Map<SegmentedTypes, int> countInfo = {
  SegmentedTypes.week: 6,
  SegmentedTypes.twoWeek: 13,
  SegmentedTypes.month: 29,
  SegmentedTypes.threeMonth: 89,
  SegmentedTypes.sixMonth: 179,
  SegmentedTypes.oneYear: 364,
};

class GraphBody extends StatefulWidget {
  const GraphBody({super.key});

  @override
  State<GraphBody> createState() => _GraphBodyState();
}

class _GraphBodyState extends State<GraphBody> {
  late DateTime startDateTime, endDateTime;
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
    setTitleDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;
    bool isPremium = context.watch<PremiumProvider>().isPremium;
    String graphCategory = context.watch<GraphCategoryProvider>().graphCategory;

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: onSegmentedWidget(
        title: '일주일',
        type: SegmentedTypes.week,
        selected: selectedDateTimeSegment,
      ),
      SegmentedTypes.twoWeek: onSegmentedWidget(
        title: '2주',
        type: SegmentedTypes.twoWeek,
        selected: selectedDateTimeSegment,
      ),
      SegmentedTypes.month: onSegmentedWidget(
        title: '1개월',
        type: SegmentedTypes.month,
        selected: selectedDateTimeSegment,
      ),
      SegmentedTypes.threeMonth: onSegmentedWidget(
        title: '3개월',
        type: SegmentedTypes.threeMonth,
        selected: selectedDateTimeSegment,
      ),
      SegmentedTypes.sixMonth: onSegmentedWidget(
        title: '6개월',
        type: SegmentedTypes.sixMonth,
        selected: selectedDateTimeSegment,
      ),
      SegmentedTypes.oneYear: onSegmentedWidget(
        title: '1년',
        type: SegmentedTypes.oneYear,
        selected: selectedDateTimeSegment,
      ),
    };

    setChartSwipeDirectionStart() {
      setState(() {
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
        if (getDateTimeToInt(endDateTime) >= getDateTimeToInt(DateTime.now())) {
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

    onChanged(SegmentedTypes? segmented) {
      setState(() {
        selectedDateTimeSegment = segmented!;
        setTitleDateTime();
      });
    }

    onSegmentedDateTimeChanged(SegmentedTypes? segmented) {
      UserBox user = userRepository.user;
      DateTime? watchingAdDatetTime =
          user.watchingAdDatetTime ?? DateTime(2000, 1, 1);
      DateTime dateTime24 = watchingAdDatetTime.add(
        const Duration(hours: 24),
      );
      bool isIn24Hours = dateTime24.isAfter(DateTime.now());

      if (isPremium || isIn24Hours) {
        onChanged(segmented);
      } else {
        showModalBottomSheet(
          context: context,
          builder: (context) => AdBottomSheet(onChanged: () {
            onChanged(segmented);
          }),
        );
      }
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        DateTime now = DateTime.now();
        UserBox? user = userRepository.user;
        String? graphType = user.graphType ?? eGraphDefault;
        DateTime? customStartDateTime = user.cutomGraphStartDateTime ?? now;
        DateTime? customEndDateTime = user.cutomGraphEndDateTime ?? now;

        return Padding(
          padding: const EdgeInsets.only(bottom: tinySpace),
          child: Column(
            children: [
              CommonAppBar(id: id),
              GraphChart(
                graphCategory: graphCategory,
                graphType: graphType,
                startDateTime: graphType == eGraphDefault
                    ? startDateTime
                    : customStartDateTime,
                endDateTime: graphType == eGraphDefault
                    ? endDateTime
                    : customEndDateTime,
                selectedDateTimeSegment: selectedDateTimeSegment,
                setChartSwipeDirectionStart: setChartSwipeDirectionStart,
                setChartSwipeDirectionEnd: setChartSwipeDirectionEnd,
              ),
              graphType == eGraphDefault
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DefaultSegmented(
                        selectedSegment: selectedDateTimeSegment,
                        children: dateTimeChildren,
                        backgroundColor: typeBackgroundColor,
                        thumbColor: whiteBgBtnColor,
                        onSegmentedChanged: onSegmentedDateTimeChanged,
                      ),
                    )
                  : GraphDateTimeCustom(
                      startDateTime: customStartDateTime,
                      endDateTime: customEndDateTime,
                    ),
            ],
          ),
        );
      },
    );
  }
}

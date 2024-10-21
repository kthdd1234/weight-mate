import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/etc/AdBottomSheet.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_datetime_custom.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/graph_category_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_chart.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

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
      days: rangeInfo[selectedDateTimeSegment]!,
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
    bool isPremium = context.watch<PremiumProvider>().isPremium;
    String graphCategory = context.watch<GraphCategoryProvider>().graphCategory;

    setChartSwipeDirectionStart() {
      setState(() {
        endDateTime = startDateTime;
        startDateTime = jumpDayDateTime(
          type: jumpDayTypeEnum.subtract,
          dateTime: endDateTime,
          days: rangeInfo[selectedDateTimeSegment]!,
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
          days: rangeInfo[selectedDateTimeSegment]!,
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
      onChanged(segmented);
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
              CommonAppBar(),
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
              !isPremium
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BannerWidget(),
                    )
                  : const EmptyArea(),
              graphType == eGraphDefault
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DefaultSegmented(
                        selectedSegment: selectedDateTimeSegment,
                        children: rangeSegmented(selectedDateTimeSegment),
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

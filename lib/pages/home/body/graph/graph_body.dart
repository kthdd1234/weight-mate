import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_default_dialog.dart';
import 'package:flutter_app_weight_management/components/dialog/title_block.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_chart.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

final countInfo = {
  SegmentedTypes.week: 6,
  SegmentedTypes.month: 29,
  SegmentedTypes.threeMonth: 89,
  SegmentedTypes.sixMonth: 179,
  SegmentedTypes.custom: 0,
};

class GraphBody extends StatefulWidget {
  const GraphBody({super.key});

  @override
  State<GraphBody> createState() => _GraphBodyState();
}

class _GraphBodyState extends State<GraphBody> {
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
    setTitleDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Box<UserBox> userBox = userRepository.userBox;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;

    Map<SegmentedTypes, Widget> dateTimeChildren = {
      SegmentedTypes.week: SegmentedWidget(title: '일주일'),
      SegmentedTypes.month: SegmentedWidget(title: '한달'),
      SegmentedTypes.threeMonth: SegmentedWidget(title: '3개월'),
      SegmentedTypes.sixMonth: SegmentedWidget(title: '6개월'),
      SegmentedTypes.custom: SegmentedWidget(title: '날짜 선택'),
    };

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

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        CommonAppBar(id: id),
        SpaceHeight(height: smallSpace),
        GraphChart(
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          recordBox: recordBox,
          userBox: userBox,
          selectedDateTimeSegment: selectedDateTimeSegment,
          setChartSwipeDirectionStart: setChartSwipeDirectionStart,
          setChartSwipeDirectionEnd: setChartSwipeDirectionEnd,
        ),
        selectedDateTimeSegment == SegmentedTypes.custom
            ? GraphDateTimeCustom(
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                onSubmit: onSubmit,
              )
            : const EmptyArea(),
        SpaceHeight(height: smallSpace),
        DefaultSegmented(
          selectedSegment: selectedDateTimeSegment,
          children: dateTimeChildren,
          backgroundColor: typeBackgroundColor,
          thumbColor: dialogBackgroundColor,
          onSegmentedChanged: onSegmentedDateTimeChanged,
        ),
        SpaceHeight(height: tinySpace),
      ],
    );
  }
}

class SegmentedWidget extends StatelessWidget {
  SegmentedWidget({
    super.key,
    required this.title,
    this.color,
  });

  String title;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        color != null ? Dot(size: 7.5, color: color!) : const EmptyArea(),
        color != null ? SpaceWidth(width: tinySpace) : const EmptyArea(),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: themeColor,
          ),
        ),
      ],
    );
  }
}

class GraphDateTimeCustom extends StatelessWidget {
  GraphDateTimeCustom({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    required this.onSubmit,
  });

  DateTime startDateTime, endDateTime;
  Function({String? type, Object? object}) onSubmit;

  @override
  Widget build(BuildContext context) {
    onTap({
      required String type,
      required DateTime dateTime,
    }) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalendarDefaultDialog(
          type: type,
          titleWidgets: TitleBlock(type: type),
          initialDateTime: dateTime,
          onSubmit: onSubmit,
          onCancel: () => closeDialog(context),
          maxDate: type == 'start' ? endDateTime : null,
          minDate: type == 'end' ? startDateTime : null,
        ),
      );
    }

    contentsBoxWidget({
      required DateTime dateTime,
      required String type,
      required IconData icon,
      required String text,
      required String title,
    }) {
      return InkWell(
        onTap: () => onTap(type: type, dateTime: dateTime),
        child: ContentsBox(
          backgroundColor: typeBackgroundColor,
          contentsWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmallText(text: title),
                  SpaceHeight(height: smallSpace),
                  Text(text),
                ],
              ),
              CircularIcon(
                icon: icon,
                size: 40,
                borderRadius: 40,
                backgroundColor: dialogBackgroundColor,
                onTap: (id) => onTap(type: type, dateTime: dateTime),
              )
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SpaceHeight(height: smallSpace),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: contentsBoxWidget(
                  dateTime: startDateTime,
                  type: 'start',
                  icon: Icons.calendar_month,
                  title: '시작일',
                  text: dateTimeFormatter(
                    format: 'MM월 dd일',
                    dateTime: startDateTime,
                  ),
                ),
              ),
              SpaceWidth(width: smallSpace),
              Expanded(
                child: contentsBoxWidget(
                  dateTime: endDateTime,
                  type: 'end',
                  icon: Icons.calendar_month,
                  title: '종료일',
                  text: dateTimeFormatter(
                    format: 'MM월 dd일',
                    dateTime: endDateTime,
                  ),
                ),
              ),
            ],
          ),
          SpaceHeight(height: smallSpace),
        ],
      ),
    );
  }
}
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/pages/home/record/record_body.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/graph/GraphView.dart';
import 'package:flutter_app_weight_management/widgets/maker/DotMaker.dart';
import 'package:flutter_app_weight_management/widgets/popup/CalendarSelectionPopup.dart';
import 'package:flutter_app_weight_management/widgets/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
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
    Box<UserBox> userBox = userRepository.userBox;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;
    bool isPremium = context.watch<PremiumProvider>().isPremium;

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
      onChanged(segmented);
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        String locale = context.locale.toString();
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
              GraphView(
                locale: locale,
                userBox: userBox,
                recordBox: recordBox,
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

class GraphDateTimeCustom extends StatelessWidget {
  GraphDateTimeCustom({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
  });

  DateTime startDateTime, endDateTime;

  @override
  Widget build(BuildContext context) {
    UserBox? user = userRepository.user;

    onSubmit(DateTime dateTime, String type) async {
      bool isStart = type == 'start';
      isStart
          ? user.cutomGraphStartDateTime = dateTime
          : user.cutomGraphEndDateTime = dateTime;

      await user.save();
      closeDialog(context);
    }

    onTap({
      required String type,
      required DateTime dateTime,
      required MaterialColor backgroundColor,
      required MaterialColor selectionColor,
    }) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalendarSelectionPopup(
          selectionColor: selectionColor,
          backgroundColor: backgroundColor,
          type: type,
          titleWidgets: TitleBlock(type: type, color: selectionColor),
          initialDateTime: dateTime,
          maxDate: type == 'start' ? endDateTime : null,
          minDate: type == 'end' ? startDateTime : null,
          onSubmit: onSubmit,
        ),
      );
    }

    contentsBoxWidget({
      required DateTime dateTime,
      required String type,
      required String text,
      required String title,
      required String svg,
      required MaterialColor color,
    }) {
      return InkWell(
        onTap: () => onTap(
            type: type,
            dateTime: dateTime,
            selectionColor: color,
            backgroundColor: color),
        child: ContentsBox(
          backgroundColor: typeBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Dot(size: 8, color: color.shade200),
                      SpaceWidth(width: 5),
                      CommonText(text: title, size: 12),
                    ],
                  ),
                  SpaceHeight(height: 2),
                  CommonText(text: text, size: 13, isNotTr: true)
                ],
              ),
              CommonSvg(name: svg, width: 40),
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
                  svg: 'arrow-start',
                  title: '시작일',
                  color: Colors.blue,
                  text: ymdShort(
                    locale: context.locale.toString(),
                    dateTime: startDateTime,
                  ),
                ),
              ),
              SpaceWidth(width: smallSpace),
              Expanded(
                child: contentsBoxWidget(
                  dateTime: endDateTime,
                  type: 'end',
                  svg: 'arrow-end',
                  title: '종료일',
                  color: Colors.red,
                  text: ymdShort(
                    locale: context.locale.toString(),
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

class TitleBlock extends StatelessWidget {
  TitleBlock({super.key, required this.type, required this.color});

  String type;
  MaterialColor color;

  @override
  Widget build(BuildContext context) {
    final String text = type == 'start' ? '시작일' : '종료일';

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text 선택'.tr(),
            style: const TextStyle(color: textColor, fontSize: 17),
          ),
          ColorTextInfo(
            width: smallSpace,
            height: smallSpace,
            text: text.tr(),
            color: color.shade300,
          )
        ],
      ),
    );
  }
}

class ColorTextInfo extends StatelessWidget {
  ColorTextInfo({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.color,
    this.isOutlined,
  });

  double width;
  double height;
  String text;
  Color color;
  bool? isOutlined;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceWidth(width: smallSpace),
        Dot(
          size: width,
          color: color,
          isOutlined: isOutlined,
        ),
        SpaceWidth(width: tinySpace),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

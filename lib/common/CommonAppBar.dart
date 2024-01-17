import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/history_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class CommonAppBar extends StatefulWidget {
  CommonAppBar({super.key, required this.id});

  BottomNavigationEnum id;

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  CalendarFormat calendarFormat = CalendarFormat.week;
  CalendarMaker calendarMaker = CalendarMaker.sticker;

  @override
  Widget build(BuildContext context) {
    onFormatChanged(CalendarFormat format) {
      setState(() => calendarFormat = format);
    }

    onTapMakerType(CalendarMaker maker) {
      setState(() => calendarMaker = maker);
    }

    return Column(
      children: [
        CommonTitle(
          index: widget.id.index,
          calendarMaker: calendarMaker,
          calendarFormat: calendarFormat,
          onFormatChanged: onFormatChanged,
          onTapMakerType: onTapMakerType,
        ),
        SpaceHeight(height: tinySpace),
        widget.id.index == 0
            ? CalendarBar(
                calendarFormat: calendarFormat,
                calendarMaker: calendarMaker,
                onFormatChanged: onFormatChanged,
              )
            : const EmptyArea(),
      ],
    );
  }
}

class CommonTitle extends StatefulWidget {
  CommonTitle({
    super.key,
    required this.index,
    required this.calendarFormat,
    required this.calendarMaker,
    required this.onFormatChanged,
    required this.onTapMakerType,
  });

  int index;
  CalendarFormat calendarFormat;
  CalendarMaker calendarMaker;
  Function(CalendarFormat) onFormatChanged;
  Function(CalendarMaker) onTapMakerType;

  @override
  State<CommonTitle> createState() => _CommonTitleState();
}

class _CommonTitleState extends State<CommonTitle> {
  @override
  Widget build(BuildContext context) {
    DateTime titleDateTime = context.watch<TitleDateTimeProvider>().dateTime();
    DateTime historyDateTime =
        context.watch<HistoryDateTimeProvider>().dateTime();
    HistoryFilter historyFilter =
        context.watch<HistoryFilterProvider>().value();

    String title = [
      dateTimeFormatter(format: 'yyyy년 MM월', dateTime: titleDateTime),
      dateTimeFormatter(format: 'yyyy년', dateTime: historyDateTime),
      '체중 변화',
      '설정'
    ][widget.index];

    bool isRecord = widget.index == 0;
    bool isHistory = widget.index == 1;
    IconData recordRightIcon = CalendarFormat.month == widget.calendarFormat
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    IconData historyRightIcon = Icons.keyboard_arrow_down_rounded;
    bool isToday = isCheckToday(titleDateTime);

    onTapHistoryDateTime(args) {
      context.read<HistoryDateTimeProvider>().setHistoryDateTime(args.value);
      closeDialog(context);
    }

    onTapTitleDateTime() {
      widget.onFormatChanged(nextCalendarFormats[widget.calendarFormat]!);
    }

    onTapHistory() {
      showDialog(
          context: context,
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AlertDialog(
                  backgroundColor: dialogBackgroundColor,
                  shape: containerBorderRadious,
                  title: DialogTitle(
                    text: '선택 년도',
                    onTap: () => closeDialog(context),
                  ),
                  content: YearContainer(
                    initialSelectedDate: historyDateTime,
                    onSelectionChanged: onTapHistoryDateTime,
                  ),
                ),
              ],
            );
          });
    }

    onTapFilter() {
      context.read<HistoryFilterProvider>().setHistoryFilter(
            nextHistoryFilter[historyFilter]!,
          );
    }

    onTapToday() {
      DateTime now = DateTime.now();

      context.read<TitleDateTimeProvider>().setTitleDateTime(now);
      context.read<ImportDateTimeProvider>().setImportDateTime(now);
    }

    List<IconData?> rightIconList = [
      recordRightIcon,
      historyRightIcon,
      null,
      null
    ];
    List<Null Function()?> onTapList = [
      onTapTitleDateTime,
      onTapHistory,
      null,
      null
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: title,
            size: 20,
            rightIcon: rightIconList[widget.index],
            onTap: onTapList[widget.index],
          ),
          Row(
            children: [
              isRecord
                  ? Row(
                      children: [
                        isToday
                            ? const EmptyArea()
                            : CommonTag(
                                text: '오늘로 이동',
                                color: 'whiteBlue',
                                onTap: onTapToday,
                              ),
                        SpaceWidth(width: tinySpace),
                        CommonTag(
                          text: availableCalendarMaker[widget.calendarMaker],
                          color: 'whiteIndigo',
                          onTap: () => widget.onTapMakerType(
                            nextCalendarMaker[widget.calendarMaker]!,
                          ),
                        ),
                        SpaceWidth(width: tinySpace),
                        CommonTag(
                          text: availableCalendarFormats[widget.calendarFormat],
                          color: 'whiteIndigo',
                          onTap: () => widget.onFormatChanged(
                            nextCalendarFormats[widget.calendarFormat]!,
                          ),
                        ),
                      ],
                    )
                  : const EmptyArea(),
              isHistory
                  ? CommonTag(
                      text: historyFilterFormats[historyFilter],
                      color: historyFilter == HistoryFilter.recent
                          ? 'whiteBlue'
                          : 'whiteRed',
                      onTap: onTapFilter,
                    )
                  : const EmptyArea(),
            ],
          )
        ],
      ),
    );
  }
}

String dietType = PlanTypeEnum.diet.toString();
String exerciseType = PlanTypeEnum.exercise.toString();
String lifeType = PlanTypeEnum.lifestyle.toString();

class CalendarBar extends StatelessWidget {
  CalendarBar({
    super.key,
    required this.calendarFormat,
    required this.calendarMaker,
    required this.onFormatChanged,
  });

  CalendarFormat calendarFormat;
  CalendarMaker calendarMaker;
  Function(CalendarFormat) onFormatChanged;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    onDaySelected(selectedDay, _) {
      context.read<ImportDateTimeProvider>().setImportDateTime(selectedDay);
      context.read<TitleDateTimeProvider>().setTitleDateTime(selectedDay);
    }

    nullCheckAction(List<Map<String, dynamic>>? actions, String type) {
      if (actions == null) return null;

      return actions.firstWhere(
        (action) => action['type'] == type,
        orElse: () => {'type': null},
      )['type'];
    }

    colorName(dynamic target, String name) {
      return target != null ? name : null;
    }

    stickerBuilder(context, day, events) {
      int recordKey = getDateTimeToInt(day);
      RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
      List<Map<String, dynamic>>? actions = recordInfo?.actions;

      String? weight = colorName(recordInfo?.weight, 'indigo');
      String? picture =
          colorName((recordInfo?.leftFile ?? recordInfo?.rightFile), 'purple');
      String? diet = colorName(nullCheckAction(actions, dietType), 'teal');
      String? exercise =
          colorName(nullCheckAction(actions, exerciseType), 'lightBlue');
      String? life = colorName(nullCheckAction(actions, lifeType), 'brown');
      String? diary =
          colorName((recordInfo?.whiteText ?? recordInfo?.emotion), 'orange');

      List<String?> row1 = [weight, picture, diet];
      List<String?> row2 = [exercise, life, diary];

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DotRow(row: row1),
          SpaceHeight(height: 3),
          DotRow(row: row2),
        ],
      );
    }

    weightBuilder(context, day, events) {
      int recordKey = getDateTimeToInt(day);
      RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
      bool? isWeight = recordInfo?.weight != null;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CommonText(
          text: isWeight ? '${recordInfo?.weight}kg' : '',
          size: 8,
          color: Colors.black,
          isCenter: true,
        ),
      );
    }

    onPageChanged(dateTime) {
      context.read<TitleDateTimeProvider>().setTitleDateTime(dateTime);
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: TableCalendar(
                locale: 'ko-KR',
                calendarBuilders: CalendarBuilders(
                  markerBuilder: calendarMaker == CalendarMaker.sticker
                      ? stickerBuilder
                      : weightBuilder,
                ),
                headerVisible: false,
                calendarStyle: CalendarStyle(
                  cellMargin: const EdgeInsets.all(15.0),
                  todayDecoration: BoxDecoration(
                    color: Colors.indigo.shade300,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  weekendStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.now(),
                focusedDay: importDateTime,
                currentDay: importDateTime,
                calendarFormat: calendarFormat,
                availableCalendarFormats: availableCalendarFormats,
                onDaySelected: onDaySelected,
                onFormatChanged: onFormatChanged,
                onPageChanged: onPageChanged,
              ),
            ),
            SpaceHeight(height: smallSpace),
          ],
        );
      },
    );
  }
}

class DotRow extends StatelessWidget {
  DotRow({super.key, required this.row});

  List<String?> row;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((name) {
        Color color = name != null
            ? tagColors[name]!['textColor']!
            : dialogBackgroundColor;
        return Row(
          children: [Dot(size: 5, color: color), SpaceWidth(width: 3)],
        );
      }).toList(),
    );
  }
}

class YearContainer extends StatelessWidget {
  YearContainer({
    super.key,
    required this.initialSelectedDate,
    required this.onSelectionChanged,
  });

  DateTime initialSelectedDate;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      width: MediaQuery.of(context).size.width,
      contentsWidget: SfDateRangePicker(
        initialSelectedDate: initialSelectedDate,
        maxDate: DateTime.now(),
        view: DateRangePickerView.decade,
        allowViewNavigation: false,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}

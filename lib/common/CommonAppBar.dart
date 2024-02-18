import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
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
import 'package:flutter_app_weight_management/utils/variable.dart';
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
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String? calendarFormat = user.calendarFormat;
    String? calendarMaker = user.calendarMaker;

    onFormatChanged(CalendarFormat format) {
      user.calendarFormat = format.toString();
      user.save();
    }

    onTapMakerType(CalendarMaker maker) {
      user.calendarMaker = maker.toString();
      user.save();
    }

    return Column(
      children: [
        CommonTitle(
          index: widget.id.index,
          calendarFormat: formatInfo[calendarFormat]!,
          calendarMaker: makerInfo[calendarMaker]!,
          onFormatChanged: onFormatChanged,
          onTapMakerType: onTapMakerType,
        ),
        SpaceHeight(height: tinySpace),
        widget.id.index == 0
            ? CalendarBar(
                calendarFormat: formatInfo[calendarFormat]!,
                calendarMaker: makerInfo[calendarMaker]!,
                onFormatChanged: onFormatChanged,
              )
            : const EmptyArea(),
      ],
    );
  }
}

class CommonTitle extends StatelessWidget {
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
  Widget build(BuildContext context) {
    DateTime titleDateTime = context.watch<TitleDateTimeProvider>().dateTime();
    DateTime historyDateTime =
        context.watch<HistoryDateTimeProvider>().dateTime();
    HistoryFilter historyFilter =
        context.watch<HistoryFilterProvider>().value();
    UserBox user = userRepository.user;
    List<String>? displayList = user.displayList;
    String locale = context.locale.toString();

    String title = [
      ym(locale: locale, dateTime: titleDateTime),
      y(locale: locale, dateTime: historyDateTime),
      '체중 변화',
      '설정'
    ][index];

    bool isRecord = index == 0;
    bool isHistory = index == 1;
    bool isGraph = index == 2;

    onTapRecordDateTime(args) {
      context.read<TitleDateTimeProvider>().setTitleDateTime(args.value);
      context.read<ImportDateTimeProvider>().setImportDateTime(args.value);

      user.calendarFormat = CalendarFormat.month.toString();
      user.save();

      closeDialog(context);
    }

    onTapHistoryDateTime(args) {
      context.read<HistoryDateTimeProvider>().setHistoryDateTime(args.value);
      closeDialog(context);
    }

    onTapRecordTitle() {
      showDialog(
        context: context,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              backgroundColor: dialogBackgroundColor,
              shape: containerBorderRadious,
              title: DialogTitle(
                text: '월 선택',
                onTap: () => closeDialog(context),
              ),
              content: DatePicker(
                view: DateRangePickerView.year,
                initialSelectedDate: titleDateTime,
                onSelectionChanged: onTapRecordDateTime,
              ),
            ),
          ],
        ),
      );
    }

    onTapHistoryTitle() {
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
                  text: '년도 선택',
                  onTap: () => closeDialog(context),
                ),
                content: DatePicker(
                  view: DateRangePickerView.decade,
                  initialSelectedDate: historyDateTime,
                  onSelectionChanged: onTapHistoryDateTime,
                ),
              ),
            ],
          );
        },
      );
    }

    onTapChangeYear() {
      context.read<HistoryFilterProvider>().setHistoryFilter(
            nextHistoryFilter[historyFilter]!,
          );
    }

    onTapFilter() async {
      await showDialog(
        context: context,
        builder: (context) => const DisplayListContainer(),
      );
    }

    List<IconData?> rightIconList = [
      Icons.keyboard_arrow_down_rounded,
      Icons.keyboard_arrow_down_rounded,
      null,
      null
    ];
    List<Null Function()?> onTapList = [
      onTapRecordTitle,
      onTapHistoryTitle,
      null,
      null
    ];

    return Padding(
      padding: isGraph
          ? EdgeInsets.fromLTRB(25, 0, 20, 0)
          : EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          index != 3
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BannerWidget(),
                )
              : const EmptyArea(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                isNotTr: isRecord || isHistory,
                text: title,
                size: 20,
                rightIcon: rightIconList[index],
                onTap: onTapList[index],
              ),
              Row(
                children: [
                  isRecord
                      ? Row(
                          children: [
                            CommonTag(
                              text: availableCalendarMaker[calendarMaker],
                              color: 'whiteIndigo',
                              onTap: () => onTapMakerType(
                                nextCalendarMaker[calendarMaker]!,
                              ),
                            ),
                            SpaceWidth(width: tinySpace),
                            CommonTag(
                              text: availableCalendarFormats[calendarFormat],
                              color: 'whiteIndigo',
                              onTap: () => onFormatChanged(
                                nextCalendarFormats[calendarFormat]!,
                              ),
                            ),
                            SpaceWidth(width: tinySpace),
                            CommonTag(
                              text: '표시',
                              nameArgs: {
                                'length': '${displayList?.length ?? 0}'
                              },
                              color: 'whiteIndigo',
                              onTap: onTapFilter,
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
                          onTap: onTapChangeYear,
                        )
                      : const EmptyArea(),
                ],
              )
            ],
          ),
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
    String? weightUnit = userRepository.user.weightUnit ?? 'kg';

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

      String? weight = colorName(
        recordInfo?.weight,
        'indigo',
      );
      String? picture = colorName(
        (recordInfo?.leftFile ??
            recordInfo?.rightFile ??
            recordInfo?.bottomFile),
        'purple',
      );
      String? diet = colorName(
        nullCheckAction(actions, dietType),
        'teal',
      );
      String? exercise = colorName(
        nullCheckAction(actions, exerciseType),
        'lightBlue',
      );
      String? life = colorName(
        nullCheckAction(actions, lifeType),
        'brown',
      );
      String? diary = colorName(
        (recordInfo?.whiteText ?? recordInfo?.emotion),
        'orange',
      );

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
          isNotTr: true,
          text: isWeight ? '${recordInfo?.weight}$weightUnit' : '',
          size: 8,
          color: Colors.black,
          isCenter: true,
        ),
      );
    }

    onPageChanged(DateTime dateTime) {
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
                locale: context.locale.toString(),
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
                    fontSize: 12,
                  ),
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

class DatePicker extends StatelessWidget {
  DatePicker({
    super.key,
    required this.view,
    required this.initialSelectedDate,
    required this.onSelectionChanged,
  });

  DateRangePickerView view;
  DateTime initialSelectedDate;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      width: MediaQuery.of(context).size.width,
      contentsWidget: SfDateRangePicker(
        showNavigationArrow: true,
        initialDisplayDate: initialSelectedDate,
        initialSelectedDate: initialSelectedDate,
        maxDate: DateTime.now(),
        view: view,
        allowViewNavigation: false,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}

class DisplayListContainer extends StatefulWidget {
  const DisplayListContainer({super.key});

  @override
  State<DisplayListContainer> createState() => _DisplayListContainerState();
}

class _DisplayListContainerState extends State<DisplayListContainer> {
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? displayList = user.displayList;

    onTapCheckBox({required dynamic id, required bool newValue}) {
      bool isNotWeight = displayClassList.first.id != id;
      bool isdisplayList = user.displayList != null;

      if (isNotWeight && isdisplayList) {
        newValue ? user.displayList!.add(id) : user.displayList!.remove(id);
        user.save();

        setState(() {});
      }
    }

    isCheck(String filterId) {
      if (displayClassList.first.id == filterId) {
        return true;
      }

      return displayList != null ? displayList.contains(filterId) : false;
    }

    List<Widget> children = displayClassList
        .map((data) => Column(
              children: [
                Row(
                  children: [
                    CommonCheckBox(
                      id: data.id,
                      isCheck: isCheck(data.id),
                      checkColor: themeColor,
                      onTap: onTapCheckBox,
                    ),
                    CommonText(text: data.name, size: 14, isNotTop: true),
                    SpaceWidth(width: 3),
                    displayClassList.first.id == data.id
                        ? CommonText(text: '(필수)', size: 10, color: Colors.red)
                        : const EmptyArea()
                  ],
                ),
                SpaceHeight(
                  height:
                      displayClassList.last.id == data.id ? 0.0 : smallSpace,
                ),
              ],
            ))
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          backgroundColor: dialogBackgroundColor,
          shape: containerBorderRadious,
          title: DialogTitle(
            text: '카테고리 표시',
            onTap: () => closeDialog(context),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ContentsBox(contentsWidget: Column(children: children)),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '사용하지 않는 카테고리는 체크 해제 하세요 :D'.tr(),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
// Column(
//                           children: [
//                             Transform.scale(
//                               scale: 0.8,
//                               child: CupertinoSwitch(
//                                 value: true,
//                                 onChanged: (bool value) {
//                                   //
//                                 },
//                               ),
//                             ),
//                             CommonText(
//                               text: '이전 기간',
//                               size: 10,
//                               color: themeColor,
//                               isBold: true,
//                             ),
//                           ],
//                         )
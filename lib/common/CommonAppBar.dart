import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/display/DisplayList.dart';
import 'package:flutter_app_weight_management/components/display/HistoryDisplayList.dart';
import 'package:flutter_app_weight_management/components/display/SearchDisplayList.dart';
import 'package:flutter_app_weight_management/components/dot/dot_row.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/search_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

String eHistoryList = HistoryFormat.list.toString();
String eHistoryCalendar = HistoryFormat.calendar.toString();

class CommonAppBar extends StatelessWidget {
  CommonAppBar({super.key, required this.id});

  BottomNavigationEnum id;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String? calendarFormat = user.calendarFormat;
    String? calendarMaker = user.calendarMaker;
    String? historyCalendarFormat = user.historyCalendarFormat;

    bool isRecord = id == BottomNavigationEnum.record;
    bool isHistory = id == BottomNavigationEnum.history;

    onFormatChanged(CalendarFormat format) {
      if (isRecord) {
        user.calendarFormat = format.toString();
      } else if (isHistory) {
        user.historyCalendarFormat = format.toString();
      }

      user.save();
    }

    onTapMakerType(CalendarMaker maker) {
      user.calendarMaker = maker.toString();
      user.save();
    }

    return Column(
      children: [
        CommonTitle(
          index: id.index,
          calendarFormat:
              formatInfo[isRecord ? calendarFormat : historyCalendarFormat]!,
          calendarMaker: makerInfo[
              isRecord ? calendarMaker : CalendarMaker.sticker.toString()]!,
          onFormatChanged: onFormatChanged,
          onTapMakerType: onTapMakerType,
        ),
        SpaceHeight(height: tinySpace),
        isRecord
            ? CalendarBar(
                bottomIndex: id.index,
                calendarFormat: formatInfo[calendarFormat]!,
                calendarMaker: makerInfo[calendarMaker]!,
                onFormatChanged: onFormatChanged,
              )
            : const EmptyArea(),
        (isHistory && user.historyForamt == eHistoryCalendar)
            ? CalendarBar(
                bottomIndex: id.index,
                calendarFormat: formatInfo[historyCalendarFormat]!,
                calendarMaker: CalendarMaker.sticker,
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
    String locale = context.locale.toString();
    UserBox user = userRepository.user;

    DateTime titleDateTime = context.watch<TitleDateTimeProvider>().dateTime();
    DateTime historyDateTime =
        context.watch<HistoryTitleDateTimeProvider>().dateTime();
    HistoryFilter historyFilter =
        context.watch<HistoryFilterProvider>().historyFilter;
    SearchFilter searchFilter =
        context.watch<SearchFilterProvider>().searchFilter;
    bool isPremium = context.watch<PremiumProvider>().premiumValue();

    List<String>? displayList = user.displayList;
    List<String>? historyDisplayList = user.historyDisplayList;
    List<String>? searchDisplayList = user.searchDisplayList;
    String historyFormat = user.historyForamt ?? eHistoryList;
    bool isHistoryList = historyFormat == eHistoryList;

    String title = [
      ym(locale: locale, dateTime: titleDateTime),
      historyFormat == eHistoryList
          ? y(locale: locale, dateTime: historyDateTime)
          : ym(locale: locale, dateTime: historyDateTime),
      '체중 변화',
      '검색',
      '설정'
    ][widget.index];
    String graphType = user.graphType ?? eGraphDefault;

    bool isRecord = widget.index == 0;
    bool isHistory = widget.index == 1;
    bool isGraph = widget.index == 2;
    bool isSearch = widget.index == 3;

    onTapRecordDateTime(args) {
      context.read<TitleDateTimeProvider>().setTitleDateTime(args.value);
      context.read<ImportDateTimeProvider>().setImportDateTime(args.value);

      user.calendarFormat = CalendarFormat.month.toString();
      user.save();

      closeDialog(context);
    }

    onTapHistoryDateTime(args) {
      context
          .read<HistoryTitleDateTimeProvider>()
          .setHistoryTitleDateTime(args.value);
      context
          .read<HistoryImportDateTimeProvider>()
          .setHistoryImportDateTime(args.value);

      if (!isHistoryList) {
        user.historyCalendarFormat = CalendarFormat.month.toString();
        user.save();
      }

      closeDialog(context);
    }

    onTapRecordTitle() {
      onShowDialog(
        context: context,
        title: '월 선택',
        view: DateRangePickerView.year,
        initialSelectedDate: titleDateTime,
        onSelectionChanged: onTapRecordDateTime,
      );
    }

    onTapHistoryTitle() {
      onShowDialog(
        context: context,
        title: isHistoryList ? '년도 선택' : '월 선택',
        view: isHistoryList
            ? DateRangePickerView.decade
            : DateRangePickerView.year,
        initialSelectedDate: historyDateTime,
        onSelectionChanged: onTapHistoryDateTime,
      );
    }

    onTapHistoryOrder() {
      context.read<HistoryFilterProvider>().setHistoryFilter(
            nextHistoryFilter[historyFilter]!,
          );
    }

    onTapSearchOrder() {
      context.read<SearchFilterProvider>().setSearchFilter(
            nextSearchFilter[searchFilter]!,
          );
    }

    onTapRecordFilter() async {
      await showDialog(
        context: context,
        builder: (context) => const DisplayList(),
      );
    }

    onTapHistoryFilter() async {
      await showDialog(
        context: context,
        builder: (context) => const HistoryDisplayList(),
      );
    }

    onTapHistoryFormat() async {
      user.historyForamt = isHistoryList ? eHistoryCalendar : eHistoryList;
      await user.save();
    }

    onShowBannerAd() {
      return widget.index != 4 && isPremium == false
          ? BannerWidget()
          : SpaceHeight(height: 10);
    }

    onTapGraphMode(String type) async {
      if (type == eGraphCustom && isPremium == false) {
        return showDialog(
          context: context,
          builder: (context) => CommonPopup(
            title: "커스텀 모드 제한",
            height: 145,
            buttonText: '프리미엄 구매 페이지로 이동',
            text1: '프리미엄 구매 시',
            text2: '커스텀 모드를 이용할 수 있어요.',
            onTap: () => Navigator.pushNamed(context, '/premium-page'),
          ),
        );
      }

      user.graphType = type;
      await user.save();
    }

    onTapSearchFilter() async {
      await showDialog(
        context: context,
        builder: (context) => const SearchDisplayList(),
      );
    }

    List<IconData?> rightIconList = [
      Icons.keyboard_arrow_down_rounded,
      Icons.keyboard_arrow_down_rounded,
      null,
      null,
      null
    ];
    List<Null Function()?> onTapList = [
      onTapRecordTitle,
      onTapHistoryTitle,
      null,
      null,
      null
    ];

    return Padding(
      padding: isGraph
          ? const EdgeInsets.fromLTRB(25, 0, 20, 0)
          : const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          onShowBannerAd(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                isNotTr: isRecord || isHistory,
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
                            CommonTag(
                              text:
                                  availableCalendarMaker[widget.calendarMaker],
                              color: 'whiteIndigo',
                              onTap: () => widget.onTapMakerType(
                                nextCalendarMaker[widget.calendarMaker]!,
                              ),
                            ),
                            SpaceWidth(width: tinySpace),
                            CommonTag(
                              text: availableCalendarFormats[
                                  widget.calendarFormat],
                              color: 'whiteIndigo',
                              onTap: () => widget.onFormatChanged(
                                nextCalendarFormats[widget.calendarFormat]!,
                              ),
                            ),
                            SpaceWidth(width: tinySpace),
                            CommonTag(
                              text: '표시',
                              nameArgs: {
                                'length': '${displayList?.length ?? 0}'
                              },
                              color: 'whiteIndigo',
                              onTap: onTapRecordFilter,
                            ),
                          ],
                        )
                      : const EmptyArea(),
                  isHistory
                      ? Row(
                          children: [
                            CommonTag(
                              text: isHistoryList ? '리스트' : '달력',
                              color: 'whiteIndigo',
                              onTap: onTapHistoryFormat,
                            ),
                            SpaceWidth(width: 5),
                            isHistoryList
                                ? CommonTag(
                                    text: historyFilterFormats[historyFilter],
                                    color: "whiteIndigo",
                                    onTap: onTapHistoryOrder,
                                  )
                                : CommonTag(
                                    text: availableCalendarFormats[
                                        widget.calendarFormat],
                                    color: 'whiteIndigo',
                                    onTap: () => widget.onFormatChanged(
                                      nextCalendarFormats[
                                          widget.calendarFormat]!,
                                    ),
                                  ),
                            SpaceWidth(width: 5),
                            CommonTag(
                              text: '표시',
                              color: 'whiteIndigo',
                              nameArgs: {
                                'length': '${historyDisplayList?.length ?? 0}'
                              },
                              onTap: onTapHistoryFilter,
                            ),
                          ],
                        )
                      : const EmptyArea(),
                  isGraph
                      ? CommonTag(
                          text: graphType == eGraphDefault ? '기본 모드' : '커스텀 모드',
                          color: 'whiteIndigo',
                          onTap: () => onTapGraphMode(
                            graphType == eGraphDefault
                                ? eGraphCustom
                                : eGraphDefault,
                          ),
                        )
                      : const EmptyArea(),
                  isSearch
                      ? Row(
                          children: [
                            CommonTag(
                              text: searchFilterFormats[searchFilter],
                              color: 'whiteIndigo',
                              onTap: onTapSearchOrder,
                            ),
                            SpaceWidth(width: 5),
                            CommonTag(
                              text: '표시',
                              color: 'whiteIndigo',
                              nameArgs: {
                                'length': '${searchDisplayList?.length ?? 0}'
                              },
                              onTap: onTapSearchFilter,
                            ),
                          ],
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

class CalendarBar extends StatelessWidget {
  CalendarBar({
    super.key,
    required this.bottomIndex,
    required this.calendarFormat,
    required this.calendarMaker,
    required this.onFormatChanged,
  });

  int bottomIndex;
  CalendarFormat calendarFormat;
  CalendarMaker calendarMaker;
  Function(CalendarFormat) onFormatChanged;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    String? weightUnit = userRepository.user.weightUnit ?? 'kg';
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    DateTime historyImportDateTime = context
        .watch<HistoryImportDateTimeProvider>()
        .getHistoryImportDateTime();

    onDaySelected(selectedDay, _) {
      if (bottomIndex == 0) {
        context.read<ImportDateTimeProvider>().setImportDateTime(selectedDay);
        context.read<TitleDateTimeProvider>().setTitleDateTime(selectedDay);
      } else if (bottomIndex == 1) {
        context
            .read<HistoryImportDateTimeProvider>()
            .setHistoryImportDateTime(selectedDay);
        context
            .read<HistoryTitleDateTimeProvider>()
            .setHistoryTitleDateTime(selectedDay);
      }
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
      List<Map<String, String>>? hashTagList =
          (recordInfo?.recordHashTagList == null ||
                  recordInfo?.recordHashTagList?.length == 0)
              ? null
              : recordInfo?.recordHashTagList;

      String? weight = colorName(
        recordInfo?.weight,
        'indigo',
      );
      String? picture = colorName(
        (recordInfo?.leftFile ??
            recordInfo?.rightFile ??
            recordInfo?.bottomFile ??
            recordInfo?.topFile),
        'purple',
      );
      String? diet = colorName(
        nullCheckAction(actions, eDiet),
        'teal',
      );
      String? exercise = colorName(
        nullCheckAction(actions, eExercise),
        'lightBlue',
      );
      String? life = colorName(
        nullCheckAction(actions, eLife),
        'brown',
      );
      String? diary = colorName(
        (recordInfo?.whiteText ?? recordInfo?.emotion ?? hashTagList),
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

      return isWeight
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: CommonText(
                  text: '${recordInfo?.weight}$weightUnit',
                  size: 8.5,
                  color: Colors.white,
                  isCenter: true,
                  isNotTr: true,
                  isBold: true,
                ),
              ),
            )
          : const EmptyArea();
    }

    onPageChanged(DateTime dateTime) {
      if (bottomIndex == 0) {
        context.read<TitleDateTimeProvider>().setTitleDateTime(dateTime);
      } else if (bottomIndex == 1) {
        context
            .read<HistoryTitleDateTimeProvider>()
            .setHistoryTitleDateTime(dateTime);
      }
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: TableCalendar(
                locale: locale,
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
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: grey.original, fontSize: 13),
                  weekendStyle: TextStyle(color: grey.original, fontSize: 13),
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.now(),
                focusedDay:
                    bottomIndex == 0 ? importDateTime : historyImportDateTime,
                currentDay:
                    bottomIndex == 0 ? importDateTime : historyImportDateTime,
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

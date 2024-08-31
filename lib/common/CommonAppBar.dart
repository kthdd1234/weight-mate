import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/calendar/CalendarBar.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/etc/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/popup/CalendarMakerPopup.dart';
import 'package:flutter_app_weight_management/components/popup/DisplayPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/history_search_page.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/graph_category_provider.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/provider/tracker_filter_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

String eHistoryList = HistoryFormat.list.toString();
String eHistoryCalendar = HistoryFormat.calendar.toString();

class CommonAppBar extends StatelessWidget {
  CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;

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

    onTapMakerType() async {
      showDialog(
        context: context,
        builder: (context) => CalendarMakerPopup(),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CommonAppBarTitle(
            index: id.index,
            calendarFormat:
                formatInfo[isRecord ? calendarFormat : historyCalendarFormat]!,
            calendarMaker: makerInfo[calendarMaker]!,
            onFormatChanged: onFormatChanged,
            onTapMakerType: onTapMakerType,
          ),
        ),
        (isRecord || (isHistory && user.historyForamt == eHistoryCalendar))
            ? CalendarBar(
                bottomIndex: id.index,
                calendarFormat: formatInfo[calendarFormat]!,
                calendarMaker: makerInfo[calendarMaker]!,
                onFormatChanged: onFormatChanged,
              )
            : const EmptyArea(),
      ],
    );
  }
}

class CommonAppBarTitle extends StatefulWidget {
  CommonAppBarTitle({
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
  Function() onTapMakerType;

  @override
  State<CommonAppBarTitle> createState() => _CommonAppBarTitleState();
}

class _CommonAppBarTitleState extends State<CommonAppBarTitle> {
  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    DateTime titleDateTime = context.watch<TitleDateTimeProvider>().dateTime();
    DateTime historyDateTime =
        context.watch<HistoryTitleDateTimeProvider>().dateTime();
    HistoryFilter historyFilter =
        context.watch<HistoryFilterProvider>().historyFilter;
    TrackerFilter trackerFilter =
        context.watch<TrackerFilterProvider>().trackerFilter;

    bool isPremium = context.watch<PremiumProvider>().premiumValue();
    String graphCategory = context.watch<GraphCategoryProvider>().graphCategory;

    UserBox user = userRepository.user;
    List<String>? displayList = user.displayList;
    List<String>? historyDisplayList = user.historyDisplayList;
    List<String>? trackerDisplayList = user.trackerDisplayList;

    String historyFormat = user.historyForamt ?? eHistoryList;
    bool isHistoryList = historyFormat == eHistoryList;
    String graphType = user.graphType ?? eGraphDefault;

    String title = [
      ym(locale: locale, dateTime: titleDateTime),
      historyFormat == eHistoryList
          ? y(locale: locale, dateTime: historyDateTime)
          : ym(locale: locale, dateTime: historyDateTime),
      '그래프',
      '트래커',
      '설정'
    ][widget.index];

    bool isRecord = widget.index == 0;
    bool isHistory = widget.index == 1;
    bool isGraph = widget.index == 2;
    bool isTracker = widget.index == 3;

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
      onShowDateTimeDialog(
        context: context,
        view: DateRangePickerView.year,
        initialSelectedDate: titleDateTime,
        onSelectionChanged: onTapRecordDateTime,
      );
    }

    onTapHistoryTitle() {
      onShowDateTimeDialog(
        context: context,
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

    onTapRecordFilter() async {
      await showDialog(
        context: context,
        builder: (context) => DisplayPopup(
          height: 360,
          isRequiredWeight: true,
          bottomText: '사용하지 않는 카테고리는 체크 해제 하세요 :D'.tr(),
          classList: displayClassList,
          onChecked: (String filterId) {
            if (displayClassList.first.id == filterId) {
              return true;
            }

            return displayList != null ? displayList.contains(filterId) : false;
          },
          onTap: ({required dynamic id, required bool newValue}) {
            bool isNotWeight = displayClassList.first.id != id;
            bool isdisplayList = user.displayList != null;

            if (isNotWeight && isdisplayList) {
              newValue
                  ? user.displayList!.add(id)
                  : user.displayList!.remove(id);
              user.save();
              setState(() {});
            }
          },
        ),
      );
    }

    onTapHistoryFilter() async {
      await showDialog(
        context: context,
        builder: (context) => DisplayPopup(
          height: 475,
          isRequiredWeight: false,
          bottomText: '표시하고 싶지 않은 카테고리는 체크 해제 하세요 :D'.tr(),
          classList: historyDisplayClassList,
          onChecked: (String filterId) {
            return historyDisplayList != null
                ? historyDisplayList.contains(filterId)
                : false;
          },
          onTap: ({required dynamic id, required bool newValue}) {
            bool ishistoryDisplayList = user.historyDisplayList != null;

            if (ishistoryDisplayList) {
              newValue
                  ? user.historyDisplayList!.add(id)
                  : user.historyDisplayList!.remove(id);

              user.save();
              setState(() {});
            }
          },
        ),
      );
    }

    onTapTrackerFilter() async {
      await showDialog(
        context: context,
        builder: (context) => DisplayPopup(
          isRequiredWeight: false,
          bottomText: '표시하고 싶지 않은 카테고리는 체크 해제 하세요 :D'.tr(),
          classList: trackerDisplayClassList,
          height: 320,
          onChecked: (String filterId) {
            return trackerDisplayList != null
                ? trackerDisplayList.contains(filterId)
                : false;
          },
          onTap: ({required dynamic id, required bool newValue}) {
            bool isTrackerDisplayList = user.trackerDisplayList != null;

            if (isTrackerDisplayList) {
              newValue
                  ? user.trackerDisplayList!.add(id)
                  : user.trackerDisplayList!.remove(id);

              user.save();
              setState(() {});
            }
          },
        ),
      );
    }

    onTapHistoryFormat() async {
      user.historyForamt = isHistoryList ? eHistoryCalendar : eHistoryList;
      await user.save();
    }

    Widget onShowBannerAd() {
      return widget.index != 4 && isPremium == false
          ? BannerWidget()
          : SpaceHeight(height: 10);
    }

    onTapGraphCategory(String category) {
      if (Platform.isIOS) {
        context.read<GraphCategoryProvider>().setGraphCategory(category);
      }
    }

    onTapGraphMode(String type) async {
      if (type == eGraphCustom && isPremium == false) {
        return showDialog(
          context: context,
          builder: (context) => AlertPopup(
            height: 185,
            buttonText: '프리미엄 구매 페이지로 이동',
            text1: '프리미엄 구매 시',
            text2: '설정 그래프를 이용할 수 있어요.',
            onTap: () => Navigator.pushNamed(context, '/premium-page'),
          ),
        );
      }

      user.graphType = type;
      await user.save();
    }

    onTapHistorySearch() {
      navigator(context: context, page: HistorySearchPage());
    }

    onTapTrackerOrder() {
      context
          .read<TrackerFilterProvider>()
          .setTrackerFilter(nextTrackerFilter[trackerFilter]!);
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
          : EdgeInsets.symmetric(horizontal: isTracker ? 20 : 25),
      child: Column(
        children: [
          SpaceHeight(height: 10),
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
                              onTap: widget.onTapMakerType,
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
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: CommonTag(
                                      text: historyFilterFormats[historyFilter],
                                      color: "whiteIndigo",
                                      onTap: onTapHistoryOrder,
                                    ),
                                  )
                                : EmptyArea(),
                            CommonTag(
                              text: '검색',
                              color: 'whiteIndigo',
                              onTap: onTapHistorySearch,
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
                      ? Row(
                          children: [
                            CommonTag(
                              text:
                                  graphCategory == cGraphWeight ? '체중' : '걸음 수',
                              color: graphCategory == cGraphWeight
                                  ? 'whiteIndigo'
                                  : 'whiteBlue',
                              onTap: () => onTapGraphCategory(
                                graphCategory == cGraphWeight
                                    ? cGraphWork
                                    : cGraphWeight,
                              ),
                            ),
                            SpaceWidth(width: 5),
                            CommonTag(
                              text: graphType == eGraphDefault
                                  ? '기본 그래프'
                                  : '설정 그래프',
                              color: 'whiteIndigo',
                              onTap: () => onTapGraphMode(
                                graphType == eGraphDefault
                                    ? eGraphCustom
                                    : eGraphDefault,
                              ),
                            ),
                          ],
                        )
                      : const EmptyArea(),
                  isTracker
                      ? Row(
                          children: [
                            CommonTag(
                              text: trackerFilterFormats[trackerFilter],
                              color: 'whiteIndigo',
                              onTap: onTapTrackerOrder,
                            ),
                            SpaceWidth(width: 5),
                            CommonTag(
                              text: '표시',
                              nameArgs: {
                                'length': '${trackerDisplayList?.length ?? 0}'
                              },
                              color: 'whiteIndigo',
                              onTap: onTapTrackerFilter,
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

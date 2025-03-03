import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/History_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class HistoryBody extends StatefulWidget {
  const HistoryBody({super.key});

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  @override
  void initState() {
    onWindowManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        UserBox user = userRepository.user;
        String? historyForamt = user.historyForamt;

        return Column(
          children: [
            CommonAppBar(),
            SpaceHeight(height: smallSpace),
            historyForamt == HistoryFormat.list.toString()
                ? HistoryListView()
                : HistoryCalendar(),
          ],
        );
      },
    );
  }
}

class HistoryListView extends StatelessWidget {
  HistoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime historyDateTime =
        context.watch<HistoryTitleDateTimeProvider>().dateTime();
    HistoryFilter historyFilter =
        context.watch<HistoryFilterProvider>().historyFilter;

    List<RecordBox> recordList = recordRepository.recordList;
    recordList = recordList
        .where((e) => e.createDateTime.year == historyDateTime.year)
        .toList();
    recordList = HistoryFilter.recent == historyFilter
        ? recordList.reversed.toList()
        : recordList;

    return Expanded(
      child: recordList.isEmpty
          ? EmptyTextVerticalArea(
              icon: Icons.menu_book_rounded,
              title: '기록이 없어요.',
              backgroundColor: Colors.transparent,
            )
          : ListView(
              children: recordList
                  .map(
                    (recordInfo) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: ContentsBox(
                            contentsWidget: HistoryContainer(
                              recordInfo: recordInfo,
                              isRemoveMode: false,
                            ),
                          ),
                        ),
                        SpaceHeight(height: smallSpace),
                      ],
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class HistoryCalendar extends StatelessWidget {
  HistoryCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime historyImportDateTime = context
        .watch<HistoryImportDateTimeProvider>()
        .getHistoryImportDateTime();
    int recordKey = getDateTimeToInt(historyImportDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);

    onHorizontalDragEnd(DragEndDetails dragEndDetails) {
      double? primaryVelocity = dragEndDetails.primaryVelocity;
      DateTime dateTime = historyImportDateTime;

      if (primaryVelocity == null) {
        return;
      } else if (primaryVelocity > 0) {
        dateTime = historyImportDateTime.subtract(Duration(days: 1));
      } else if (primaryVelocity < 0) {
        dateTime = historyImportDateTime.add(Duration(days: 1));
      }

      context
          .read<HistoryImportDateTimeProvider>()
          .setHistoryImportDateTime(dateTime);
    }

    return Expanded(
      child: GestureDetector(
        onHorizontalDragEnd: onHorizontalDragEnd,
        child: recordInfo != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: ContentsBox(
                    contentsWidget: HistoryContainer(
                      recordInfo: recordInfo,
                      isRemoveMode: false,
                    ),
                  ),
                ),
              )
            : EmptyTextVerticalArea(
                icon: Icons.view_timeline_outlined,
                title: '기록이 없어요.',
                backgroundColor: Colors.transparent,
              ),
      ),
    );
  }
}

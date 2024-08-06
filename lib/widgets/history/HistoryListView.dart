import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryCotainer.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatelessWidget {
  HistoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPremium = context.watch<PremiumProvider>().isPremium;
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

    if (isPremium == false) {
      if (recordList.isNotEmpty) {
        for (var i = 0; i < recordList.length; i++) {
          if (i != 0 && i % 6 == 0) {
            recordList.insert(i, RecordBox(createDateTime: DateTime(1000)));
          }
        }
      }
    }

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
                            child: HistoryContainer(
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

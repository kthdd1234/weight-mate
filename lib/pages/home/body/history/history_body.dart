import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/History_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/dash_divider.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class HistoryBody extends StatelessWidget {
  const HistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime titleDateTime = context.watch<TitleDateTimeProvider>().dateTime();
    HistoryFilter historyFilter =
        context.watch<HistoryFilterProvider>().value();

    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        List<RecordBox> recordList = recordRepository.recordBox.values.toList();
        recordList = recordList
            .where((e) => e.createDateTime.year == titleDateTime.year)
            .toList();
        recordList = HistoryFilter.recent == historyFilter
            ? recordList.reversed.toList()
            : recordList;

        if (recordList.isNotEmpty) {
          recordList.insert(1, RecordBox(createDateTime: DateTime(1000)));
        }

        return Column(
          children: [
            SpaceHeight(height: regularSapce),
            CommonAppBar(id: id),
            SpaceHeight(height: smallSpace),
            Expanded(
              child: recordList.isEmpty
                  ? EmptyTextVerticalArea(
                      icon: Icons.menu_book_rounded,
                      title: '기록한 내용이 없어요.',
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
                                    isBoxShadow: true,
                                    contentsWidget: HistoryContainer(
                                      recordInfo: recordInfo,
                                    ),
                                  ),
                                ),
                                SpaceHeight(height: smallSpace),
                                // DashDivider(color: Colors.grey.shade400)
                              ],
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
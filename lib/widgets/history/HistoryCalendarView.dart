import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryCotainer.dart';
import 'package:provider/provider.dart';

class HistoryCalendar extends StatelessWidget {
  HistoryCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime historyImportDateTime = context
        .watch<HistoryImportDateTimeProvider>()
        .getHistoryImportDateTime();
    int recordKey = getDateTimeToInt(historyImportDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);

    return Expanded(
      child: recordInfo != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: ContentsBox(
                  child: HistoryContainer(
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
    );
  }
}

import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/maker/WeightMaker.dart';
import 'package:flutter_app_weight_management/components/maker/stickerMaker.dart';
import 'package:flutter_app_weight_management/pages/common/image_collections_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

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

      return StickerMaker(row1: row1, row2: row2);
    }

    weightBuilder(context, day, events) {
      int recordKey = getDateTimeToInt(day);
      RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
      bool? isWeight = recordInfo?.weight != null;

      return isWeight
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: WeightMaker(
                weight: recordInfo?.weight ?? 0.0,
                weightUnit: weightUnit,
              ))
          : const EmptyArea();
    }

    pictureBuildler(context, DateTime dateTime, events) {
      int recordKey = getDateTimeToInt(dateTime);
      RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
      Uint8List? unit8List = recordInfo?.leftFile ??
          recordInfo?.rightFile ??
          recordInfo?.bottomFile ??
          recordInfo?.topFile;

      bool isToday = getDateTimeToInt(importDateTime) == recordKey;

      if (unit8List == null) {
        return const EmptyArea();
      }

      return Stack(
        children: [
          Center(
            child: DefaultImage(
              unit8List: unit8List,
              width: 38,
              height: 38,
              borderRadius: 7,
            ),
          ),
          Center(child: MaskLabel(width: 38, height: 38, opacity: 0.2)),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isToday ? indigo.s300 : null,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CommonName(
                text: '${dateTime.day}',
                isNotTr: true,
                color: Colors.white,
                isBold: true,
              ),
            ),
          ),
        ],
      );
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

    final builderInfo = {
      CalendarMaker.sticker: stickerBuilder,
      CalendarMaker.weight: weightBuilder,
      CalendarMaker.picture: pictureBuildler,
    };

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
                  markerBuilder: builderInfo[calendarMaker],
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

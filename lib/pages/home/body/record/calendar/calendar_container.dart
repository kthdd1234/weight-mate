import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

final availableCalendarFormats = {
  CalendarFormat.month: '1개월',
  CalendarFormat.week: '1주일'
};

String dietType = PlanTypeEnum.diet.toString();
String exerciseType = PlanTypeEnum.exercise.toString();
String lifeType = PlanTypeEnum.lifestyle.toString();

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({super.key});

  @override
  State<CalendarContainer> createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    onDaySelected(selectedDay, _) {
      context.read<ImportDateTimeProvider>().setImportDateTime(selectedDay);
    }

    onFormatChanged(CalendarFormat format) {
      setState(() => calendarFormat = format);
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

    markerBuilder(context, day, events) {
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

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: TableCalendar(
            locale: 'ko-KR',
            calendarBuilders: CalendarBuilders(markerBuilder: markerBuilder),
            headerVisible: false,
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(15.0),
              // cellPadding: EdgeInsets.only(bottom: 5),
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
          ),
        ),
        SpaceHeight(height: smallSpace),
        Container(
          width: 35,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        SpaceHeight(height: smallSpace),
      ],
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

// class Dot extends StatelessWidget {
//   const Dot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(width: 5, height: ,);
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dot/dot_row.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/todo/GoalWidgets.dart';
import 'package:flutter_app_weight_management/components/weight/WeightChart.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:quiver/time.dart';
import 'package:table_calendar/table_calendar.dart';

class GoalMonthlyContainer extends StatefulWidget {
  GoalMonthlyContainer({super.key, required this.type});

  String type;

  @override
  State<GoalMonthlyContainer> createState() => _GoalMonthlyContainerState();
}

class _GoalMonthlyContainerState extends State<GoalMonthlyContainer> {
  DateTime selectedMonth = DateTime.now();
  DateTime seletedDay = DateTime.now();
  int selectedMonthActionCount = 0;
  bool isPremium = false;

  @override
  void initState() {
    DateTime now = DateTime.now();
    selectedMonthActionCount = getMonthActionCount(
      recordBox: recordRepository.recordBox,
      type: widget.type,
      year: now.year,
      month: now.month,
      lastDays: daysInMonth(now.year, now.month),
    );

    initPremium() async {
      isPremium = await isPurchasePremium();
      setState(() {});
    }

    initPremium();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String locale = context.locale.toString();
    List<Map<String, dynamic>> filterActions = getFilterActions(
      dateTime: seletedDay,
      recordBox: recordRepository.recordBox,
      type: widget.type,
    );
    List<String> orderList = {
      eDiet: user.dietOrderList,
      eExercise: user.exerciseOrderList,
      eLife: user.lifeOrderList,
    }[widget.type]!;

    filterActions.sort((act1, act2) {
      int order1 = orderList.indexOf(act1['id']);
      int order2 = orderList.indexOf(act2['id']);

      return order1.compareTo(order2);
    });

    onPageChanged(DateTime dateTime) {
      int year = dateTime.year;
      int month = dateTime.month;
      int days = daysInMonth(year, month);

      setState(() {
        selectedMonth = dateTime;
        selectedMonthActionCount = getMonthActionCount(
          year: year,
          month: month,
          lastDays: days,
          recordBox: recordRepository.recordBox,
          type: widget.type,
        );
      });
    }

    onDaySelected(sDay, _) {
      setState(() => seletedDay = sDay);
    }

    markerBuilder(context, day, events) {
      List<Map<String, dynamic>> filterDayActions = getFilterActions(
        dateTime: day,
        recordBox: recordRepository.recordBox,
        type: widget.type,
      );

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dot(size: 5, color: targetColors[day.weekday]!),
          SpaceWidth(width: 3),
          CommonText(
              text:
                  '${filterDayActions.isNotEmpty ? filterDayActions.length : '-'}',
              size: 8,
              isNotTr: true)
        ],
      );
    }

    return Expanded(
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            const RowColors(),
            TableCalendarHeader(
              locale: locale,
              selectedMonth: selectedMonth,
              text: '총 실천 회'
                  .tr(namedArgs: {'length': "$selectedMonthActionCount"}),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  TableCalendar(
                    locale: locale,
                    headerVisible: false,
                    focusedDay: selectedMonth,
                    currentDay: seletedDay,
                    calendarStyle: CalendarStyle(
                      cellMargin: const EdgeInsets.all(10.0),
                      todayDecoration: BoxDecoration(
                        color: targetColors[seletedDay.weekday]!,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    firstDay: DateTime(2000, 1, 1),
                    lastDay: DateTime.now(),
                    calendarBuilders:
                        CalendarBuilders(markerBuilder: markerBuilder),
                    onDaySelected: onDaySelected,
                    onPageChanged: onPageChanged,
                  ),
                  SpaceHeight(height: 5),
                  Divider(color: Colors.grey.shade300),
                  SpaceHeight(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonText(
                        text: d(locale: locale, dateTime: seletedDay) +
                            ' (${eShort(locale: locale, dateTime: seletedDay)})',
                        size: 15,
                        isNotTr: true,
                      ),
                      CommonText(
                        text: '실천 회',
                        size: 11,
                        color: Colors.grey,
                        nameArgs: {'length': '${filterActions.length}'},
                      ),
                    ],
                  ),
                  SpaceHeight(height: 10),
                  filterActions.isNotEmpty
                      ? Column(
                          children: filterActions
                              .map(
                                (action) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        VerticalBorder(seletedDay: seletedDay),
                                        SpaceWidth(width: 7),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              action['name'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(40),
                          child: EmptyWidget(
                            icon: todoData[widget.type]!.icon,
                            text: '실천이 없어요.',
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

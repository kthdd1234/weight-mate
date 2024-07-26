import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonBlur.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dot/dot_row.dart';
import 'package:flutter_app_weight_management/components/popup/CalendarRangePopup.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_chart_page.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:quiver/time.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

class GoalChartPage extends StatefulWidget {
  const GoalChartPage({super.key});

  @override
  State<GoalChartPage> createState() => _GoalChartPageState();
}

class _GoalChartPageState extends State<GoalChartPage> {
  SegmentedTypes selectedSegment = SegmentedTypes.week;

  @override
  Widget build(BuildContext context) {
    Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String type = args['type']!;
    String title = args['title']!;

    Map<SegmentedTypes, Widget> segmentedChildren = {
      SegmentedTypes.week: onSegmentedWidget(
        title: '일주일',
        type: SegmentedTypes.week,
        selected: selectedSegment,
      ),
      SegmentedTypes.month: onSegmentedWidget(
        title: '한달',
        type: SegmentedTypes.month,
        selected: selectedSegment,
      ),
    };

    onSegmentedChanged(SegmentedTypes? type) {
      setState(() => selectedSegment = type!);
    }

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo:
            AppBarInfoClass(title: ' 실천 모아보기', nameArgs: {'type': title.tr()}),
        body: Column(
          children: [
            selectedSegment == SegmentedTypes.week
                ? GoalWeeklyContainer(type: type)
                : GoalMonthlyContainer(type: type),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: DefaultSegmented(
                selectedSegment: selectedSegment,
                children: segmentedChildren,
                onSegmentedChanged: onSegmentedChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalWeeklyContainer extends StatefulWidget {
  GoalWeeklyContainer({super.key, required this.type});

  String type;

  @override
  State<GoalWeeklyContainer> createState() => _GoalWeeklyContainerState();
}

class _GoalWeeklyContainerState extends State<GoalWeeklyContainer> {
  DateTime startDateTime = weeklyStartDateTime(DateTime.now());
  DateTime endDateTime = weeklyEndDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      DateTime rangeStartDate = args.value.startDate;
      DateTime sDateTime = weeklyStartDateTime(rangeStartDate);
      DateTime eDateTime = weeklyEndDateTime(rangeStartDate);

      setState(() {
        startDateTime = sDateTime;
        endDateTime = eDateTime;
      });

      closeDialog(context);
    }

    onTapWeeklyDateTime() {
      showDialog(
        context: context,
        builder: (context) => CalendarRangePopup(
          startAndEndDateTime: [startDateTime, endDateTime],
          onSelectionChanged: onSelectionChanged,
        ),
      );
    }

    return Expanded(
      child: Stack(
        children: [
          ContentsBox(
            contentsWidget: Column(
              children: [
                const RowColors(),
                DateTimeTag(
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                  onTapWeeklyDateTime: onTapWeeklyDateTime,
                ),
                RowTitles(type: widget.type),
                ColumnItmeList(type: widget.type, startDateTime: startDateTime),
              ],
            ),
          ),
          CommonBlur()
        ],
      ),
    );
  }
}

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
      child: Stack(
        children: [
          ContentsBox(
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
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            VerticalBorder(
                                                seletedDay: seletedDay),
                                            SpaceWidth(width: 7),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
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
          CommonBlur()
        ],
      ),
    );
  }
}

class TableCalendarHeader extends StatelessWidget {
  TableCalendarHeader({
    super.key,
    required this.locale,
    required this.selectedMonth,
    required this.text,
    this.leftIcon,
    this.iconColor,
    this.textColor,
  });

  String locale, text;
  DateTime selectedMonth;
  IconData? leftIcon;
  Color? iconColor, textColor;

  @override
  Widget build(BuildContext context) {
    onText({
      required String text,
      required double size,
      required Color color,
      IconData? lIcon,
      Color? iColor,
    }) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: CommonText(
          text: text,
          size: size,
          color: color,
          isNotTr: true,
          leftIcon: lIcon,
          iconColor: iColor,
          iconSize: 10,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          onText(
            text: ym(locale: locale, dateTime: selectedMonth),
            size: 18,
            color: Colors.black,
          ),
          onText(
            text: text,
            size: 12,
            color: textColor ?? Colors.grey,
            lIcon: leftIcon,
            iColor: iconColor,
          ),
        ],
      ),
    );
  }
}

class VerticalBorder extends StatelessWidget {
  const VerticalBorder({super.key, required this.seletedDay});

  final DateTime seletedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: double.infinity,
      decoration: BoxDecoration(
        color: targetColors[seletedDay.weekday]!,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(2),
          bottom: Radius.circular(2),
        ),
      ),
    );
  }
}

class DateTimeTag extends StatelessWidget {
  DateTimeTag({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    required this.onTapWeeklyDateTime,
  });

  DateTime startDateTime;
  DateTime endDateTime;
  Function() onTapWeeklyDateTime;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonTag(
            text:
                '${mde(locale: locale, dateTime: startDateTime)} ~ ${mde(locale: locale, dateTime: endDateTime)}',
            color: 'whiteIndigo',
            isNotTr: true,
            onTap: onTapWeeklyDateTime,
          ),
        ],
      ),
    );
  }
}

class RowColors extends StatelessWidget {
  const RowColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: dayColors
          .map((item) => Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 0, 10),
                child: CommonText(
                  text: item.type,
                  size: 10,
                  leftIcon: Icons.circle,
                  iconColor: item.color,
                ),
              ))
          .toList(),
    );
  }
}

class RowTitles extends StatelessWidget {
  RowTitles({super.key, required this.type});

  String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
                text: type == eLife ? '습관' : '목표',
                size: 13,
                color: grey.original),
            Row(
              children: dayColors
                  .map((day) => Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CommonText(
                          text: day.type,
                          size: 13,
                          color: grey.original,
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
        Divider(color: Colors.grey.shade200)
      ],
    );
  }
}

class ColumnItmeList extends StatelessWidget {
  ColumnItmeList({super.key, required this.type, required this.startDateTime});

  String type;
  DateTime startDateTime;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<PlanBox> planList = planRepository.planBox.values.toList();
    List<PlanBox> typeList =
        planList.where((plan) => plan.type == type).toList();
    List<TargetDayClass> targetDays = List.generate(
        dayColors.length,
        (index) => TargetDayClass(
              color: dayColors[index].color,
              dateTime: startDateTime.add(Duration(days: index)),
            )).toList();
    List<String> orderList = {
      eDiet: user.dietOrderList,
      eExercise: user.exerciseOrderList,
      eLife: user.lifeOrderList,
    }[type]!;

    typeList.sort((plan1, plan2) {
      int order1 = orderList.indexOf(plan1.id);
      int order2 = orderList.indexOf(plan2.id);

      return order1.compareTo(order2);
    });

    onTargetColor({required String planId, required TargetDayClass target}) {
      int recordKey = getDateTimeToInt(target.dateTime);
      RecordBox? record = recordRepository.recordBox.get(recordKey);

      if (record?.actions == null) {
        return whiteBgBtnColor;
      }

      return record!.actions!.any((action) => action['id'] == planId)
          ? target.color
          : whiteBgBtnColor;
    }

    return Expanded(
      child: typeList.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              children: typeList
                  .map((plan) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  plan.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: textColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: targetDays
                                      .map((target) => Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: CommonIcon(
                                              icon: Icons.circle,
                                              size: 11.6,
                                              color: onTargetColor(
                                                  planId: plan.id,
                                                  target: target),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              )
                            ],
                          ),
                          Divider(color: Colors.grey.shade200)
                        ],
                      ))
                  .toList(),
            )
          : EmptyWidget(
              icon: todoData[type]!.icon,
              text:
                  '${type == eLife ? '습관' : '목표'}${type == eLife ? '이' : '가'} 없어요.',
            ),
    );
  }
}

class TargetDayClass {
  TargetDayClass({required this.color, required this.dateTime});

  Color color;
  DateTime dateTime;
}

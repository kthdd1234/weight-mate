import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_range_dialog.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GoalChartPage extends StatefulWidget {
  const GoalChartPage({super.key});

  @override
  State<GoalChartPage> createState() => _GoalChartPageState();
}

class _GoalChartPageState extends State<GoalChartPage> {
  DateTime startDateTime = weeklyStartDateTime(DateTime.now());
  DateTime endDateTime = weeklyEndDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String type = args['type']!;
    String title = args['title']!;

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

    onSubmit(Object? obj) {
      //
    }

    onCancel() {
      //
    }

    onTapWeeklyDateTime() {
      showDialog(
        context: context,
        builder: (context) => CalenderRangeDialog(
          title: '주 선택',
          startAndEndDateTime: [startDateTime, endDateTime],
          onSelectionChanged: onSelectionChanged,
          onSubmit: onSubmit,
          onCancel: onCancel,
        ),
      );
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '$title 체크표'.tr(),
            style: const TextStyle(fontSize: 20, color: themeColor),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          elevation: 0.0,
          actions: [
            CommonTag(
              text:
                  '${mde(locale: locale, dateTime: startDateTime)} ~ ${mde(locale: locale, dateTime: endDateTime)}',
              color: 'whiteIndigo',
              isNotTr: true,
              onTap: onTapWeeklyDateTime,
            ),
            SpaceWidth(width: 15),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ContentsBox(
              contentsWidget: Column(
                children: [
                  const RowColors(),
                  const RowTitles(),
                  ColumnItmeList(type: type, startDateTime: startDateTime),
                ],
              ),
            ),
          ),
        ),
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
                padding: const EdgeInsets.fromLTRB(7, 0, 0, 7),
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
  const RowTitles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(text: '목표', size: 13),
            Row(
              children: dayColors
                  .map((day) => Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CommonText(
                          text: day.type,
                          size: 13,
                          color: Colors.grey,
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
            dateTime: startDateTime.add(Duration(days: index)))).toList();
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
        return dialogBackgroundColor;
      }

      return record!.actions!.any((action) => action['id'] == planId)
          ? target.color
          : dialogBackgroundColor;
    }

    return Column(
      children: typeList
          .map((plan) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                              fontSize: 11,
                              color: themeColor,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: targetDays
                              .map((target) => Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: CommonIcon(
                                      icon: Icons.circle,
                                      size: 11.6,
                                      color: onTargetColor(
                                          planId: plan.id, target: target),
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
    );
  }
}

class TargetDayClass {
  TargetDayClass({required this.color, required this.dateTime});

  Color color;
  DateTime dateTime;
}

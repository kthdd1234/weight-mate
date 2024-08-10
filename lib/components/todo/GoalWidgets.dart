import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/weight/WeightChart.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

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

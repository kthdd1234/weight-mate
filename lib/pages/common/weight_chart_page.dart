import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonBlur.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class WeightChartPage extends StatefulWidget {
  const WeightChartPage({super.key});

  @override
  State<WeightChartPage> createState() => _WeightChartPageState();
}

class _WeightChartPageState extends State<WeightChartPage> {
  DateTime selectedYear = DateTime.now();
  bool isRecent = true;
  bool isPremium = false;

  @override
  void initState() {
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
    String? weightUnit = user.weightUnit;
    List<String> columnTitles = ['기록 날짜', '체중()', '이전과 비교'];

    onTapYear() {
      showDialogDateTimeYear(
        context: context,
        initialSelectedDate: selectedYear,
        onDateTime: (DateTime dateTime) {
          setState(() => selectedYear = dateTime);
        },
      );
    }

    onTapOrder() {
      setState(() => isRecent = !isRecent);
    }

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '체중 통계표', actions: [
          RowTags(
            selectedYear: selectedYear,
            isRecent: isRecent,
            onTapYear: onTapYear,
            onTapOrder: onTapOrder,
          )
        ]),
        body: Stack(
          children: [
            ContentsBox(
              contentsWidget: Column(
                children: [
                  Row(
                    children: columnTitles
                        .map((title) => RowTitles(
                            title: title,
                            nameArgs: title == '체중()'
                                ? {'unit': '$weightUnit'}
                                : null))
                        .toList(),
                  ),
                  ColumnItemList(
                    weightUnit: weightUnit,
                    selectedYear: selectedYear,
                    isRecent: isRecent,
                  )
                ],
              ),
            ),
            CommonBlur(),
          ],
        ),
      ),
    );
  }
}

class RowTitles extends StatelessWidget {
  RowTitles({super.key, required this.title, this.nameArgs});

  String title;
  Map<String, String>? nameArgs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CommonText(text: title, size: 13, isCenter: true, nameArgs: nameArgs),
          Divider(color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class RowTags extends StatelessWidget {
  RowTags({
    super.key,
    required this.selectedYear,
    required this.isRecent,
    required this.onTapOrder,
    required this.onTapYear,
  });

  DateTime selectedYear;
  bool isRecent;
  Function() onTapYear;
  Function() onTapOrder;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonTag(
            color: 'whiteIndigo',
            text: y(locale: locale, dateTime: selectedYear),
            isNotTr: true,
            onTap: onTapYear,
          ),
          SpaceWidth(width: 5),
          CommonTag(
            color: isRecent ? 'whiteBlue' : 'whiteRed',
            text: isRecent ? '최신순' : '과거순',
            onTap: onTapOrder,
          ),
        ],
      ),
    );
  }
}

class ColumnItemList extends StatelessWidget {
  ColumnItemList({
    super.key,
    required this.weightUnit,
    required this.selectedYear,
    required this.isRecent,
  });

  String? weightUnit;
  DateTime selectedYear;
  bool isRecent;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    List<RecordBox> recordList = recordRepository.recordBox.values.toList();
    List<RecordBox> weightList =
        recordList.where((item) => item.weight != null).toList();
    List<RecordBox> yearList = weightList
        .where(
            (record) => yToInt(record.createDateTime) == yToInt(selectedYear))
        .toList();
    List<RecordBox> orderList =
        isRecent ? yearList.reversed.toList() : yearList;

    onDateTime(RecordBox item, int? bIdx) {
      return CommonText(
        text: mde(locale: locale, dateTime: item.createDateTime),
        size: 13,
        isCenter: true,
        isNotTr: true,
      );
    }

    onAmountOfChange(RecordBox item, int? bIdx) {
      String text = '';
      IconData? leftIcon;
      Color? color;

      if (bIdx == null || bIdx == -1 || bIdx >= orderList.length) {
        text = '0.0';
      } else {
        double? cWeight = item.weight;
        double? bWeight = orderList[bIdx].weight;

        if (cWeight != null && bWeight != null) {
          double resultWeight = cWeight - bWeight;
          String fixedWeight = resultWeight.abs().toStringAsFixed(1);

          if (cWeight == bWeight) {
            text = '0.0';
          } else if (cWeight > bWeight) {
            leftIcon = Icons.arrow_drop_up;
            color = Colors.red;
            text = fixedWeight;
          } else if (cWeight < bWeight) {
            leftIcon = Icons.arrow_drop_down;
            color = Colors.green;
            text = fixedWeight;
          }
        }
      }

      return CommonText(
        text: text,
        size: 13,
        isCenter: true,
        isNotTr: true,
        leftIcon: leftIcon,
        iconSize: 21,
        color: color,
      );
    }

    onWeight(RecordBox item, int? bIdx) {
      return CommonText(
        text: '${item.weight}',
        size: 13,
        isCenter: true,
        isNotTr: true,
        isBold: true,
      );
    }

    return Expanded(
        child: orderList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (ctx, idx) {
                  RecordBox item = orderList[idx];
                  int orderId = (idx + (isRecent ? 1 : -1));

                  return Column(
                    children: [
                      Row(
                        children: [
                          onDateTime(item, null),
                          onWeight(item, null),
                          onAmountOfChange(item, orderId)
                        ]
                            .map(
                              (child) => Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: child,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Divider(color: Colors.grey.shade200),
                    ],
                  );
                },
              )
            : EmptyWidget(icon: Icons.monitor_weight, text: '기록이 없어요.'));
  }
}

class EmptyWidget extends StatelessWidget {
  EmptyWidget({super.key, required this.icon, required this.text});

  IconData icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonIcon(icon: icon, size: 30, color: grey.original),
        SpaceHeight(height: 10),
        CommonText(text: text, size: 15, isCenter: true, color: grey.original)
      ],
    );
  }
}

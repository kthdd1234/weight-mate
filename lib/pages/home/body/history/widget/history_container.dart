import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/dash_divider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';

class HistoryContainer extends StatelessWidget {
  HistoryContainer({
    super.key,
    required this.recordInfo,
  });

  RecordBox recordInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceHeight(height: 15),
        HistoryHeader(
          createDateTime: recordInfo.createDateTime,
          weight: recordInfo.weight,
          emotion: recordInfo.emotion,
        ),
        HistoryPicture(
          leftFile: recordInfo.leftFile,
          rightFile: recordInfo.rightFile,
        ),
        HistoryTodo(
          actions: recordInfo.actions,
          createDateTime: recordInfo.createDateTime,
        ),
        HistoryDiary(
          whiteText: recordInfo.whiteText,
          diaryDateTime: recordInfo.diaryDateTime,
        ),
      ],
    );
  }
}

class HistoryHeader extends StatelessWidget {
  HistoryHeader({
    super.key,
    required this.createDateTime,
    required this.weight,
    required this.emotion,
  });

  DateTime createDateTime;
  double? weight;
  String? emotion;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;

    return Column(
      children: [
        Row(
          children: [
            emotion != null
                ? Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svgs/$emotion.svg'),
                        SpaceWidth(width: smallSpace),
                      ],
                    ),
                  )
                : const EmptyArea(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonText(
                        text: dateTimeFormatter(
                          format: 'M월 d일 (E)',
                          dateTime: createDateTime,
                        ),
                        size: 11,
                        isBold: true,
                      ),
                      Spacer(),
                      CommonIcon(icon: Icons.more_vert_rounded, size: 16)
                    ],
                  ),
                  SpaceHeight(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonText(
                        text: '${weight ?? '-'}kg',
                        size: 17,
                      ),
                      Spacer(),
                      CommonText(
                        text: 'BMI ${bmi(tall: user.tall, weight: weight)}',
                        size: 9,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        SpaceHeight(height: 15),
      ],
    );
  }
}

class HistoryPicture extends StatelessWidget {
  HistoryPicture({
    super.key,
    required this.leftFile,
    required this.rightFile,
  });

  Uint8List? leftFile, rightFile;

  @override
  Widget build(BuildContext context) {
    Uint8List? isFile = leftFile ?? rightFile;
    double height =
        [leftFile, rightFile].whereType<Uint8List>().length == 1 ? 300 : 150;

    return isFile != null
        ? Column(
            children: [
              Row(
                children: [
                  leftFile != null
                      ? Expanded(
                          child: DefaultImage(data: leftFile!, height: height))
                      : const EmptyArea(),
                  SpaceWidth(width: leftFile != null ? tinySpace : 0),
                  rightFile != null
                      ? Expanded(
                          child: DefaultImage(data: rightFile!, height: height))
                      : const EmptyArea(),
                ],
              ),
              SpaceHeight(height: 15)
            ],
          )
        : const EmptyArea();
  }
}

class HistoryTodo extends StatelessWidget {
  HistoryTodo({
    super.key,
    required this.actions,
    required this.createDateTime,
  });

  List<Map<String, dynamic>>? actions;
  DateTime createDateTime;

  @override
  Widget build(BuildContext context) {
    renderSvg(String type) => SvgPicture.asset('assets/svgs/check-$type.svg');

    Map<String, SvgPicture> wSvgPicture = {
      PlanTypeEnum.diet.toString(): renderSvg('diet'),
      PlanTypeEnum.exercise.toString(): renderSvg('exercise'),
      PlanTypeEnum.lifestyle.toString(): renderSvg('life'),
    };

    final todoResultList = actions
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(createDateTime),
        )
        .toList();

    todoResultList?.sort(
        (a, b) => planOrder[a['type']]!.compareTo(planOrder[b['type']]!));

    final todoWidgetList = todoResultList
        ?.map((data) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: wSvgPicture[data['type']] ?? EmptyArea(),
                      ),
                    ),
                    SpaceWidth(width: smallSpace),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data['name'],
                        style: const TextStyle(fontSize: 13, color: themeColor),
                      ),
                    ),
                  ],
                ),
                SpaceHeight(height: 10),
              ],
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Column(children: todoWidgetList ?? []),
    );
  }
}

class HistoryDiary extends StatelessWidget {
  HistoryDiary({
    super.key,
    required this.whiteText,
    required this.diaryDateTime,
  });

  String? whiteText;
  DateTime? diaryDateTime;

  @override
  Widget build(BuildContext context) {
    return whiteText != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(whiteText!,
                  style: TextStyle(color: themeColor, fontSize: 13)),
              SpaceHeight(height: tinySpace),
              Text(
                timeToString(diaryDateTime),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              SpaceHeight(height: 15)
            ],
          )
        : const EmptyArea();
  }
}

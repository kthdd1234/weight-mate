import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryRemove.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_svg/svg.dart';

class HistoryHeader extends StatelessWidget {
  HistoryHeader({
    super.key,
    required this.recordInfo,
    required this.isRemoveMode,
    required this.isWeightMorning,
    required this.isWeightNight,
    required this.isDiary,
    this.onTapMore,
  });

  RecordBox? recordInfo;
  bool isRemoveMode, isWeightMorning, isWeightNight, isDiary;
  Function()? onTapMore;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;

    onRemoveEmotion() {
      recordInfo?.emotion = null;
      recordInfo?.save();
    }

    onTapRemoveWegiht() {
      recordInfo?.weight = null;
      recordInfo?.weightDateTime = null;
      recordInfo?.save();
    }

    return Row(
      children: [
        HistoryEmotion(
          emotion: recordInfo?.emotion,
          isDiary: isDiary,
          isRemoveMode: isRemoveMode,
          onRemoveEmotion: onRemoveEmotion,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HistoryDateTime(
                createDateTime: recordInfo?.createDateTime ?? DateTime.now(),
                isWeightMorning: isWeightMorning,
                isWeightNight: isWeightNight,
                isRemoveMode: isRemoveMode,
                onTapMore: onTapMore,
              ),
              SpaceHeight(height: 5),
              HistoryTitle(
                createDateTime: recordInfo?.createDateTime ?? DateTime.now(),
                isWeightMorning: isWeightMorning,
                isWeightNight: isWeightNight,
                tall: user.tall,
                tallUnit: user.tallUnit ?? 'cm',
                weight: recordInfo?.weight,
                weightNight: recordInfo?.weightNight,
                weightUnit: user.weightUnit ?? 'kg',
                isRemoveMode: isRemoveMode,
                onTapRemoveWegiht: onTapRemoveWegiht,
              )
            ],
          ),
        )
      ],
    );
  }
}

class HistoryEmotion extends StatelessWidget {
  HistoryEmotion({
    super.key,
    required this.emotion,
    required this.isDiary,
    required this.isRemoveMode,
    required this.onRemoveEmotion,
  });

  String? emotion;
  bool isDiary, isRemoveMode;
  Function() onRemoveEmotion;

  @override
  Widget build(BuildContext context) {
    return emotion != null && isDiary
        ? Expanded(
            flex: 0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/svgs/$emotion.svg',
                  ),
                ),
                isRemoveMode
                    ? HistoryRemove(onTap: onRemoveEmotion)
                    : const EmptyArea()
              ],
            ),
          )
        : const EmptyArea();
  }
}

class HistoryDateTime extends StatelessWidget {
  HistoryDateTime({
    super.key,
    required this.isWeightMorning,
    required this.isWeightNight,
    required this.isRemoveMode,
    required this.createDateTime,
    this.onTapMore,
  });

  bool isWeightMorning, isWeightNight, isRemoveMode;
  DateTime createDateTime;
  Function()? onTapMore;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    String mdeDt = onTapMore != null
        ? mde(locale: locale, dateTime: createDateTime)
        : ymd(locale: locale, dateTime: createDateTime);
    String mdDt = onTapMore != null
        ? md(locale: locale, dateTime: createDateTime)
        : ymd(locale: locale, dateTime: createDateTime);

    return Row(
      children: [
        CommonText(
          text: isWeightMorning || isWeightNight ? mdeDt : mdDt,
          size: 12,
          isNotTr: true,
          color: textColor,
        ),
        const Spacer(),
        isRemoveMode
            ? const EmptyArea()
            : onTapMore != null
                ? InkWell(
                    onTap: onTapMore,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CommonIcon(
                        icon: Icons.more_vert_rounded,
                        size: 16,
                        onTap: onTapMore,
                      ),
                    ),
                  )
                : const EmptyArea()
      ],
    );
  }
}

class HistoryTitle extends StatelessWidget {
  HistoryTitle({
    super.key,
    required this.createDateTime,
    required this.isWeightMorning,
    required this.isWeightNight,
    required this.tall,
    required this.tallUnit,
    required this.weightUnit,
    required this.isRemoveMode,
    required this.onTapRemoveWegiht,
    this.weight,
    this.weightNight,
  });

  DateTime createDateTime;
  double tall;
  double? weight, weightNight;
  String tallUnit, weightUnit;
  bool isRemoveMode, isWeightMorning, isWeightNight;
  Function() onTapRemoveWegiht;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    bool isDateTime = !isWeightMorning & !isWeightNight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            isDateTime
                ? CommonText(
                    text: e(locale: locale, dateTime: createDateTime),
                    size: 12,
                    color: grey.original,
                    isNotTr: true,
                  )
                : const EmptyArea(),
            isWeightMorning
                ? Row(
                    children: [
                      isRemoveMode && weight != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: HistoryRemove(onTap: onTapRemoveWegiht),
                            )
                          : const EmptyArea(),
                      CommonTag(
                        text: '아침 ${weight ?? '-'}$weightUnit',
                        color: 'indigo',
                        size: 10,
                      ),
                    ],
                  )
                : const EmptyArea(),
            SpaceWidth(width: 5),
            isWeightNight
                ? Row(
                    children: [
                      isRemoveMode && weight != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: HistoryRemove(onTap: onTapRemoveWegiht),
                            )
                          : const EmptyArea(),
                      CommonTag(
                        text: '저녁 ${weightNight ?? '-'}$weightUnit',
                        color: 'pink',
                        size: 10,
                      ),
                    ],
                  )
                : const EmptyArea(),
          ],
        ),
      ],
    );
  }
}

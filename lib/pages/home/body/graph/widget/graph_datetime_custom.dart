import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dot/dot_row.dart';
import 'package:flutter_app_weight_management/components/popup/CalendarSelectionPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class GraphDateTimeCustom extends StatelessWidget {
  GraphDateTimeCustom({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
  });

  DateTime startDateTime, endDateTime;

  @override
  Widget build(BuildContext context) {
    UserBox? user = userRepository.user;

    onSubmit(DateTime dateTime, String type) async {
      bool isStart = type == 'start';
      isStart
          ? user.cutomGraphStartDateTime = dateTime
          : user.cutomGraphEndDateTime = dateTime;

      await user.save();
      closeDialog(context);
    }

    onTap({
      required String type,
      required DateTime dateTime,
      required MaterialColor backgroundColor,
      required MaterialColor selectionColor,
    }) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalendarSelectionPopup(
          selectionColor: selectionColor,
          backgroundColor: backgroundColor,
          type: type,
          titleWidgets: TitleBlock(type: type, color: selectionColor),
          initialDateTime: dateTime,
          maxDate: type == 'start' ? endDateTime : null,
          minDate: type == 'end' ? startDateTime : null,
          onSubmit: onSubmit,
        ),
      );
    }

    contentsBoxWidget({
      required DateTime dateTime,
      required String type,
      required String text,
      required String title,
      required String svg,
      required MaterialColor color,
    }) {
      return InkWell(
        onTap: () => onTap(
            type: type,
            dateTime: dateTime,
            selectionColor: color,
            backgroundColor: color),
        child: ContentsBox(
          backgroundColor: typeBackgroundColor,
          contentsWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Dot(size: 8, color: color.shade200),
                      SpaceWidth(width: 5),
                      CommonText(text: title, size: 12),
                    ],
                  ),
                  SpaceHeight(height: 2),
                  CommonText(text: text, size: 13, isNotTr: true)
                ],
              ),
              CommonSvg(name: svg, width: 40),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SpaceHeight(height: smallSpace),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: contentsBoxWidget(
                  dateTime: startDateTime,
                  type: 'start',
                  svg: 'arrow-start',
                  title: '시작일',
                  color: Colors.blue,
                  text: ymdShort(
                    locale: context.locale.toString(),
                    dateTime: startDateTime,
                  ),
                ),
              ),
              SpaceWidth(width: smallSpace),
              Expanded(
                child: contentsBoxWidget(
                  dateTime: endDateTime,
                  type: 'end',
                  svg: 'arrow-end',
                  title: '종료일',
                  color: Colors.red,
                  text: ymdShort(
                    locale: context.locale.toString(),
                    dateTime: endDateTime,
                  ),
                ),
              ),
            ],
          ),
          SpaceHeight(height: smallSpace),
        ],
      ),
    );
  }
}

class TitleBlock extends StatelessWidget {
  TitleBlock({super.key, required this.type, required this.color});

  String type;
  MaterialColor color;

  @override
  Widget build(BuildContext context) {
    final String text = type == 'start' ? '시작일' : '종료일';

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text 선택'.tr(),
            style: const TextStyle(color: textColor, fontSize: 17),
          ),
          ColorTextInfo(
            width: smallSpace,
            height: smallSpace,
            text: text.tr(),
            color: color.shade300,
          )
        ],
      ),
    );
  }
}

class ColorTextInfo extends StatelessWidget {
  ColorTextInfo({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.color,
    this.isOutlined,
  });

  double width;
  double height;
  String text;
  Color color;
  bool? isOutlined;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceWidth(width: smallSpace),
        Dot(
          size: width,
          color: color,
          isOutlined: isOutlined,
        ),
        SpaceWidth(width: tinySpace),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

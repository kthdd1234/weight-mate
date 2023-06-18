import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_default_dialog.dart';
import 'package:flutter_app_weight_management/components/dialog/title_block.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class GraphDateTimeCustom extends StatelessWidget {
  GraphDateTimeCustom({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    required this.onSubmit,
  });

  DateTime startDateTime, endDateTime;
  Function({String? type, Object? object}) onSubmit;

  @override
  Widget build(BuildContext context) {
    onTap({
      required String type,
      required DateTime dateTime,
    }) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalendarDefaultDialog(
          type: type,
          titleWidgets: TitleBlock(type: type),
          initialDateTime: dateTime,
          onSubmit: onSubmit,
          onCancel: () => closeDialog(context),
          maxDate: type == 'start' ? endDateTime : null,
          minDate: type == 'end' ? startDateTime : null,
        ),
      );
    }

    contentsBoxWidget({
      required DateTime dateTime,
      required String type,
      required IconData icon,
      required String text,
      required String title,
    }) {
      return InkWell(
        onTap: () => onTap(type: type, dateTime: dateTime),
        child: ContentsBox(
          backgroundColor: typeBackgroundColor,
          contentsWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmallText(text: title),
                  SpaceHeight(height: smallSpace),
                  Text(text),
                ],
              ),
              CircularIcon(
                icon: icon,
                size: 40,
                borderRadius: 40,
                backgroundColor: dialogBackgroundColor,
                onTap: (id) => onTap(type: type, dateTime: dateTime),
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: contentsBoxWidget(
                dateTime: startDateTime,
                type: 'start',
                icon: Icons.calendar_month,
                title: '시작일',
                text: dateTimeFormatter(
                  format: 'MM월 dd일',
                  dateTime: startDateTime,
                ),
              ),
            ),
            SpaceWidth(width: smallSpace),
            Expanded(
              child: contentsBoxWidget(
                dateTime: endDateTime,
                type: 'end',
                icon: Icons.calendar_month,
                title: '종료일',
                text: dateTimeFormatter(
                  format: 'MM월 dd일',
                  dateTime: endDateTime,
                ),
              ),
            ),
          ],
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/date_time_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/sub_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class DateTimeRangeInputWidget extends StatelessWidget {
  DateTimeRangeInputWidget({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    required this.onTapInput,
  });

  DateTime startDateTime;
  DateTime? endDateTime;
  Function({String type, DateTime? dateTime}) onTapInput;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DateTimeInput(
            prefixIcon: Icons.calendar_month,
            hintText: '시작일',
            text: dateTimeFormatter(
              format: 'yyyy년 MM월 dd일 EEEE',
              dateTime: startDateTime,
            ),
            onTap: () => onTapInput(type: 'start', dateTime: startDateTime),
          ),
        ),
        // SpaceWidth(width: smallSpace),
        // SubText(text: '~', value: ''),
        // SpaceWidth(width: smallSpace),
        // Expanded(
        //   child: DateTimeInput(
        //     prefixIcon: Icons.hourglass_bottom_rounded,
        //     hintText: '종료일',
        //     text: endDateTime != null ? getDateTimeToSlashYY(endDateTime!) : '',
        //     onTap: () => onTapInput(type: 'end', dateTime: endDateTime),
        //   ),
        // ),
      ],
    );
  }
}

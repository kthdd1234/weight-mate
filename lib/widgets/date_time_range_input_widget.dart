import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/input/date_time_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/sub_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class DateTimeRangeInputWidget extends StatelessWidget {
  DateTimeRangeInputWidget({
    super.key,
    required this.startDietDateTime,
    required this.endDietDateTime,
    required this.onTapInput,
  });

  DateTime startDietDateTime;
  DateTime? endDietDateTime;
  Function({String type, DateTime? dateTime}) onTapInput;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DateTimeInput(
            prefixIcon: Icons.hourglass_top_rounded,
            hintText: '시작일',
            text: getDateTimeToSlash(startDietDateTime),
            onTap: () => onTapInput(type: 'start', dateTime: startDietDateTime),
          ),
        ),
        SpaceWidth(width: smallSpace),
        SubText(text: '~', value: ''),
        SpaceWidth(width: smallSpace),
        Expanded(
          child: DateTimeInput(
            prefixIcon: Icons.hourglass_bottom_rounded,
            hintText: '종료일',
            text: endDietDateTime != null
                ? getDateTimeToSlash(endDietDateTime!)
                : '',
            onTap: () => onTapInput(type: 'end', dateTime: endDietDateTime),
          ),
        ),
      ],
    );
  }
}

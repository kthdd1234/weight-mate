import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_day_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class AppBarCalendarDayWidget extends StatefulWidget {
  AppBarCalendarDayWidget({super.key});

  @override
  State<AppBarCalendarDayWidget> createState() =>
      _AppBarCalendarDayWidgetState();
}

class _AppBarCalendarDayWidgetState extends State<AppBarCalendarDayWidget> {
  String dateTimeToStr = '';

  @override
  void initState() {
    dateTimeToStr = getDateTimeToStr(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onSubmit(DateTime dateTime) {
      setState(() => dateTimeToStr = getDateTimeToStr(dateTime));
      closeDialog(context);
    }

    onCancel() {
      closeDialog(context);
    }

    onTap() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CalendarDayDialog(
              initDate: dateTimeToStr,
              onSubmit: onSubmit,
              onCancel: onCancel,
            );
          });
    }

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dateTimeToStr, style: const TextStyle(fontSize: 18)),
          SpaceWidth(width: tinySpace),
          const Icon(Icons.expand_circle_down_outlined, size: 18),
        ],
      ),
    );
  }
}

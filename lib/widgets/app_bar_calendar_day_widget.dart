import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_custom_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
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
            return CalendayCustomDialog(
              initialDateTime: DateTime.now(),
              onSubmit: onSubmit,
              onCancel: onCancel,
              titleWidgets: [
                const Text('기록한 날'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ColorTextInfo(
                      width: smallSpace,
                      height: smallSpace,
                      text: '체중',
                      color: weightDotColor,
                    ),
                    SpaceWidth(width: 7.5),
                    ColorTextInfo(
                      width: smallSpace,
                      height: smallSpace,
                      text: '계획',
                      color: planDotColor,
                    ),
                    SpaceWidth(width: 7.5),
                    ColorTextInfo(
                      width: smallSpace,
                      height: smallSpace,
                      text: '메모',
                      color: memoDotColor,
                    ),
                  ],
                )
              ],
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

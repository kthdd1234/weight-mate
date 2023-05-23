import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_custom_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';

class AppBarCalendarDayWidget extends StatelessWidget {
  AppBarCalendarDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateTime =
        context.watch<RecordSelectedDateTimeProvider>().getSelectedDateTime();

    onSubmit(DateTime selectedDateTime) {
      context
          .read<RecordSelectedDateTimeProvider>()
          .setSelectedDateTime(selectedDateTime);
      closeDialog(context);
    }

    onCancel() {
      closeDialog(context);
    }

    onTap() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            colorWidget(String text) {
              final colorData = {
                '체중': weightDotColor,
                '계획': planDotColor,
                '메모': memoDotColor
              };

              return ColorTextInfo(
                width: smallSpace,
                height: smallSpace,
                text: text,
                color: colorData[text]!,
              );
            }

            return CalendayCustomDialog(
              initialDateTime: dateTime,
              onSubmit: onSubmit,
              onCancel: onCancel,
              titleWidgets: [
                const Text('기록한 날'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    colorWidget('체중'),
                    SpaceWidth(width: 7.5),
                    colorWidget('계획'),
                    SpaceWidth(width: 7.5),
                    colorWidget('메모'),
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
          Text(
            getDateTimeToStr(dateTime),
            style: const TextStyle(fontSize: 18),
          ),
          SpaceWidth(width: tinySpace),
          const Icon(Icons.expand_circle_down_outlined, size: 18),
        ],
      ),
    );
  }
}

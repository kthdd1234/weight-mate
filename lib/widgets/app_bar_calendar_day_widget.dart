import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_cell_custom_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';

class AppBarCalendarDayWidget extends StatelessWidget {
  const AppBarCalendarDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateTime =
        context.watch<RecordSelectedDateTimeProvider>().getSelectedDateTime();

    onTap() {
      showDialog(
        context: context,
        builder: (BuildContext context) => const CalendarCellCustomDialog(),
      );
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

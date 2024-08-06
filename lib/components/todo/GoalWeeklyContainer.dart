import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/popup/CalendarRangePopup.dart';
import 'package:flutter_app_weight_management/components/todo/GoalWidgets.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GoalWeeklyContainer extends StatefulWidget {
  GoalWeeklyContainer({super.key, required this.type});

  String type;

  @override
  State<GoalWeeklyContainer> createState() => _GoalWeeklyContainerState();
}

class _GoalWeeklyContainerState extends State<GoalWeeklyContainer> {
  DateTime startDateTime = weeklyStartDateTime(DateTime.now());
  DateTime endDateTime = weeklyEndDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      DateTime rangeStartDate = args.value.startDate;
      DateTime sDateTime = weeklyStartDateTime(rangeStartDate);
      DateTime eDateTime = weeklyEndDateTime(rangeStartDate);

      setState(() {
        startDateTime = sDateTime;
        endDateTime = eDateTime;
      });

      closeDialog(context);
    }

    onTapWeeklyDateTime() {
      showDialog(
        context: context,
        builder: (context) => CalendarRangePopup(
          startAndEndDateTime: [startDateTime, endDateTime],
          onSelectionChanged: onSelectionChanged,
        ),
      );
    }

    return Expanded(
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            const RowColors(),
            DateTimeTag(
              startDateTime: startDateTime,
              endDateTime: endDateTime,
              onTapWeeklyDateTime: onTapWeeklyDateTime,
            ),
            RowTitles(type: widget.type),
            ColumnItmeList(type: widget.type, startDateTime: startDateTime),
          ],
        ),
      ),
    );
  }
}

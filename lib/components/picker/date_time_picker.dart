import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateTimePicker extends StatelessWidget {
  DateTimePicker({
    super.key,
    required this.view,
    required this.initialSelectedDate,
    required this.onSelectionChanged,
  });

  DateRangePickerView view;
  DateTime initialSelectedDate;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      width: MediaQuery.of(context).size.width,
      contentsWidget: SfDateRangePicker(
        todayHighlightColor: indigo.s300,
        selectionColor: indigo.s300,
        selectionTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        showNavigationArrow: true,
        initialDisplayDate: initialSelectedDate,
        initialSelectedDate: initialSelectedDate,
        // maxDate: DateTime.now(),
        view: view,
        allowViewNavigation: false,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}

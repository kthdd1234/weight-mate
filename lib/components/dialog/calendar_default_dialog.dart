import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarDefaultDialog extends StatefulWidget {
  CalendarDefaultDialog({
    super.key,
    required this.type,
    required this.titleWidgets,
    required this.initialDateTime,
    required this.onSubmit,
    required this.backgroundColor,
    required this.selectionColor,
    this.maxDate,
    this.minDate,
  });

  String type;
  Widget titleWidgets;
  MaterialColor backgroundColor, selectionColor;
  DateTime? initialDateTime;
  Function({String type, Object? object}) onSubmit;
  DateTime? maxDate;
  DateTime? minDate;

  @override
  State<CalendarDefaultDialog> createState() => _CalendarDefaultDialogState();
}

class _CalendarDefaultDialogState extends State<CalendarDefaultDialog> {
  final DateRangePickerController _pickerController =
      DateRangePickerController();

  @override
  void initState() {
    _pickerController.selectedDate = widget.initialDateTime;
    _pickerController.displayDate = widget.initialDateTime;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [widget.titleWidgets],
      ),
      content: ContentsBox(
        width: MediaQuery.of(context).size.width,
        height: 420,
        contentsWidget: SfDateRangePicker(
          showNavigationArrow: true,
          selectionTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectionColor: widget.selectionColor.shade200,
          todayHighlightColor: Colors.transparent,
          controller: _pickerController,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          maxDate: widget.maxDate,
          minDate: widget.minDate,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs? object) =>
              widget.onSubmit(
            type: widget.type,
            object: object,
          ),
          // onSubmit: (Object? object) => widget.onSubmit(
          //   type: widget.type,
          //   object: object,
          // ),
          // onCancel: widget.onCancel,
        ),
      ),
    );
  }
}

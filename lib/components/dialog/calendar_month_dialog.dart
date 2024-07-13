import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarMonthDialog extends StatefulWidget {
  CalendarMonthDialog({
    super.key,
    required this.initialDateTime,
    required this.onSubmit,
    required this.onCancel,
  });

  DateTime? initialDateTime;
  Function(DateTime dateTime) onSubmit;
  Function() onCancel;

  @override
  State<CalendarMonthDialog> createState() => _CalendarMonthDialogState();
}

class _CalendarMonthDialogState extends State<CalendarMonthDialog> {
  final DateRangePickerController _pickerController =
      DateRangePickerController();

  @override
  void initState() {
    if (widget.initialDateTime != null) {
      _pickerController.selectedDate = widget.initialDateTime;
      _pickerController.displayDate = widget.initialDateTime;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setOnSubmit(Object? object) {
      if (object is DateTime) {
        widget.onSubmit(object);
      }
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: whiteBgBtnColor,
      title: DialogTitle(text: '달력', onTap: () => closeDialog(context)),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: Card(
          shape: containerBorderRadious,
          borderOnForeground: false,
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SfDateRangePicker(
              controller: _pickerController,
              view: DateRangePickerView.year,
              showNavigationArrow: true,
              allowViewNavigation: false,
              selectionMode: DateRangePickerSelectionMode.single,
              maxDate: DateTime.now(),
              showActionButtons: true,
              onSubmit: setOnSubmit,
              onCancel: widget.onCancel,
              confirmText: '불러오기',
              cancelText: '닫기',
            ),
          ),
        ),
      ),
    );
  }
}

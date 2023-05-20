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
    required this.onCancel,
    this.maxDate,
    this.minDate,
  });

  String type;
  List<Widget> titleWidgets;
  DateTime? initialDateTime;
  Function({String type, Object? object}) onSubmit;
  Function() onCancel;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.titleWidgets,
      ),
      content: ContentsBox(
        width: MediaQuery.of(context).size.width,
        height: 450,
        contentsWidget: SfDateRangePicker(
          showNavigationArrow: true,
          selectionColor:
              widget.type == 'start' ? buttonBackgroundColor : Colors.red,
          todayHighlightColor: Colors.transparent,
          controller: _pickerController,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          showActionButtons: true,
          confirmText: '확인',
          cancelText: '닫기',
          maxDate: widget.maxDate,
          minDate: widget.minDate,
          onSubmit: (Object? object) => widget.onSubmit(
            type: widget.type,
            object: object,
          ),
          onCancel: widget.onCancel,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_month_cell_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateRangePicker extends StatefulWidget {
  CustomDateRangePicker({
    super.key,
    required this.confirmText,
    required this.cancelText,
    required this.selectedDateTime,
    required this.onSelectionChanged,
    required this.onSubmit,
    required this.onCancel,
    required this.onViewChanged,
  });

  String confirmText;
  String cancelText;
  DateTime selectedDateTime;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  Function(Object?) onSubmit;
  Function() onCancel;
  Function(DateRangePickerViewChangedArgs) onViewChanged;

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateRangePickerController controller = DateRangePickerController();
  String currentView = 'month';

  @override
  Widget build(BuildContext context) {
    cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
      return CalendarMonthCellWidget(
        currentView: currentView,
        detailDateTime: details.date,
        isSelectedDay: isSelectedDate(
          cellBuilderDate: details.date,
          selectedDate: widget.selectedDateTime,
        ),
      );
    }

    return SfDateRangePicker(
      controller: controller,
      showNavigationArrow: true,
      view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.single,
      maxDate: DateTime.now(),
      cellBuilder: currentView == 'month' ? cellBuilder : null,
      selectionColor: currentView == 'month' ? Colors.transparent : null,
      onSelectionChanged: widget.onSelectionChanged,
      showActionButtons: true,
      confirmText: widget.confirmText,
      cancelText: widget.cancelText,
      onSubmit: widget.onSubmit,
      onCancel: widget.onCancel,
      onViewChanged: widget.onViewChanged,
    );
  }
}

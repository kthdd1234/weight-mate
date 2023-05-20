import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_month_cell_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendayCustomDialog extends StatefulWidget {
  CalendayCustomDialog({
    super.key,
    required this.initialDateTime,
    required this.onSubmit,
    required this.onCancel,
    required this.titleWidgets,
  });

  DateTime? initialDateTime;
  Function(DateTime dateTime) onSubmit;
  Function() onCancel;
  List<Widget> titleWidgets;

  @override
  State<CalendayCustomDialog> createState() => _CalendayCustomDialogState();
}

class _CalendayCustomDialogState extends State<CalendayCustomDialog> {
  final DateRangePickerController _pickerController =
      DateRangePickerController();
  String currentView = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.initialDateTime != null) {
      selectedDate = widget.initialDateTime!;
      _pickerController.displayDate = widget.initialDateTime;
    }

    super.initState();
  }

  @override
  void dispose() {
    selectedDate = DateTime.now();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
      return CalendarMonthCellWidget(
        currentView: currentView,
        detailDateTime: details.date,
        isSelectedDay: isSelectedDate(
          cellBuilderDate: details.date,
          selectedDate: selectedDate,
        ),
      );
    }

    onViewChanged(DateRangePickerViewChangedArgs args) {
      final viewName = args.view.name;

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() => currentView = viewName);
      });
    }

    onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      if (args.value is DateTime) {
        DateTime selectedDateTime = args.value;
        setState(() => selectedDate = selectedDateTime);
      }
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.titleWidgets,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Card(
          shape: containerBorderRadious,
          borderOnForeground: false,
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SfDateRangePicker(
              controller: _pickerController,
              showNavigationArrow: true,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              maxDate: DateTime.now(),
              cellBuilder: currentView == 'month' ? cellBuilder : null,
              selectionColor:
                  currentView == 'month' ? Colors.transparent : null,
              showActionButtons: true,
              confirmText: '불러오기',
              cancelText: '닫기',
              onViewChanged: onViewChanged,
              onSelectionChanged: onSelectionChanged,
              onSubmit: (Object? object) => widget.onSubmit(selectedDate),
              onCancel: widget.onCancel,
            ),
          ),
        ),
      ),
    );
  }
}

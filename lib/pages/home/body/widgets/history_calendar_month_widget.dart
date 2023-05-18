import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_month_cell_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistoryCalendarMonthWidget extends StatefulWidget {
  HistoryCalendarMonthWidget({
    super.key,
    required this.selectedDateTime,
    required this.onSelectionChanged,
  });

  DateTime selectedDateTime;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;

  @override
  State<HistoryCalendarMonthWidget> createState() =>
      _HistoryCalendarMonthWidgetState();
}

class _HistoryCalendarMonthWidgetState
    extends State<HistoryCalendarMonthWidget> {
  DateRangePickerController controller = DateRangePickerController();
  String currentView = 'month';

  @override
  void initState() {
    controller.selectedDate = widget.selectedDateTime;
    controller.displayDate = widget.selectedDateTime;

    super.initState();
  }

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

    onViewChanged(DateRangePickerViewChangedArgs args) {
      final viewName = args.view.name;

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() => currentView = viewName);
      });
    }

    onReset() {
      final dateTimeToStr = getDateTimeToStr(widget.selectedDateTime);

      onPressedOk() {
        //
      }

      showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
          titleText: '초기화',
          contentIcon: Icons.replay_rounded,
          contentText1: '$dateTimeToStr',
          contentText2: '기록을 초기화 하시겠습니까?',
          onPressedOk: onPressedOk,
        ),
      );
    }

    onModify(Object? object) {
      print(widget.selectedDateTime);
    }

    return ContentsBox(
      height: 430,
      backgroundColor: dialogBackgroundColor,
      contentsWidget: SfDateRangePicker(
        controller: controller,
        showNavigationArrow: true,
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.single,
        maxDate: DateTime.now(),
        cellBuilder: currentView == 'month' ? cellBuilder : null,
        selectionColor: currentView == 'month' ? Colors.transparent : null,
        onSelectionChanged: widget.onSelectionChanged,
        // showActionButtons: true,
        confirmText: '수정하기',
        cancelText: '초기화',
        onSubmit: onModify,
        onCancel: onReset,
        onViewChanged: onViewChanged,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_weight_management/model/record_info/record_info.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_month_cell_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  });

  String confirmText;
  String cancelText;
  DateTime selectedDateTime;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  Function(Object?) onSubmit;
  Function() onCancel;

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late Box<UserInfoBox> userInfoBox;
  late Box<RecordInfoBox> recordInfoBox;

  DateRangePickerController controller = DateRangePickerController();
  String currentView = 'month';

  @override
  void initState() {
    userInfoBox = Hive.box<UserInfoBox>('userInfoBox');
    recordInfoBox = Hive.box<RecordInfoBox>('recordInfoBox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cellBuilder(
      BuildContext context,
      DateRangePickerCellDetails details,
    ) {
      Set<String> object = <String>{};
      int dateTimeToInt = getDateTimeToInt(details.date);
      RecordInfoBox? recordInfo = recordInfoBox.get(dateTimeToInt);

      if (recordInfo != null) {
        if (recordInfo.weight != null) object.add('weight');
        if (recordInfo.memo != null) object.add('memo');
        if (recordInfo.dietPlanList != null) {
          if (recordInfo.dietPlanList!
              .every((element) => element['isAction'])) {
            object.add('action');
          }
        }
      }

      return CalendarMonthCellWidget(
        recordObject: object,
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

    return ValueListenableBuilder(
      valueListenable: recordInfoBox.listenable(),
      builder: (context, box, boxWidget) {
        return SfDateRangePicker(
          controller: controller,
          showNavigationArrow: true,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          maxDate: DateTime.now(),
          cellBuilder: currentView == 'month'
              ? (context, details) => cellBuilder(context, details)
              : null,
          selectionColor: currentView == 'month' ? Colors.transparent : null,
          onSelectionChanged: widget.onSelectionChanged,
          showActionButtons: true,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
          onSubmit: widget.onSubmit,
          onCancel: widget.onCancel,
          onViewChanged: onViewChanged,
        );
      },
    );
  }
}

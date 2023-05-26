import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
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
  DateRangePickerController controller = DateRangePickerController();
  String currentView = 'month';
  Box<UserInfoBox> userInfoBox = Hive.box<UserInfoBox>('userInfoBox');

  @override
  Widget build(BuildContext context) {
    cellBuilder(
      BuildContext context,
      DateRangePickerCellDetails details,
    ) {
      final set = <String>{};
      final dateTimeSlash = getDateTimeToSlash(details.date);
      final recordInfoList = userInfoBox.get('userInfo')!.recordInfoList;

      if (recordInfoList == null) {
        return const EmptyArea();
      }

      final recordInfo = recordInfoList.firstWhere((obj) {
        return dateTimeSlash == getDateTimeToSlash(obj['recordDateTime']);
      }, orElse: () => {});

      if (recordInfo.isNotEmpty) {
        double? weight = recordInfo['weight'];
        List<Map<String, dynamic>> dietPlanList = recordInfo['dietPlanList'];
        String? memo = recordInfo['memo'];

        if (weight != null) set.add('weight');
        if (memo != null) set.add('memo');
        if (dietPlanList.every((element) => element['isAction'])) {
          set.add('action');
        }
      }

      return CalendarMonthCellWidget(
        recordObject: set,
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
      valueListenable: userInfoBox.listenable(),
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

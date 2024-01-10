import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
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
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;

  DateRangePickerController controller = DateRangePickerController();
  String currentView = 'month';

  @override
  void initState() {
    userBox = Hive.box<UserBox>('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');

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
      RecordBox? recordInfo = recordBox.get(dateTimeToInt);

      if (recordInfo != null) {
        if (recordInfo.weight != null) object.add('weight');
        if (recordInfo.whiteText != null) object.add('memo');
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
      valueListenable: recordBox.listenable(),
      builder: (context, box, boxWidget) {
        return SfDateRangePicker(
          backgroundColor: Colors.transparent,
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

class CalendarMonthCellWidget extends StatelessWidget {
  CalendarMonthCellWidget({
    super.key,
    required this.detailDateTime,
    required this.recordObject,
    required this.isSelectedDay,
    required this.currentView,
  });

  DateTime detailDateTime;
  Set<String> recordObject;
  bool isSelectedDay;
  String currentView;

  @override
  Widget build(BuildContext context) {
    final isMaxDateResult = isMaxDate(
      targetDateTime: DateTime.now(),
      detailDateTime: detailDateTime,
    );

    setCellTextColor() {
      if (isMaxDateResult) return Colors.grey;
      return isSelectedDay ? Colors.white : Colors.black;
    }

    setCellText() {
      if (currentView != 'month') return '';
      return detailDateTime.day.toString();
    }

    colorWidget(String type) {
      final dotColors = {
        'weight': weightColor,
        'action': actionColor,
        'memo': diaryColor,
      };

      return Column(
        children: [
          Dot(size: 7, color: dotColors[type]!),
          SpaceWidth(width: 10)
        ],
      );
    }

    setRecordDots(Set<String> object) {
      final children = object.map((element) => colorWidget(element)).toList();

      if (isMaxDateResult || currentView != 'month' || children.isEmpty) {
        return const EmptyArea();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: isSelectedDay ? themeColor : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              setCellText(),
              style: TextStyle(fontFamily: '', color: setCellTextColor()),
            ),
          ),
        ),
        SpaceHeight(height: 3),
        setRecordDots(recordObject),
      ],
    );
  }
}

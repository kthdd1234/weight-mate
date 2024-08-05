import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarRangePopup extends StatefulWidget {
  CalendarRangePopup({
    super.key,
    required this.startAndEndDateTime,
    required this.onSelectionChanged,
  });

  List<DateTime?> startAndEndDateTime;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;

  @override
  State<CalendarRangePopup> createState() => _CalendarRangePopupState();
}

class _CalendarRangePopupState extends State<CalendarRangePopup> {
  final DateRangePickerController _pickerController =
      DateRangePickerController();

  @override
  void initState() {
    super.initState();
    DateTime? startDateTime = widget.startAndEndDateTime[0];
    DateTime? endDateTime = widget.startAndEndDateTime[1];

    _pickerController.selectedRange =
        PickerDateRange(startDateTime, endDateTime);
    _pickerController.displayDate = endDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return CommonPopup(
      height: 520,
      child: Column(
        children: [
          Text(
            '요일을 선택하면 선택한 요일의 주가 표시됩니다.'.tr(),
            style: const TextStyle(fontSize: 12),
          ),
          SpaceHeight(height: 10),
          ContentsBox(
            width: MediaQuery.of(context).size.width,
            height: 450,
            child: SfDateRangePicker(
              rangeSelectionColor: whiteBgBtnColor,
              startRangeSelectionColor: indigo.s300,
              endRangeSelectionColor: indigo.s300,
              selectionTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              todayHighlightColor: Colors.transparent,
              toggleDaySelection: false,
              controller: _pickerController,
              maxDate: weeklyEndDateTime(DateTime.now()),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: widget.onSelectionChanged,
            ),
          ),
        ],
      ),
    );
  }
}

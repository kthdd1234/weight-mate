import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarSelectionPopup extends StatefulWidget {
  CalendarSelectionPopup({
    super.key,
    required this.type,
    required this.titleWidgets,
    required this.initialDateTime,
    required this.backgroundColor,
    required this.selectionColor,
    required this.onSubmit,
    this.maxDate,
    this.minDate,
  });

  String type;
  Widget titleWidgets;
  MaterialColor backgroundColor, selectionColor;
  DateTime? initialDateTime;
  DateTime? maxDate;
  DateTime? minDate;
  Function(DateTime dateTime, String type) onSubmit;

  @override
  State<CalendarSelectionPopup> createState() => _CalendarSelectionPopupState();
}

class _CalendarSelectionPopupState extends State<CalendarSelectionPopup> {
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
    return CommonPopup(
      height: 450,
      child: Column(
        children: [
          widget.titleWidgets,
          SpaceHeight(height: 10),
          ContentsBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 330,
                  child: SfDateRangePicker(
                    showNavigationArrow: true,
                    selectionTextStyle:
                        const TextStyle(fontWeight: FontWeight.bold),
                    selectionColor: widget.selectionColor.shade200,
                    todayHighlightColor: Colors.transparent,
                    controller: _pickerController,
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    maxDate: widget.maxDate,
                    minDate: widget.minDate,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs? object) =>
                            widget.onSubmit(object!.value, widget.type),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

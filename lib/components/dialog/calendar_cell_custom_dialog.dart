import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/picker/custom_date_range_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarCellCustomDialog extends StatefulWidget {
  const CalendarCellCustomDialog({super.key});

  @override
  State<CalendarCellCustomDialog> createState() =>
      _CalendarCellCustomDialogState();
}

class _CalendarCellCustomDialogState extends State<CalendarCellCustomDialog> {
  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    onSubmit(Object? object) {
      if (object is DateTime) {
        context.read<ImportDateTimeProvider>().setImportDateTime(object);
        closeDialog(context);
      }
    }

    onCancel() {
      closeDialog(context);
    }

    onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      if (args.value is DateTime) {
        setState(() => selectedDateTime = args.value);
      }
    }

    colorWidget(String text) {
      final colorData = {
        '체중': weightColor,
        '실천': actionColor,
        '메모': diaryColor
      };

      return ColorTextInfo(
        width: smallSpace,
        height: smallSpace,
        text: text,
        color: colorData[text]!,
      );
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('기록한 날'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              colorWidget('체중'),
              SpaceWidth(width: 7.5),
              colorWidget('실천'),
              SpaceWidth(width: 7.5),
              colorWidget('메모'),
            ],
          )
        ],
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
            child: CustomDateRangePicker(
              confirmText: '불러오기',
              cancelText: '닫기',
              selectedDateTime: selectedDateTime,
              onSelectionChanged: onSelectionChanged,
              onSubmit: onSubmit,
              onCancel: onCancel,
            ),
          ),
        ),
      ),
    );
  }
}
// SfDateRangePicker(
//               controller: _pickerController,
//               showNavigationArrow: true,
//               view: DateRangePickerView.month,
//               selectionMode: DateRangePickerSelectionMode.single,
//               maxDate: DateTime.now(),
//               cellBuilder: currentView == 'month' ? cellBuilder : null,
//               selectionColor:
//                   currentView == 'month' ? Colors.transparent : null,
//               showActionButtons: true,
//               confirmText: '불러오기',
//               cancelText: '닫기',
//               onViewChanged: onViewChanged,
//               onSelectionChanged: onSelectionChanged,
//               onSubmit: (Object? object) => widget.onSubmit(selectedDate),
//               onCancel: widget.onCancel,
//             )





import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_diary.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalenderRangeDialog extends StatefulWidget {
  CalenderRangeDialog({
    super.key,
    required this.title,
    required this.startAndEndDateTime,
    required this.onSelectionChanged,
    required this.onSubmit,
    required this.onCancel,
  });

  String title;
  List<DateTime?> startAndEndDateTime;
  Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  Function(Object? object) onSubmit;
  Function() onCancel;

  @override
  State<CalenderRangeDialog> createState() => _CalenderRangeDialogState();
}

class _CalenderRangeDialogState extends State<CalenderRangeDialog> {
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
    return AlertDialog(
      scrollable: true,
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: DialogTitle(text: widget.title, onTap: () => closeDialog(context)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ContentsBox(
            width: MediaQuery.of(context).size.width,
            height: 450,
            contentsWidget: SfDateRangePicker(
              todayHighlightColor: Colors.transparent,
              toggleDaySelection: false,
              controller: _pickerController,
              maxDate: weeklyEndDateTime(DateTime.now()),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: widget.onSelectionChanged,
              onSubmit: widget.onSubmit,
              onCancel: widget.onCancel,
            ),
          ),
          SpaceHeight(height: 10),
          const Text(
            '요일을 선택하면 선택한 요일의 주가 표시됩니다.',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
// Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             widget.labelText,
//             style: const TextStyle(color: themeColor, fontSize: 17),
//           ),
//           Row(
//             children: [
//               ColorTextInfo(
//                 width: smallSpace,
//                 height: smallSpace,
//                 text: '오늘',
//                 color: themeColor,
//                 isOutlined: true,
//               ),
//               SpaceWidth(width: 7.5),
//               ColorTextInfo(
//                   width: smallSpace,
//                   height: smallSpace,
//                   text: '시작일',
//                   color: themeColor),
//               SpaceWidth(width: 7.5),
//               ColorTextInfo(
//                 width: smallSpace,
//                 height: smallSpace,
//                 text: '종료일',
//                 color: Colors.red,
//               )
//             ],
//           )
//         ],
//       )
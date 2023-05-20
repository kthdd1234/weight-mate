import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalenderRangeDialog extends StatefulWidget {
  CalenderRangeDialog({
    super.key,
    required this.labelText,
    required this.startAndEndDateTime,
    required this.onSubmit,
    required this.onCancel,
  });

  String labelText;
  List<DateTime?> startAndEndDateTime;
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
    final startDateTime = widget.startAndEndDateTime[0];
    final endDateTime = widget.startAndEndDateTime[1];

    _pickerController.selectedRange =
        PickerDateRange(startDateTime, endDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(color: buttonBackgroundColor, fontSize: 17),
          ),
          Row(
            children: [
              ColorTextInfo(
                width: smallSpace,
                height: smallSpace,
                text: '오늘',
                color: buttonBackgroundColor,
                isOutlined: true,
              ),
              SpaceWidth(width: 7.5),
              ColorTextInfo(
                  width: smallSpace,
                  height: smallSpace,
                  text: '시작일',
                  color: buttonBackgroundColor),
              SpaceWidth(width: 7.5),
              ColorTextInfo(
                width: smallSpace,
                height: smallSpace,
                text: '종료일',
                color: Colors.red,
              )
            ],
          )
        ],
      ),
      content: ContentsBox(
        width: MediaQuery.of(context).size.width,
        height: 450,
        contentsWidget: SfDateRangePicker(
          controller: _pickerController,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          confirmText: '확인',
          cancelText: '닫기',
          endRangeSelectionColor: Colors.red,
          onSubmit: widget.onSubmit,
          onCancel: widget.onCancel,
        ),
      ),
    );
  }
}

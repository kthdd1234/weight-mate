import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/picker/custom_date_range_picker.dart';
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
  @override
  Widget build(BuildContext context) {
    onSubmit(Object? object) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
          width: 200,
          titleText: '초기화',
          contentIcon: Icons.replay_rounded,
          contentText1: '${getDateTimeToStr(widget.selectedDateTime)}',
          contentText2: '기록을 초기화 하시겠습니까?',
          onPressedOk: () {},
        ),
      );
    }

    onCancel() {
      print(widget.selectedDateTime);
    }

    return ContentsBox(
      height: 480,
      backgroundColor: dialogBackgroundColor,
      contentsWidget: CustomDateRangePicker(
        confirmText: '수정하기',
        cancelText: '초기화',
        selectedDateTime: widget.selectedDateTime,
        onSelectionChanged: widget.onSelectionChanged,
        onSubmit: onSubmit,
        onCancel: onCancel,
      ),
    );
  }
}

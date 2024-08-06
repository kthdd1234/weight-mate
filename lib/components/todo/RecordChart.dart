import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/todo/RecordWidgets.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RecordChart extends StatefulWidget {
  RecordChart({super.key, required this.type});

  String type;

  @override
  State<RecordChart> createState() => _RecordChartState();
}

class _RecordChartState extends State<RecordChart> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    int selectedMonthKey = mToInt(selectedMonth);
    List<RecordBox?> recordList = recordRepository.recordBox.values.toList();

    isDisplayRecord(RecordBox? record) {
      bool isSelectedMonth =
          (mToInt(record?.createDateTime) == selectedMonthKey);
      bool? isRecordAction = record?.actions?.any(
        (item) => item['isRecord'] == true && item['type'] == widget.type,
      );

      return isSelectedMonth && isRecordAction == true;
    }

    onTapMonthTitle() {
      onShowDateTimeDialog(
        context: context,
        view: DateRangePickerView.year,
        initialSelectedDate: selectedMonth,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          setState(() => selectedMonth = args.value);
          closeDialog(context);
        },
      );
    }

    List<RecordBox?> displayRecordList = recordList
        .where((record) => isDisplayRecord(record))
        .toList()
        .reversed
        .toList();

    return Expanded(
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            RowTitle(
              type: widget.type,
              selectedMonth: selectedMonth,
              onTap: onTapMonthTitle,
            ),
            Divider(color: Colors.grey.shade200),
            displayRecordList.isNotEmpty
                ? Expanded(
                    child: ListView(
                      children: displayRecordList
                          .map((record) => ColumnContainer(
                                recordInfo: record,
                                dateTime: record!.createDateTime,
                                type: widget.type,
                                actions: record.actions,
                              ))
                          .toList(),
                    ),
                  )
                : Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonIcon(
                          icon: todoData[widget.type]!.icon,
                          size: 20,
                          color: grey.original,
                        ),
                        SpaceHeight(height: 10),
                        CommonText(
                          text: '기록이 없어요.',
                          size: 15,
                          isCenter: true,
                          color: grey.original,
                        ),
                        SpaceHeight(height: 20),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

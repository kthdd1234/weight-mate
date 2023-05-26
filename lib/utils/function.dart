import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:intl/intl.dart';

getDateTimeToStr(DateTime dateTime) {
  DateFormat formatter = DateFormat('yyyy년 MM월 dd일');
  String strDateTime = formatter.format(dateTime);

  return strDateTime;
}

getDateTimeToSlash(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

  DateFormat formatter = DateFormat('yyyy/MM/dd');
  String strDateTime = formatter.format(dateTime);

  return strDateTime;
}

getStrToDateTime(String str) {
  DateTime dateTime = DateFormat('yyyy년 MM월 dd일').parse(str);
  return dateTime;
}

getDateTimeToMonthStr(DateTime dateTime) {
  DateFormat formatter = DateFormat('yyyy년 MM월');
  String strDateTimeMonth = formatter.format(dateTime);

  return strDateTimeMonth;
}

closeDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
}

isSelectedDate({
  required DateTime cellBuilderDate,
  required DateTime selectedDate,
}) {
  final isDateYear = cellBuilderDate.year == selectedDate.year;
  final isDateMonth = cellBuilderDate.month == selectedDate.month;
  final isDateDay = cellBuilderDate.day == selectedDate.day;

  return isDateYear && isDateMonth && isDateDay;
}

isMaxDate({
  required DateTime targetDateTime,
  required DateTime detailDateTime,
}) {
  DateFormat formatter = DateFormat('yyyyMMdd');
  int targetDateTimeToInt = int.parse(formatter.format(targetDateTime));
  int detailDateTimeToInt = int.parse(formatter.format(detailDateTime));

  return targetDateTimeToInt < detailDateTimeToInt;
}

handleCheckErrorText({
  required String text,
  required double min,
  required double max,
  required String errMsg,
}) {
  if (text != '') {
    double parseValue = double.parse(text);
    return min < parseValue && max > parseValue ? null : errMsg;
  }

  return null;
}

RecordInfoClass? getRecordInfoClass({
  required DateTime recordSelectedDateTime,
  required List<Map<String, dynamic>>? recordInfoList,
}) {
  if (recordInfoList == null) return null;

  final listObjToClass = recordInfoList.map(
    (item) => RecordInfoClass(
      recordDateTime: item['recordDateTime'],
      weight: item['weight'],
      dietPlanList: getDietPlanClassList(item['dietPlanList']),
      memo: item['memo'],
    ),
  );

  RecordInfoClass? recordInfoClass = listObjToClass.firstWhere(
    (element) =>
        getDateTimeToSlash(element.recordDateTime) ==
        getDateTimeToSlash(recordSelectedDateTime),
  );

  return recordInfoClass;
}

List<DietPlanClass> getDietPlanClassList(
  List<Map<String, dynamic>> dietPlanList,
) {
  return dietPlanList
      .map(
        (element) => DietPlanClass(
          id: element['id'],
          icon: IconData(
            element['iconCodePoint'],
            fontFamily: 'MaterialIcons',
          ),
          plan: element['plan'],
          isChecked: element['isChecked'],
          isAction: element['isAction'],
        ),
      )
      .toList();
  ;
}

int getRecordIndex({
  required DateTime dateTime,
  required List<Map<String, dynamic>> recordInfoList,
}) {
  return recordInfoList.indexWhere(
    (info) =>
        getDateTimeToSlash(dateTime) ==
        getDateTimeToSlash(
          info['recordDateTime'],
        ),
  );
}

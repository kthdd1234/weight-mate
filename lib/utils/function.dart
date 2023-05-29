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

getDateTimeToSlashYY(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

  DateFormat formatter = DateFormat('yy/MM/dd');
  String strDateTime = formatter.format(dateTime);

  return strDateTime;
}

timeToString(DateTime dateTime) {
  return DateFormat('a hh:mm').format(dateTime);
}

int getDateTimeToInt(DateTime? dateTime) {
  if (dateTime == null) {
    return 0;
  }

  DateFormat formatter = DateFormat('yyyyMMdd');
  String strDateTime = formatter.format(dateTime);

  return int.parse(strDateTime);
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

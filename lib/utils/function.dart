import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
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
  String dateTimeToStr = DateFormat('a hh:mm').format(dateTime);

  if (dateTimeToStr.contains('AM')) {
    return dateTimeToStr.replaceFirst(RegExp(r'AM'), '오전');
  }

  return dateTimeToStr.replaceFirst(RegExp(r'PM'), '오후');
}

stringToDouble(String? str) {
  if (str == null) return null;

  return double.parse(str);
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
}

showSnackBar({
  required BuildContext context,
  required String text,
  required double width,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        textColor: buttonBackgroundColor,
        label: '확인',
        onPressed: () {
          // Code to execute.
        },
      ),
      content: Text(text),
      duration: const Duration(milliseconds: 1500),
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

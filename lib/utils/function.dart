import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
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

dateTimeToDotYY(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

  DateFormat formatter = DateFormat('yy.MM.dd');
  String strDateTime = formatter.format(dateTime);

  return strDateTime;
}

timeToString(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

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

showSnackBar({
  required BuildContext context,
  required String text,
  required String buttonName,
  Function()? onPressed,
  double? width,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(text),
          TextButton(
              onPressed: onPressed,
              child: Text(
                buttonName,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ))
        ],
      ),
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

setStep({required ArgmentsTypeEnum argmentsType, required int step}) {
  return argmentsType == ArgmentsTypeEnum.start ? step : step - 1;
}

setRange({required ArgmentsTypeEnum argmentsType}) {
  return argmentsType == ArgmentsTypeEnum.start ? 4 : 3;
}

planTypeEnumToString(String str) {
  final map = {
    'PlanTypeEnum.diet': PlanTypeEnum.diet,
    'PlanTypeEnum.exercise': PlanTypeEnum.exercise,
    'PlanTypeEnum.lifestyle': PlanTypeEnum.lifestyle
  };
  final result = map[str];

  if (result == null) return PlanTypeEnum.none;
  return result;
}

planToActionPercent({required int a, required int b}) {
  final result = (a / b) * 100;
  final toFixed = double.parse(result.toStringAsFixed(1));

  return toFixed;
}

showAlarmBottomSheet({
  required BuildContext context,
  required DateTime initialDateTime,
  required Function(DateTime) onDateTimeChanged,
  required Function() onSubmit,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => DefaultBottomSheet(
      title: '알림 시간 설정',
      height: 380,
      contents: DefaultTimePicker(
        initialDateTime: initialDateTime,
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: onDateTimeChanged,
      ),
      isEnabled: true,
      submitText: '완료',
      onSubmit: onSubmit,
    ),
  );
}

// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/todo_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  String dateTimeToStr = DateFormat('a h:mm').format(dateTime);

  if (dateTimeToStr.contains('AM')) {
    return dateTimeToStr.replaceFirst(RegExp(r'AM'), '오전');
  }

  return dateTimeToStr.replaceFirst(RegExp(r'PM'), '오후');
}

timeToStringDetail(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

  String dateTimeToStr = DateFormat('MM월 dd일 a hh시 mm분').format(dateTime);

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

yToInt(DateTime? dateTime) {
  if (dateTime == null) {
    return 0;
  }

  DateFormat formatter = DateFormat('yyyy');
  String strDateTime = formatter.format(dateTime);

  return int.parse(strDateTime);
}

mToInt(DateTime? dateTime) {
  if (dateTime == null) {
    return 0;
  }

  DateFormat formatter = DateFormat('yyyyMM');
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

dateTimeToMMDDEE(DateTime dateTime) {
  DateFormat formatter = DateFormat('MM월 dd일 EE');
  String strDateTime = formatter.format(dateTime);
  List<String> split = strDateTime.split(' ');
  split[2] = dayOfWeek[split[2]]!;
  String join = split.join(' ');

  return '$join요일';
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
          Text(text).tr(),
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonName,
              style: const TextStyle(color: Colors.grey),
            ).tr(),
          )
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
  return 2;
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
  if (b == 0) return 0.0;

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
    builder: (context) => CommonBottomSheet(
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

ymd({required String locale, required DateTime dateTime}) {
  return DateFormat.yMMMd(locale).format(dateTime);
}

ym({required String locale, required DateTime dateTime}) {
  return DateFormat.yMMM(locale).format(dateTime);
}

md({required String locale, required DateTime dateTime}) {
  return DateFormat.MMMd(locale).format(dateTime);
}

mde({required String locale, required DateTime dateTime}) {
  return DateFormat.MMMEd(locale).format(dateTime);
}

m({required String locale, required DateTime dateTime}) {
  return DateFormat.MMMM(locale).format(dateTime);
}

y({required String locale, required DateTime dateTime}) {
  return DateFormat.y(locale).format(dateTime);
}

d({required String locale, required DateTime dateTime}) {
  return DateFormat.d(locale).format(dateTime);
}

e({required String locale, required DateTime dateTime}) {
  return DateFormat.EEEE(locale).format(dateTime);
}

e_short({required String locale, required DateTime dateTime}) {
  return DateFormat.E(locale).format(dateTime);
}

hm({required String locale, required DateTime dateTime}) {
  return DateFormat.jm(locale).format(dateTime);
}

m_d({required String locale, required DateTime dateTime}) {
  if (locale == 'ko') {
    return DateFormat('M.d', 'ko').format(dateTime);
  }

  return DateFormat.Md(locale).format(dateTime);
}

ymdShort({required String locale, required DateTime dateTime}) {
  return DateFormat.yMd(locale).format(dateTime);
}

dateTimeFormatter({required String format, required DateTime dateTime}) {
  DateFormat formatter = DateFormat(format, 'ko');
  String strDateTime = formatter.format(dateTime);

  return strDateTime;
}

jumpDayDateTime({
  required jumpDayTypeEnum type,
  required DateTime dateTime,
  required int days,
}) {
  Duration duration = Duration(days: days);

  return jumpDayTypeEnum.subtract == type
      ? dateTime.subtract(duration)
      : dateTime.add(duration);
}

daysBetween({
  required DateTime startDateTime,
  required DateTime endDateTime,
}) {
  return endDateTime.difference(startDateTime).inDays;
}

checkStringFirstDot(String value) {
  if (value == '' || value[0] == '.') {
    return true;
  }
}

uuid() {
  return DateTime.now().microsecondsSinceEpoch.toString();
}

isBetweenInDay({
  required DateTime importDateTime,
  required DateTime startDateTime,
  DateTime? endDateTime,
}) {
  bool isStart =
      getDateTimeToInt(startDateTime) <= getDateTimeToInt(importDateTime);
  bool isEnd = getDateTimeToInt(importDateTime) <=
      (endDateTime != null ? getDateTimeToInt(endDateTime) : 99999999);

  return isStart & isEnd;
}

dateTimeToTitle(DateTime dateTime) {
  if (getDateTimeToInt(dateTime) == getDateTimeToInt(DateTime.now())) {
    return '오늘의';
  }

  return dateTimeFormatter(format: 'MM월 dd일', dateTime: dateTime);
}

String weightNotifyTitle() {
  return '오늘의 체중 기록 알림 📝';
}

String weightNotifyBody() {
  return '지금 바로 체중을 기록해보세요!';
}

const planNotifyTitle = '목표 실천 알림 ⏰';

const planNotifyBody = '지금 바로 실천해보세요!';

calculatedGoalWeight({required double goalWeight, required double weight}) {
  double value = goalWeight - weight;
  String fixedValue = value.toStringAsFixed(1);
  String operator = goalWeight == weight
      ? ''
      : goalWeight > weight
          ? '+'
          : '';

  return '$operator$fixedValue';
}

initDateTime() {
  DateTime now = DateTime.now();

  return DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
  );
}

isCheckToday(DateTime targetDate) {
  final now = DateTime.now();

  return now.year == targetDate.year &&
      now.month == targetDate.month &&
      now.day == targetDate.day;
}

/**
   센티(cm) = 인치(inch) 곱하기 2.54
예를 들어, 14.5인치를 센티로 변환하려면
14.5 × 2.54 = 36.83 센치(cm)입니다.


인치(inch) = 센티(cm) 나누기 2.54
예를 들어, 36.83센치(cm)를 인치로 바꾸면
36.83 ÷ 2.54 = 14.5 인치(inch)입니다.
   */

bmi({
  required double tall,
  required String? tallUnit,
  required double? weight,
  required String? weightUnit,
}) {
  if (weight == null) {
    return '-';
  }

  if (tallUnit == 'inch') {
    tall = (tall * 2.54);
  }

  if (weightUnit == 'lb') {
    weight = weight * 0.45;
  }

  double cmToM = tall / 100;
  double bmi = weight / (cmToM * cmToM);
  String bmiToFixed = bmi.toStringAsFixed(1);

  return bmiToFixed;
}

NativeAd loadNativeAd({
  required String adUnitId,
  required Function() onAdLoaded,
  required Function() onAdFailedToLoad,
}) {
  return NativeAd(
    adUnitId: adUnitId,
    listener: NativeAdListener(
      onAdLoaded: (adLoaded) {
        log('$adLoaded loaded~~~!!');
        onAdLoaded();
      },
      onAdFailedToLoad: (ad, error) {
        log('$NativeAd failed to load: $error');
        onAdFailedToLoad();
        ad.dispose();
      },
    ),
    request: const AdRequest(),
    nativeTemplateStyle: NativeTemplateStyle(
      templateType: TemplateType.medium,
      mainBackgroundColor: typeBackgroundColor,
      cornerRadius: 5.0,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: themeColor,
        size: 16.0,
      ),
    ),
  )..load();
}

List<Widget>? onActionList({
  required List<Map<String, dynamic>>? actions,
  required String type,
  required Function({
    required String completedType,
    required String id,
    required String name,
    required DateTime actionDateTime,
    required String title,
  }) onRecordUpdate,
}) {
  final actionList = actions
      ?.where((item) => type == item['type'] && item['isRecord'] != null)
      .toList();

  actionList?.sort((itemA, itemB) => categoryOrders[itemA['title']]!
      .compareTo(categoryOrders[itemB['title']]!));

  final renderList = actionList
      ?.map((item) => Column(
            children: [
              RecordName(
                type: type,
                id: item['id'],
                name: item['name'],
                actionDateTime: item['actionDateTime'],
                onRecordUpdate: onRecordUpdate,
                title: item['title'],
                topTitle: todoData[type]!.title,
              ),
              SpaceHeight(height: 15)
            ],
          ))
      .toList();

  return renderList;
}

onActionCount(List<RecordBox> recordList, String planId) {
  int count = 0;

  recordList.forEach((record) {
    final actionList = record.actions;

    if (actionList != null) {
      actionList.forEach((action) {
        if (action['id'] == planId) {
          count += 1;
        }
      });
    }
  });

  return count;
}

isAmericanLocale({required String locale}) {
  List<String> americanLocales = ['en_US', 'ca_CA', 'gb_GB'];

  return americanLocales.contains(locale);
}

bool isDoubleTryParse({required String text}) {
  return double.tryParse(text) != null;
}

String? convertTall({required String unit, required String tall}) {
  double? tallValue = double.tryParse(tall);

  if (tallValue != null) {
    switch (unit) {
      case 'cm':
        return (tallValue * 2.54).toStringAsFixed(1);

      case 'inch':
        return (tallValue / 2.54).toStringAsFixed(1);

      default:
        return '0.0';
    }
  }

  return null;
}

String? convertWeight({required String unit, required String wegiht}) {
  double? weightValue = double.tryParse(wegiht);

  if (weightValue != null) {
    switch (unit) {
      case 'kg':
        return (weightValue / 2.2).toStringAsFixed(1);

      case 'lb':
        return (weightValue * 2.2).toStringAsFixed(1);

      default:
        return '0.0';
    }
  }

  return null;
}

bool isShowErorr({required String unit, required double? value}) {
  if (value == null || value < 1) return true;

  switch (unit) {
    case 'cm':
      return value >= cmMax;
    case 'inch':
      return value >= inchMax;
    case 'kg':
      return value >= kgMax;
    case 'lb':
      return value >= lbMax;
    default:
      return true;
  }
}

// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_is_empty
import 'dart:developer';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/components/picker/date_time_picker.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quiver/time.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

ymdeHm({required String locale, required DateTime? dateTime}) {
  if (dateTime == null) {
    return null;
  }

  return "${DateFormat.yMMMMEEEEd(locale).format(dateTime)} ${DateFormat.jm(locale).format(dateTime)}";
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

eShort({required String locale, required DateTime dateTime}) {
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

yyyyUnderMd({required String locale, required DateTime dateTime}) {
  return DateFormat(
    locale == 'ko' || locale == 'ja' ? 'yyyy\nM.d' : 'M.d\nyyyy',
    locale,
  ).format(dateTime);
}

yyyyUnderM({required String locale, required DateTime dateTime}) {
  return DateFormat(
    locale == 'ko' || locale == 'ja' ? 'yyyy\nMMMM' : 'M\nyyyy',
    locale,
  ).format(dateTime);
}

ymdeShort({required String locale, required DateTime dateTime}) {
  return DateFormat.yMEd(locale).format(dateTime);
}

ymdShort({required String locale, required DateTime dateTime}) {
  if (locale == 'ko') {
    return DateFormat('yyyy. M. d', 'ko').format(dateTime);
  }

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

calculatedWeight({required double fWeight, required double lWeight}) {
  double value = fWeight - lWeight;
  String fixedValue = value.toStringAsFixed(1);
  String operator = fWeight == lWeight
      ? ''
      : fWeight > lWeight
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
        backgroundColor: textColor,
        size: 16.0,
      ),
    ),
  )..load();
}

onAction({
  required List<Map<String, dynamic>>? actions,
  required String planId,
}) {
  if (actions == null) {
    return {'id': null, 'actionDateTime': null};
  }

  Map<String, dynamic> action = actions.firstWhere(
    (element) => element['id'] == planId,
    orElse: () => {'id': null, 'actionDateTime': null},
  );

  return action;
}

List<PlanBox> onPlanList({
  required List<PlanBox> planList,
  List<String>? orderList,
  List<Map<String, dynamic>>? actions,
}) {
  planList.sort((itemA, itemB) {
    int indexA = orderList?.indexOf(itemA.id) ?? 0;
    int indexB = orderList?.indexOf(itemB.id) ?? 0;

    return indexA.compareTo(indexB);
  });

  planList.sort((itemA, itemB) {
    bool isCheckedA =
        onAction(actions: actions, planId: itemA.id)['id'] != null;
    bool isCheckedB =
        onAction(actions: actions, planId: itemB.id)['id'] != null;

    return (isCheckedA == isCheckedB ? 0 : (isCheckedB ? 1 : -1));
  });

  return planList;
}

List<Map<String, dynamic>>? onOrderList({
  required List<Map<String, dynamic>>? actions,
  required String type,
  List<String>? dietRecordOrderList,
  List<String>? exerciseRecordOrderList,
}) {
  List<Map<String, dynamic>>? actionList = actions
      ?.where((item) => type == item['type'] && item['isRecord'] != null)
      .toList();

  List<String>? targetRecordOrderList =
      type == eDiet ? dietRecordOrderList : exerciseRecordOrderList;

  if (actionList != null && actionList.isNotEmpty) {
    if (targetRecordOrderList == null || targetRecordOrderList.isEmpty) {
      final createDateTime = actionList[0]['createDateTime'];
      final recordKey = getDateTimeToInt(createDateTime);
      final recordInfo = recordRepository.recordBox.get(recordKey);
      final initOrderList =
          actionList.map((action) => action['id'] as String).toList();

      type == eDiet
          ? recordInfo?.dietRecordOrderList = initOrderList
          : recordInfo?.exerciseRecordOrderList = initOrderList;
    } else {
      actionList.sort((actionA, actionB) {
        int indexA = targetRecordOrderList.indexOf(actionA['id']);
        int indexB = targetRecordOrderList.indexOf(actionB['id']);

        return indexA.compareTo(indexB);
      });
    }
  }

  return actionList;
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

String weekAndMonthActionCount({
  required DateTime importDateTime,
  required Box<RecordBox> recordBox,
  required String type,
  required String planId,
}) {
  DateTime startWeekDateTime = weeklyStartDateTime(importDateTime);
  DateTime startMonthDateTime =
      DateTime(importDateTime.year, importDateTime.month, 1);
  int monthDayLength = daysInMonth(importDateTime.year, importDateTime.month);
  int weekCount = 0;
  int monthCount = 0;

  length(DateTime dateTime, String planId) {
    int recordKey = getDateTimeToInt(dateTime);
    RecordBox? record = recordBox.get(recordKey);
    List<Map<String, dynamic>> actions = record?.actions ?? [];
    List<Map<String, dynamic>> filterActions = actions
        .where((action) =>
            action['isRecord'] != true &&
            action['type'] == type &&
            action['id'] == planId)
        .toList();

    return filterActions.length;
  }

  for (var day = 0; day < 7; day++) {
    DateTime targetWeekDateTime = startWeekDateTime.add(Duration(days: day));
    weekCount += length(targetWeekDateTime, planId);
  }

  for (var day = 0; day < monthDayLength; day++) {
    DateTime targetMonthDateTime = startMonthDateTime.add(Duration(days: day));
    monthCount += length(targetMonthDateTime, planId);
  }

  return '주 회, 월 회 실천'.tr(namedArgs: {
    "weekLength": '$weekCount',
    "monthLength": '$monthCount',
  });
}

List<Map<String, dynamic>> getFilterActions({
  required DateTime dateTime,
  required Box<RecordBox> recordBox,
  required String type,
}) {
  int recordKey = getDateTimeToInt(dateTime);
  RecordBox? record = recordBox.get(recordKey);
  List<Map<String, dynamic>> actions = record?.actions ?? [];
  List<Map<String, dynamic>> filterActions = actions
      .where((action) => action['isRecord'] != true && action['type'] == type)
      .toList();

  return filterActions;
}

getMonthActionCount({
  required Box<RecordBox> recordBox,
  required int year,
  required int month,
  required int lastDays,
  required String type,
}) {
  int length = 0;

  for (var day = 1; day <= lastDays; day++) {
    DateTime dateTime = DateTime(year, month, day);
    List<Map<String, dynamic>> filterActions = getFilterActions(
      dateTime: dateTime,
      recordBox: recordBox,
      type: type,
    );

    length += filterActions.length;
  }

  return length;
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

DateTime weeklyStartDateTime(DateTime dateTime) {
  if (dateTime.weekday == 7) {
    return dateTime;
  }

  return dateTime.subtract(Duration(days: dateTime.weekday));
}

DateTime weeklyEndDateTime(DateTime dateTime) {
  if (dateTime.weekday == 7) {
    return dateTime.add(const Duration(days: 6));
  }

  return dateTime.add(Duration(
    days: DateTime.daysPerWeek - dateTime.weekday - 1,
  ));
}

String ampmFormat(int hour) {
  return hour < 12 ? '오전' : '오후';
}

int hourTo24({required String ampm, required String hour}) {
  if (ampm == '오전') {
    if (hour == '12') {
      return 0;
    }

    return int.parse(hour);
  }

  return {
    '1': 13,
    '2': 14,
    '3': 15,
    '4': 16,
    '5': 17,
    '6': 18,
    '7': 19,
    '8': 20,
    '9': 21,
    '10': 22,
    '11': 23,
    '12': 12,
  }[hour]!;
}

minuteToInt({required String minute}) {
  if (minute == '00') {
    return 0;
  } else if (minute == '05') {
    return 5;
  }

  return int.parse(minute);
}

minuteTo5Min({required int min}) {
  if (min == 0) {
    return '00';
  } else if (min == 5) {
    return '05';
  }

  return '$min';
}

onCheckBox({
  required dynamic id,
  required bool newValue,
  required DateTime importDateTime,
}) async {
  Box<PlanBox> planBox = planRepository.planBox;
  Box<RecordBox> recordBox = recordRepository.recordBox;

  int recordKey = getDateTimeToInt(importDateTime);
  RecordBox? recordInfo = recordBox.get(recordKey);

  PlanBox? planInfo = planBox.get(id);
  DateTime now = DateTime.now();
  DateTime actionDateTime = DateTime(
    importDateTime.year,
    importDateTime.month,
    importDateTime.day,
    now.hour,
    now.minute,
  );

  if (planInfo == null) return;

  ActionItemClass actionItem = ActionItemClass(
    id: id,
    title: planInfo.title,
    type: planInfo.type,
    name: planInfo.name,
    priority: planInfo.priority,
    actionDateTime: actionDateTime,
    createDateTime: planInfo.createDateTime,
  );

  // 체크 on
  if (newValue == true) {
    HapticFeedback.mediumImpact();

    if (recordInfo == null) {
      await recordBox.put(
        recordKey,
        RecordBox(
          createDateTime: importDateTime,
          actions: [actionItem.setObject()],
        ),
      );
    } else {
      recordInfo.actions == null
          ? recordInfo.actions = [actionItem.setObject()]
          : recordInfo.actions!.add(actionItem.setObject());
    }
  }

  // 체크 off
  if (newValue == false) {
    recordInfo!.actions!.removeWhere((element) => element['id'] == id);

    if (recordInfo.actions!.isEmpty) {
      recordInfo.actions = null;
    }
  }

  await recordInfo?.save();
}

onShowDateTimeDialog({
  required BuildContext context,
  required DateRangePickerView view,
  required DateTime initialSelectedDate,
  required Function(DateRangePickerSelectionChangedArgs) onSelectionChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => CommonPopup(
      height: 400,
      child: DateTimePicker(
        view: view,
        initialSelectedDate: initialSelectedDate,
        onSelectionChanged: onSelectionChanged,
      ),
    ),
  );
}

String avgRecordFunc({required List<RecordBox> list}) {
  double sum = 0;
  list.forEach((record) => sum += record.weight!);

  return (sum / list.length).toStringAsFixed(1);
}

RecordBox maxRecordFunc({required List<RecordBox> list}) {
  return list.reduce((recordA, recordB) =>
      recordA.weight! > recordB.weight! ? recordA : recordB);
}

RecordBox minRecordFunc({required List<RecordBox> list}) {
  return list.reduce((recordA, recordB) =>
      recordA.weight! < recordB.weight! ? recordA : recordB);
}

Future<void> restoreHiveBox<T>(String boxName) async {
  final box = await Hive.openBox<T>(boxName);
  final boxPath = box.path;
  await box.close();

  if (boxPath == null) return;

  try {
    File('$boxPath/db_backup.hive').copy(boxPath);
  } finally {
    await Hive.openBox<T>(boxName);
  }
}

Future<bool> setPurchasePremium(Package package) async {
  try {
    CustomerInfo customerInfo = await Purchases.purchasePackage(package);
    return customerInfo.entitlements.all[entitlement_identifier]?.isActive ==
        true;
  } on PlatformException catch (e) {
    log('e =>> ${e.toString()}');
    return false;
  }
}

Future<bool> isPurchasePremium() async {
  try {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    return true;
    // return customerInfo.entitlements.all[entitlement_identifier]?.isActive ==
    //     true;
  } on PlatformException catch (e) {
    log('e =>> ${e.toString()}');
    return false;
  }
}

Future<bool> isPurchaseRestore() async {
  try {
    CustomerInfo customerInfo = await Purchases.restorePurchases();
    bool isActive =
        customerInfo.entitlements.all[entitlement_identifier]?.isActive == true;
    return isActive;
  } on PlatformException catch (e) {
    log('e =>> ${e.toString()}');
    return false;
  }
}

Future<bool> isHideAd() async {
  TrackingStatus trackingStatus =
      await AppTrackingTransparency.trackingAuthorizationStatus;
  String advertisingId =
      await AppTrackingTransparency.getAdvertisingIdentifier();
  bool isAuthorized = trackingStatus == TrackingStatus.authorized;
  bool isMyAdvertisingId =
      advertisingId == '5E188ADD-3D54-4140-97F7-AA5FAA0AD3B2';

  if (isAuthorized && isMyAdvertisingId) {
    return false;
  }

  return false;
}

String getFontFamily(String fontFamily) {
  int idx = fontFamilyList
      .indexWhere((element) => element['fontFamily'] == fontFamily);
  return idx != -1 ? fontFamily : initFontFamily;
}

String getFontName(String fontFamily) {
  int idx = fontFamilyList
      .indexWhere((element) => element['fontFamily'] == fontFamily);
  return idx != -1 ? fontFamilyList[idx]['name']! : initFontName;
}

ColorClass getColorClass(String? name) {
  if (name == null) {
    return indigo;
  }

  return colorList.firstWhere((info) => info.colorName == name);
}

SvgPicture getSvg({
  required String name,
  required double width,
  Color? color,
}) {
  return SvgPicture.asset(
    'assets/svgs/$name.svg',
    width: width,
    colorFilter:
        color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
  );
}

List<HashTagClass> getHashTagClassList(
  List<Map<String, dynamic>>? hashTagList,
) {
  if (hashTagList == null || hashTagList.length == 0) {
    return [];
  }

  return hashTagList
      .map((hashTag) => HashTagClass(
          id: hashTag['id'],
          text: hashTag['text'],
          colorName: hashTag['colorName']))
      .toList();
}

List<Map<String, String>> getHashTagMapList(
  List<HashTagClass> hashTagClassList,
) {
  return hashTagClassList
      .map((hashTag) => {
            'id': hashTag.id,
            'text': hashTag.text,
            'colorName': hashTag.colorName
          })
      .toList();
}

int getHashTagIndex(List<Map<String, dynamic>> hashTagList, String id) {
  return hashTagList.indexWhere((item) => item['id'] == id);
}

HashTagClass? getHashTag(List<Map<String, dynamic>>? hashTagList, String id) {
  if (hashTagList == null || hashTagList.length == 0) {
    return null;
  }

  int index = getHashTagIndex(hashTagList, id);
  return HashTagClass(
    id: id,
    text: hashTagList[index]['text'],
    colorName: hashTagList[index]['colorName'],
  );
}

List<RecordBox> getSearchList({
  required List<RecordBox> recordList,
  required String keyword,
  required bool isRecent,
}) {
  List<RecordBox> searchList = recordList.where((record) {
    List<Map<String, dynamic>>? actions = record.actions;
    String? whiteText = record.whiteText;
    List<Map<String, String>>? hashTagList = record.recordHashTagList;
    bool isKeywordInAction = actions?.any((action) {
          String name = action['name'] as String;
          return name.contains(keyword);
        }) ==
        true;
    bool isKeywordInWhiteText = whiteText?.contains(keyword) == true;
    bool isKeywordInHashTag =
        hashTagList?.any((hashTag) => hashTag['text']!.contains(keyword)) ==
            true;

    return isKeywordInAction || isKeywordInWhiteText || isKeywordInHashTag;
  }).toList();

  return isRecent ? searchList.reversed.toList() : searchList;
}

navigator({required BuildContext context, required Widget page}) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (BuildContext context) => page),
  );
}

getGraphX({
  required String locale,
  required bool isWeek,
  required String graphType,
  required DateTime dateTime,
}) {
  return isWeek && (graphType == eGraphDefault)
      ? d(locale: locale, dateTime: dateTime)
      : (graphType == eGraphCustom)
          ? yyyyUnderMd(locale: locale, dateTime: dateTime)
          : m_d(locale: locale, dateTime: dateTime);
}

rangeSegmented(SegmentedTypes segmented) {
  Map<SegmentedTypes, Widget> segmentedData = {
    SegmentedTypes.week: onSegmentedWidget(
      title: '일주일',
      type: SegmentedTypes.week,
      selected: segmented,
    ),
    SegmentedTypes.twoWeek: onSegmentedWidget(
      title: '2주',
      type: SegmentedTypes.twoWeek,
      selected: segmented,
    ),
    SegmentedTypes.month: onSegmentedWidget(
      title: '1개월',
      type: SegmentedTypes.month,
      selected: segmented,
    ),
    SegmentedTypes.threeMonth: onSegmentedWidget(
      title: '3개월',
      type: SegmentedTypes.threeMonth,
      selected: segmented,
    ),
    SegmentedTypes.sixMonth: onSegmentedWidget(
      title: '6개월',
      type: SegmentedTypes.sixMonth,
      selected: segmented,
    ),
    SegmentedTypes.oneYear: onSegmentedWidget(
      title: '1년',
      type: SegmentedTypes.oneYear,
      selected: segmented,
    ),
  };

  return segmentedData;
}

nullCheckAction(List<Map<String, dynamic>>? actions, String type) {
  if (actions == null) return null;

  return actions.firstWhere(
    (action) => action['type'] == type,
    orElse: () => {'type': null},
  )['type'];
}

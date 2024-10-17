import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:table_calendar/table_calendar.dart';

/// 5.0
const double tinySpace = 5.0;

/// 10.0
const double smallSpace = 10.0;

/// 15.0
const double contentSpace = 15.0;

/// 20.0
const double regularSapce = 20.0;

/// 40.0
const double largeSpace = 40.0;

/// textColor
const textColor = Colors.black;

/// submitButtonHeight
const double submitButtonHeight = 48.0;

/// pagePadding
const EdgeInsetsGeometry pagePadding = EdgeInsets.all(20.0);

/// submitButtonBoxPadding
const EdgeInsetsGeometry submitButtonBoxPadding =
    EdgeInsets.symmetric(horizontal: 20, vertical: 10);

// primaryColor
const primaryColor = Color(0xFF40465E);

/// themeColor
const themeColor = Color(0xFF404763);

/// buttonTextColor
const buttonTextColor = Color(0xFFFFFFFF);

/// disabledButtonBackgroundColor
const disabledButtonBackgroundColor = Color(0xFFEFF0F2);

/// disabledButtonTextColor
const disabledButtonTextColor = Color(0xFF9A9EAA);

/// typeBackgroundColor
const typeBackgroundColor = Color(0xffF9FAFB);

/// enabledTypeColor
const enabledTypeColor = Colors.grey;

/// disEnabledTypeColor
const disEnabledTypeColor = Color(0xff9A9EAA);

/// tallMin
const tallMin = 120.0;

/// tallMax
const tallMax = 220.0;

/// weightMin
const weightMin = 1.0;

/// weightMax
const weightMax = 200.0;

/// bodyFatMin
const bodyFatMin = 0.0;

/// bodyFatMax
const bodyFatMax = 100.0;

/// tallErrMsg
const tallErrMsg = '120 ~ 220 입력해주세요.';

/// weightErrMsg
const weightErrMsg = '20 ~ 200 입력해주세요.';

/// weightErrMsg2
const weightErrMsg2 = '20 ~ 200 사이의 값을 입력해주세요.';

/// tallHintText
const tallHintText = '키를 입력해주세요.';

/// weightHintText
const weightHintText = '체중을 입력해주세요.';

/// weightHintText
const goalWeightHintText = '목표 체중을 입력해주세요.';

/// bodyFatHintText
const bodyFatHintText = '체지방률을 입력해주세요.';

/// tallPrefixIcon
const tallPrefixIcon = Icons.accessibility_new;

/// weightPrefixIcon
const weightPrefixIcon = Icons.monitor_weight;

/// goalWeightPrefixIcon
const goalWeightPrefixIcon = Icons.flag;

/// bodyFatPrefixIcon
const bodyFatPrefixIcon = Icons.align_vertical_bottom;

/// tallMaxLength
const tallMaxLength = 5;

/// weightMaxLength
const weightMaxLength = 4;

/// bodyFatMaxLength
const bodyFatMaxLength = 4;

/// containerBorderRadious
final containerBorderRadious =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

/// inputContentPadding
const inputContentPadding = EdgeInsets.only(top: 10);

/// inputKeyboardType
const inputKeyboardType = TextInputType.numberWithOptions(decimal: true);

/// whiteBgBtnColor
const whiteBgBtnColor = Color(0xffF3F4F9);

/// weightColor
const weightColor = Colors.indigo;

/// actionColor
const actionColor = Colors.purple;

// eyeBodyColor
const eyeBodyColor = Colors.green;

/// diaryColor
const diaryColor = Colors.orange;

/// dietColor
const dietColor = Colors.teal; // 0xFF009688

/// exerciseColor
const exerciseColor = Colors.lightBlue; // 0xFF03A9F4

/// lifeStyleColor
const lifeStyleColor = Colors.brown; // 0xFF705548

/// enableTextColor
const enableTextColor = Color(0xff6237E2);

/// enableBackgroundColor
const enableBackgroundColor = Color(0xffEDE8FF);

/// appTextColor
const appTextColor = Color(0xffE0B1F6);

/// dietBgButtonColor
const dietBgButtonColor = Color.fromARGB(255, 233, 247, 247);

/// exerciseBgButtonColor
const exerciseBgButtonColor = Color.fromARGB(255, 234, 251, 255);

/// lifeBgButtonColor
const lifeBgButtonColor = Color.fromARGB(255, 242, 239, 237);

/// dietTextButtonColor
final dietTextButtonColor = Colors.teal.shade300;

/// exerciseTextButtonColor
final exerciseTextButtonColor = Colors.lightBlue.shade300;

/// lifeTextButtonColor
final lifeTextButtonColor = Colors.brown.shade300;

/// roundedRectangleBorder
final roundedRectangleBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

/// tagColors
final tagColors = {
  'default': {
    'bgColor': Colors.indigo.shade100,
    'textColor': Colors.white,
  },
  'green': {
    'bgColor': Colors.green.shade50, // E8F5E9
    'textColor': Colors.green.shade300, // 4CAF50
  },
  'red': {
    'bgColor': Colors.red.shade50,
    'textColor': Colors.red.shade300,
  },
  'blue': {
    'bgColor': Colors.blue.shade50,
    'textColor': Colors.blue.shade300,
  },
  'teal': {
    'bgColor': Colors.teal.shade50,
    'textColor': Colors.teal.shade300,
  }, // 009688
  'lightBlue': {
    'bgColor': Colors.lightBlue.shade50,
    'textColor': Colors.lightBlue.shade300,
  }, // 03A9F4
  'brown': {
    'bgColor': Colors.brown.shade50,
    'textColor': Colors.brown.shade300,
  }, // 795548
  'orange': {
    'bgColor': Colors.orange.shade50,
    'textColor': Colors.orange.shade300,
  },
  'deepOrange': {
    'bgColor': Colors.deepOrange.shade50,
    'textColor': Colors.deepOrange.shade300,
  },
  'purple': {
    'bgColor': Colors.purple.shade50,
    'textColor': Colors.purple.shade300,
  },
  'indigo': {
    'bgColor': Colors.indigo.shade50, //
    'textColor': Colors.indigo.shade300, //
  },
  'blueGrey': {
    'bgColor': Colors.blueGrey.shade50, // ECEFF1
    'textColor': Colors.blueGrey.shade300, // 90A4AE
  },
  'grey': {
    'bgColor': Colors.grey.shade200,
    'textColor': Colors.grey,
  },
  'whiteBlue': {
    'bgColor': Colors.blue.shade300,
    'textColor': Colors.white,
  },
  'whiteIndigo': {
    'bgColor': Colors.indigo.shade300,
    'textColor': Colors.white,
  },
  'whiteRed': {
    'bgColor': Colors.red.shade300,
    'textColor': Colors.white,
  },
  'whitePink': {
    'bgColor': Colors.pink.shade300,
    'textColor': Colors.white,
  },
  'whiteGrey': {
    'bgColor': Colors.grey.shade400,
    'textColor': Colors.white,
  },
  'whitePurple': {
    'bgColor': Colors.purple.shade400,
    'textColor': Colors.white,
  },
  'whiteBlueGrey': {
    'bgColor': Colors.blueGrey.shade400,
    'textColor': Colors.white,
  },
  'peach': {
    'bgColor': const Color.fromRGBO(255, 231, 217, 100),
    'textColor': const Color.fromRGBO(255, 170, 84, 100),
  },
  'whiteBlack': {
    'bgColor': Colors.white,
    'textColor': textColor,
  }
};

List<FilterClass> openClassList = [
  FilterClass(id: FILITER.weight.toString(), name: '체중'),
  FilterClass(id: FILITER.picture.toString(), name: '사진'),
  FilterClass(id: FILITER.diet.toString(), name: '식단'),
  FilterClass(id: FILITER.exercise.toString(), name: '운동'),
  FilterClass(id: FILITER.lifeStyle.toString(), name: '습관'),
  FilterClass(id: FILITER.diary.toString(), name: '일기'),
];

List<FilterClass> displayClassList = [
  FilterClass(id: FILITER.weight.toString(), name: '체중'),
  FilterClass(id: FILITER.picture.toString(), name: '사진'),
  FilterClass(id: FILITER.diet.toString(), name: '식단'),
  FilterClass(id: FILITER.exercise.toString(), name: '운동'),
  FilterClass(id: FILITER.lifeStyle.toString(), name: '습관'),
  FilterClass(id: FILITER.diary.toString(), name: '일기'),
];

List<FilterClass> historyDisplayClassList = [
  FilterClass(id: FILITER.weight.toString(), name: '체중'),
  FilterClass(id: FILITER.picture.toString(), name: '사진'),
  FilterClass(id: FILITER.diet.toString(), name: '식단 (기록)'),
  FilterClass(id: FILITER.diet_2.toString(), name: '식단 (목표)'),
  FilterClass(id: FILITER.exercise.toString(), name: '운동 (기록)'),
  FilterClass(id: FILITER.exercise_2.toString(), name: '운동 (목표)'),
  FilterClass(id: FILITER.lifeStyle.toString(), name: '습관'),
  FilterClass(id: FILITER.diary.toString(), name: '일기 (글, 감정)'),
  FilterClass(id: FILITER.diary_2.toString(), name: '일기 (해시태그)'),
];

List<FilterClass> searchDisplayClassList = [
  FilterClass(id: FILITER.weight.toString(), name: '체중'),
  FilterClass(id: FILITER.picture.toString(), name: '사진'),
  FilterClass(id: FILITER.diet.toString(), name: '식단 (기록)'),
  FilterClass(id: FILITER.diet_2.toString(), name: '식단 (목표)'),
  FilterClass(id: FILITER.exercise.toString(), name: '운동 (기록)'),
  FilterClass(id: FILITER.exercise_2.toString(), name: '운동 (목표)'),
  FilterClass(id: FILITER.lifeStyle.toString(), name: '습관'),
  FilterClass(id: FILITER.diary.toString(), name: '일기 (글, 감정)'),
  FilterClass(id: FILITER.diary_2.toString(), name: '일기 (해시태그)'),
];

List<FilterClass> trackerDisplayClassList = [
  FilterClass(id: FILITER.weight.toString(), name: '체중'),
  FilterClass(id: FILITER.picture.toString(), name: '사진'),
  FilterClass(id: FILITER.diet.toString(), name: '식단 (기록, 목표)'),
  FilterClass(id: FILITER.exercise.toString(), name: '운동 (기록, 목표)'),
  FilterClass(id: FILITER.diary.toString(), name: '일기 (글)'),
];

List<String> initOpenList = openClassList.map((e) => e.id).toList();
List<String> initDisplayList = displayClassList.map((e) => e.id).toList();
List<String> initHistoryDisplayList =
    historyDisplayClassList.map((e) => e.id).toList();
List<String> initSearchDisplayClassList =
    searchDisplayClassList.map((e) => e.id).toList();
List<String> initTrackerDisplayClassList =
    trackerDisplayClassList.map((e) => e.id).toList();

const availableCalendarFormats = {
  CalendarFormat.week: '1주일',
  CalendarFormat.twoWeeks: '2주일',
  CalendarFormat.month: '1개월',
};

const nextCalendarFormats = {
  CalendarFormat.week: CalendarFormat.twoWeeks,
  CalendarFormat.twoWeeks: CalendarFormat.month,
  CalendarFormat.month: CalendarFormat.week
};

const availableCalendarMaker = {
  CalendarMaker.sticker: '스티커',
  CalendarMaker.weight: '체중',
  CalendarMaker.picture: '사진'
};

const historyFilterFormats = {
  HistoryFilter.recent: '최신순',
  HistoryFilter.past: '과거순'
};

const nextHistoryFilter = {
  HistoryFilter.recent: HistoryFilter.past,
  HistoryFilter.past: HistoryFilter.recent
};

const trackerFilterFormats = {
  TrackerFilter.recent: '최신순',
  TrackerFilter.past: '과거순'
};

const nextTrackerFilter = {
  TrackerFilter.recent: TrackerFilter.past,
  TrackerFilter.past: TrackerFilter.recent
};

const searchFilterFormats = {
  SearchFilter.recent: '최신순',
  SearchFilter.past: '과거순'
};

const nextSearchFilter = {
  SearchFilter.recent: SearchFilter.past,
  SearchFilter.past: SearchFilter.recent
};

const TextTheme textTheme = TextTheme(
  // <-------- headline ----------> //
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),

  // <-------- title ----------> //
  titleLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  ),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),

  // <-------- label ----------> //
  labelLarge: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
  labelSmall: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  ),

  // <-------- body ----------> //
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
);

String newPasswordMsg = '새 비밀번호를 입력해주세요.';

String confirmPasswordMsg = '비밀번호를 한번 더 입력해주세요.';

String passwrodErrorMsg1 = '비밀번호가 일치하지 않습니다.';

// cmMax
double cmMax = 300;

// inchMax
double inchMax = 118;

// kgMax
double kgMax = 250;

// lbMax
double lbMax = 550;

List<DayColorClass> dayColors = [
  DayColorClass(type: "일", color: Colors.red.shade300),
  DayColorClass(type: "월", color: Colors.orange.shade300),
  DayColorClass(type: "화", color: Colors.yellow.shade300),
  DayColorClass(type: "수", color: Colors.green.shade300),
  DayColorClass(type: "목", color: Colors.blue.shade300),
  DayColorClass(type: "금", color: Colors.indigo.shade300),
  DayColorClass(type: "토", color: Colors.purple.shade300),
];

Map<int, Color> targetColors = {
  7: Colors.red.shade300,
  1: Colors.orange.shade300,
  2: Colors.yellow.shade300,
  3: Colors.green.shade300,
  4: Colors.blue.shade300,
  5: Colors.indigo.shade300,
  6: Colors.purple.shade300,
};

const entitlement_identifier = 'premium';

const appleApiKey = 'appl_vjYFXCKiODqbJjabYlqJnmlIMPj';

const googleApiKey = 'goog_hZufqNCKtbHhktACjnimKTANXzD';

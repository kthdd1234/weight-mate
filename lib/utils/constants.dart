import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

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

///

/// enabledTypeColor
const enabledTypeColor = Colors.grey;

/// disEnabledTypeColor
const disEnabledTypeColor = Color(0xff9A9EAA);

/// tallMin
const tallMin = 120.0;

/// tallMax
const tallMax = 220.0;

/// weightMin
const weightMin = 20.0;

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

// tallSuffixText
const tallSuffixText = 'cm';

// weightSuffixText
const weightSuffixText = 'kg';

// tallSuffixText
const bodyFatSuffixText = '%';

/// containerBorderRadious
final containerBorderRadious =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

/// inputContentPadding
const inputContentPadding = EdgeInsets.only(top: 10);

/// inputKeyboardType
const inputKeyboardType = TextInputType.numberWithOptions(decimal: true);

/// dialogBackgroundColor
const dialogBackgroundColor = Color(0xffF3F4F9);

/// weightColor
const weightColor = Colors.blueGrey;

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

/// tagColors
final tagColors = {
  'green': {
    'bgColor': Colors.green.shade50,
    'textColor': Colors.green,
  },
  'red': {
    'bgColor': Colors.red.shade50,
    'textColor': Colors.red.shade300,
  },
  'blue': {
    'bgColor': Colors.blue.shade50,
    'textColor': Colors.blue,
  },
  'teal': {
    'bgColor': Colors.teal.shade50,
    'textColor': Colors.teal.shade400,
  },
  'lightBlue': {
    'bgColor': Colors.lightBlue.shade50,
    'textColor': Colors.lightBlue.shade400,
  },
  'brown': {
    'bgColor': Colors.brown.shade50,
    'textColor': Colors.brown.shade400,
  },
  'orange': {
    'bgColor': Colors.orange.shade50,
    'textColor': Colors.orange.shade300,
  },
  'purple': {
    'bgColor': Colors.purple.shade50,
    'textColor': Colors.purple.shade300,
  },
  'indigo': {
    'bgColor': Colors.indigo.shade50,
    'textColor': Colors.indigo.shade400,
  },
  'grey': {
    'bgColor': Colors.grey.shade200,
    'textColor': Colors.grey,
  }
};

List<FilterClass> filterClassList = [
  FilterClass(id: FILITER.weight.toString(), name: '체중'),
  FilterClass(id: FILITER.emotion.toString(), name: '감정'),
  FilterClass(id: FILITER.picture.toString(), name: '사진'),
  FilterClass(id: FILITER.diary.toString(), name: '메모'),
  FilterClass(id: FILITER.diet.toString(), name: '식단'),
  FilterClass(id: FILITER.exercise.toString(), name: '운동'),
  FilterClass(id: FILITER.lifeStyle.toString(), name: '생활'),
];

List<String> initFilterList = filterClassList.map((e) => e.id).toList();

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:table_calendar/table_calendar.dart';
import 'enum.dart';

var dayOfWeek = {
  'Mon': '월',
  'Tue': '화',
  'Wed': '수',
  'Thu': '목',
  'Fri': '금',
  'Sat': '토',
  'Sun': '일'
};

// var planType = {
//   PlanTypeEnum.diet.toString(): PlanTypeEnum.diet,
//   PlanTypeEnum.exercise.toString(): PlanTypeEnum.exercise,
//   PlanTypeEnum.lifestyle.toString(): PlanTypeEnum.lifestyle,
// };

// var planPriorityInfos = [
//   planPrioritys[PlanPriorityEnum.high.toString()],
//   planPrioritys[PlanPriorityEnum.medium.toString()],
//   planPrioritys[PlanPriorityEnum.low.toString()],
// ];

// var planPrioritys = {
//   PlanPriorityEnum.high.toString(): PlanPriorityClass(
//     id: PlanPriorityEnum.high,
//     name: '높음',
//     desc: 'High',
//     icon: Icons.looks_one_outlined,
//     order: 1,
//     bgColor: Colors.red.shade50,
//     textColor: Colors.red,
//   ),
//   PlanPriorityEnum.medium.toString(): PlanPriorityClass(
//     id: PlanPriorityEnum.medium,
//     name: '중간',
//     desc: 'Medium',
//     icon: Icons.looks_two_outlined,
//     order: 2,
//     bgColor: Colors.indigo.shade50,
//     textColor: Colors.indigo,
//   ),
//   PlanPriorityEnum.low.toString(): PlanPriorityClass(
//     id: PlanPriorityEnum.low,
//     name: '낮음',
//     desc: 'Low',
//     icon: Icons.looks_3,
//     order: 3,
//     bgColor: Colors.blueGrey.shade50,
//     textColor: Colors.blueGrey,
//   ),
// };

Map<String, int> planOrder = {
  PlanTypeEnum.diet.toString(): 0,
  PlanTypeEnum.exercise.toString(): 1,
  PlanTypeEnum.lifestyle.toString(): 2,
};

List<SvgClass> emotionList = [
  SvgClass(emotion: 'slightly-smiling-face', name: '흐뭇'),
  SvgClass(emotion: 'grinning-face-with-smiling-eyes', name: '기쁨'),
  SvgClass(emotion: 'grinning-squinting-face', name: '짜릿'),
  SvgClass(emotion: 'kissing-face', name: '신남'),
  SvgClass(emotion: 'neutral-face', name: '보통'),
  SvgClass(emotion: 'amazed-face', name: '놀람'),
  SvgClass(emotion: 'anxious-face', name: '서운'),
  SvgClass(emotion: 'crying-face', name: '슬픔'),
  SvgClass(emotion: 'determined-face', name: '다짐'),
  SvgClass(emotion: 'disappointed-face', name: '실망'),
  SvgClass(emotion: 'dizzy-face', name: '피곤'),
  SvgClass(emotion: 'grinning-face-with-sweat', name: '다행'),
  SvgClass(emotion: 'expressionless-face', name: '고요'),
  SvgClass(emotion: 'face-blowing-a-kiss', name: '사랑'),
  SvgClass(emotion: 'sneezing-face', name: '아픔'),
  SvgClass(emotion: 'worried-face', name: '걱정'),
  SvgClass(emotion: 'winking-face-with-tongue', name: '장난'),
  SvgClass(emotion: 'face-with-steam-from-nose', name: '화남'),
  SvgClass(emotion: 'loudly-crying-face', name: '감동'),
  SvgClass(emotion: 'smiling-face-with-halo', name: '해탈'),
];

List<PlanItemClass> initPlanItemList = [
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '📝 아침에 체중 기록하기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '⏱️ 간헐적 단식 16:8',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '🥣 밥은 반 공기만 먹기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '🥦 현미밥 한 공기, 닭 가슴살 200g',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '🥗 하루 한끼 샐러드 먹기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '🍎 사과 1개, 달걀 2개',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '🥩 저탄고지 다이어트 실천',
  ),
  PlanItemClass(
    type: PlanTypeEnum.diet.toString(),
    name: '🍠 고구마 1개, 양상추, 식빵 2장',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '💊 영양제 매일 챙겨 먹기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.exercise.toString(),
    name: '🚶‍♀️ 하루 5000보 걷기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.exercise.toString(),
    name: '🏃‍♀️ 공원에서 30분 달리기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.exercise.toString(),
    name: '👟 엘리베이터 대신 계단 이용하기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.exercise.toString(),
    name: '🏋️ 헬스장에서 30분 이상 운동하기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.exercise.toString(),
    name: '🧘‍♀️ 잠들기 전 스트레칭 하기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.exercise.toString(),
    name: '🤸‍♀️ 홈 트레이닝 실천하기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '💧 하루 물 1.2L 이상 마시기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '☀️ 아침 공복에 물 한 잔 마시기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '🙅‍♀️ 하루 한 끼는 밀가루 안 먹기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '✍️ 자기 전, 내일 할 일 미리 정리해보기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '❗️ 밤 8시 이후로 음식 안먹기',
  ),
  PlanItemClass(
    type: PlanTypeEnum.lifestyle.toString(),
    name: '🥛 배고플 때 우유 한 잔 마시기',
  ),
];

Map<String, List<Map<String, dynamic>>> category = {
  PlanTypeEnum.diet.toString(): [
    {
      'icon': categoryIcons['아침'],
      'title': "아침",
    },
    {
      'icon': categoryIcons['점심'],
      'title': "점심",
    },
    {
      'icon': categoryIcons['저녁'],
      'title': "저녁",
    },
    {
      'icon': categoryIcons['간식'],
      'title': "간식",
      'last': true,
    },
  ],
  PlanTypeEnum.exercise.toString(): [
    {
      'icon': categoryIcons['유산소 운동'],
      'title': "유산소 운동",
    },
    {
      'icon': categoryIcons['근력 운동'],
      'title': "근력 운동",
    },
    {
      'icon': categoryIcons['스트레칭'],
      'title': "스트레칭",
      'last': true,
    },
  ],
};

final categoryOrders = {
  "아침": 0,
  "점심": 1,
  "저녁": 2,
  "간식": 3,
  '유산소 운동': 4,
  '근력 운동': 5,
  '스트레칭': 6,
};

final categoryIcons = {
  "아침": Icons.light_mode_outlined,
  "점심": Icons.filter_drama_outlined,
  "저녁": Icons.dark_mode_outlined,
  "간식": Icons.takeout_dining_outlined,
  '유산소 운동': Icons.directions_run,
  '근력 운동': Icons.fitness_center,
  '스트레칭': Icons.accessibility_new,
};

final categoryColors = {
  PlanTypeEnum.diet.toString(): Colors.teal,
  PlanTypeEnum.exercise.toString(): Colors.lightBlue,
};

final formatInfo = {
  CalendarFormat.week.toString(): CalendarFormat.week,
  CalendarFormat.twoWeeks.toString(): CalendarFormat.twoWeeks,
  CalendarFormat.month.toString(): CalendarFormat.month,
};

final makerInfo = {
  CalendarMaker.sticker.toString(): CalendarMaker.sticker,
  CalendarMaker.weight.toString(): CalendarMaker.weight
};

final localeNames = ['ko_KR', 'en_US', 'ja_JP', 'fr_FR', 'es_ES', 'de_DE'];

final localeDisplayNames = {
  'ko_KR': '한국어',
  'en_US': 'English',
  'ja_JP': '日本語',
  'fr_FR': 'français',
  'es_ES': 'espagnol',
  'de_DE': 'Deutsch',
};

final languageItemList = [
  LanguageItemClass(
    name: '한국어',
    languageCode: 'ko',
    countryCode: 'KR',
  ),
  LanguageItemClass(
    name: 'English',
    languageCode: 'en',
    countryCode: 'US',
  ),
  LanguageItemClass(
    name: '日本語',
    languageCode: 'ja',
    countryCode: 'JP',
  ),
  LanguageItemClass(
    name: 'Deutsch',
    languageCode: 'de',
    countryCode: 'DE',
  ),
  LanguageItemClass(
    name: 'français',
    languageCode: 'fr',
    countryCode: 'FR',
  ),
  LanguageItemClass(
    name: 'espagnol',
    languageCode: 'es',
    countryCode: 'ES',
  ),
];

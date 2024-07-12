import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
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
  SvgClass(emotion: 'Face-Savoring-Food--Streamline-Emoji', name: '재미'),
  SvgClass(emotion: 'Full-Moon-Face--Streamline-Emoji', name: '기대'),
  SvgClass(emotion: 'Hushed-Face-1--Streamline-Emoji', name: '의아'),
  SvgClass(emotion: 'Nauseated-Face-2--Streamline-Emoji', name: '살찜'),
  SvgClass(emotion: 'Pouting-Face--Streamline-Emoji', name: '억울'),
  SvgClass(
      emotion: 'Smiling-Face-With-Sunglasses--Streamline-Emoji', name: '당당'),
  SvgClass(emotion: 'Winking-Face--Streamline-Emoji', name: '친근'),
  SvgClass(emotion: 'Drooling-Face-1--Streamline-Emoji', name: '상쾌'),
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

Map<String, List<Map<String, dynamic>>> fastingCategory = {
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
      'last': true,
    },
  ],
};

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

Map<String, IconData> categoryIcons = {
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
  PlanTypeEnum.lifestyle.toString(): Colors.brown,
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

final localeNames = [
  'ko',
  'en',
  'ja',
  // 'fr_FR',
  // 'es_ES',
  // 'de_DE',
];

final localeDisplayNames = {
  'ko': '한국어',
  'en': 'English',
  'ja': '日本語',
  // 'fr_FR': 'français',
  // 'es_ES': 'espagnol',
  // 'de_DE': 'Deutsch',
};

final languageItemList = [
  LanguageItemClass(
    name: '한국어',
    languageCode: 'ko',
  ),
  LanguageItemClass(
    name: 'English',
    languageCode: 'en',
  ),
  LanguageItemClass(
    name: '日本語',
    languageCode: 'ja',
  ),
  // LanguageItemClass(
  //   name: 'Deutsch',
  //   languageCode: 'de',
  // ),
  // LanguageItemClass(
  //   name: 'français',
  //   languageCode: 'fr',
  // ),
  // LanguageItemClass(
  //   name: 'espagnol',
  //   languageCode: 'es',
  // ),
];

Map<String, TodoDataClass> todoData = {
  PlanTypeEnum.diet.toString(): TodoDataClass(
    filterId: FILITER.diet.toString(),
    color: 'teal',
    title: '식단',
    icon: Icons.local_dining,
  ),
  PlanTypeEnum.exercise.toString(): TodoDataClass(
    filterId: FILITER.exercise.toString(),
    color: 'lightBlue',
    title: '운동',
    icon: Icons.fitness_center,
  ),
  PlanTypeEnum.lifestyle.toString(): TodoDataClass(
    filterId: FILITER.lifeStyle.toString(),
    color: 'brown',
    title: '습관',
    icon: Icons.self_improvement,
  )
};

String eDiet = PlanTypeEnum.diet.toString();
String eExercise = PlanTypeEnum.exercise.toString();
String eLife = PlanTypeEnum.lifestyle.toString();

Map<int, String> hourTo12 = {
  0: '12',
  1: "1",
  2: '2',
  3: '3',
  4: '4',
  5: '5',
  6: '6',
  7: '7',
  8: '8',
  9: '9',
  10: '10',
  11: '11',
  12: '12',
  13: '1',
  14: '2',
  15: '3',
  16: '4',
  17: '5',
  18: '6',
  19: '7',
  20: '8',
  21: '9',
  22: '10',
  23: '11',
};

String initFontFamily = 'IM_Hyemin';
String initFontName = 'IM 혜민';

List<Map<String, String>> fontFamilyList = [
  {
    "fontFamily": "IM_Hyemin",
    "name": "IM 혜민",
  },
  {
    "fontFamily": "KyoboHandwriting2022khn",
    "name": "교보 손글씨",
  },
  {
    "fontFamily": "TDTDTadakTadak",
    "name": "타닥타닥체",
  },
  {
    "fontFamily": "SingleDay",
    "name": "싱글데이",
  },
  {
    "fontFamily": "Cafe24Dongdong",
    "name": "카페24 동동",
  },
  {
    "fontFamily": "Cafe24Syongsyong",
    "name": "카페24 숑숑",
  },
  {
    "fontFamily": "Cafe24Ssukssuk",
    "name": "카페24 쑥쑥",
  },
  {
    "fontFamily": "cafe24Ohsquareair",
    "name": "카페24 아네모네 에어",
  },
];

String fWeight = FILITER.weight.toString();
String fDiet = FILITER.diet.toString();
String fExercise = FILITER.exercise.toString();
String fLife = FILITER.lifeStyle.toString();

List<PremiumBenefitsClass> premiumBenefitsClassList = [
  PremiumBenefitsClass(
    svgName: 'premium-free',
    title: '평생 무료로 이용 할 수 있어요',
    subTitle: '커피 한잔의 가격으로 단 한번 결제!',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-no-ads',
    title: '모든 화면에서 광고가 나오지 않아요',
    subTitle: '광고없이 쾌적하게 앱을 사용해보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-category-detail',
    title: '좀 더 자세한 통계 기능을 제공해드려요',
    subTitle: '체중 통계표, 체중 분석표, 기록 모아보기, 실천 모아보기 등',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-photos-four',
    title: '사진을 최대 4장까지 추가 할 수 있어요',
    subTitle: '보다 많은 식단, 운동, 눈바디 사진을 추가해보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'custom-graph',
    title: '체중 그래프에서 원하는 기간을 설정할 수 있어요',
    subTitle: '시작일/종료일을 설정해서 원하는 기간을 한눈에 보세요!',
  ),
];

String eGraphDefault = graphType.Default.toString();

String eGraphCustom = graphType.Custom.toString();

Map<String, Map<String, Color>> goalButtonColors = {
  eDiet: {
    'bgColor': dietBgButtonColor,
    'textColor': dietTextButtonColor,
  },
  eExercise: {
    'bgColor': exerciseBgButtonColor,
    'textColor': exerciseTextButtonColor,
  },
  eLife: {
    'bgColor': lifeBgButtonColor,
    'textColor': lifeTextButtonColor,
  }
};

List<String> initHashTagList = [
  '#살빠짐',
  '#오운완',
  '#치팅데이',
  '#꿀잠',
  '#홈트',
  '#산책',
  '#폭식',
  '#간헐적단식',
  '#생리',
  '#감기',
  '#스트레스',
  '#두통',
  '#증량',
  '#체함',
  '#변기',
];

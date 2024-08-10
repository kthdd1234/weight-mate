import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/maker/PictureMaker.dart';
import 'package:flutter_app_weight_management/components/maker/StickerMaker.dart';
import 'package:flutter_app_weight_management/components/maker/WeightMaker.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/graph_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/history_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/setting/setting_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/tracker/tracker_body.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  CalendarMaker.weight.toString(): CalendarMaker.weight,
  CalendarMaker.picture.toString(): CalendarMaker.picture,
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
String fPicture = FILITER.picture.toString();
String fDiet = FILITER.diet.toString();
String fExercise = FILITER.exercise.toString();
String fDiet_2 = FILITER.diet_2.toString();
String fExercise_2 = FILITER.exercise_2.toString();
String fLife = FILITER.lifeStyle.toString();
String fDiary = FILITER.diary.toString();
String fDiary_2 = FILITER.diary_2.toString();

List<PremiumBenefitsClass> premiumBenefitsClassList = [
  PremiumBenefitsClass(
    svgName: 'premium-free',
    title: '평생 무료로 이용 할 수 있어요',
    subTitle: '깔끔하게 단 한번 결제! ',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-no-ads',
    title: '모든 화면에서 광고가 나오지 않아요',
    subTitle: '광고없이 쾌적하게 앱을 사용해보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-category-detail',
    title: '모아보기 기능을 이용할 수 있어요',
    subTitle: '체중, 식단, 운동, 습관, 일기 모아보기 등',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-photos-four',
    title: '사진을 최대 4장까지 추가 할 수 있어요',
    subTitle: '보다 많은 식단, 운동, 눈바디 사진을 추가해보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'theme',
    title: '다양한 테마들을 제공해드려요',
    subTitle: '총 6종의 다채로운 배경 테마들을 이용해보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'custom-graph',
    title: '체중 그래프 기간을 설정 할 수 있어요',
    subTitle: '시작일/종료일을 설정해서 원하는 기간을 한눈에 보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'premium-search',
    title: '키워드 검색 기능을 제공해드려요',
    subTitle: '검색을 통해 이전의 기록을 빠르게 확인해보세요!',
  ),
  PremiumBenefitsClass(
    svgName: 'app-start',
    title: '앱 시작 시 원하는 화면을 바로 볼 수 있어요',
    subTitle: '기록, 히스토리, 그래프, 검색 화면 중 한 곳 선택!',
  ),
];

String eGraphDefault = graphType.Default.toString();

String eGraphCustom = graphType.Custom.toString();

String cGraphWeight = GraphCategory.weight.toString();

String cGraphWork = GraphCategory.work.toString();

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

List<HashTagClass> initHashTagList = [
  HashTagClass(id: '살빠짐', text: '살빠짐'.tr(), colorName: '청록색'),
  HashTagClass(id: '오운완', text: '오운완'.tr(), colorName: '청록색'),
  HashTagClass(id: '치팅데이', text: '치팅데이'.tr(), colorName: '청록색'),
  HashTagClass(id: '꿀잠', text: '꿀잠'.tr(), colorName: '청록색'),
  HashTagClass(id: '홈트', text: '홈트'.tr(), colorName: '청록색'),
  HashTagClass(id: '산책', text: '산책'.tr(), colorName: '청록색'),
  HashTagClass(id: '폭식', text: '폭식'.tr(), colorName: '파란색'),
  HashTagClass(id: '간헐적단식', text: '간헐적단식'.tr(), colorName: '파란색'),
  HashTagClass(id: '생리', text: '생리'.tr(), colorName: '파란색'),
  HashTagClass(id: '감기', text: '감기'.tr(), colorName: '빨간색'),
  HashTagClass(id: '스트레스', text: '스트레스'.tr(), colorName: '빨간색'),
  HashTagClass(id: '두통', text: '두통'.tr(), colorName: '빨간색'),
  HashTagClass(id: '증량', text: '증량'.tr(), colorName: '보라색'),
  HashTagClass(id: '체함', text: '체함'.tr(), colorName: '보라색'),
  HashTagClass(id: '변비', text: '변비'.tr(), colorName: '보라색'),
];

final indigo = ColorClass(
  colorName: '남색',
  original: Colors.indigo, // 63, 81, 181
  s50: Colors.indigo.shade50, // 232, 234, 246
  s100: Colors.indigo.shade100, // 197, 202, 233
  s200: Colors.indigo.shade200, // 159, 168, 218
  s300: Colors.indigo.shade300, // 255, 121, 134, 203
  s400: Colors.indigo.shade400,
);

final green = ColorClass(
  colorName: '녹색',
  original: Colors.green,
  s50: Colors.green.shade50,
  s100: Colors.green.shade100,
  s200: Colors.green.shade200, // 165, 214, 167
  s300: Colors.green.shade300,
  s400: Colors.green.shade400,
); //

final teal = ColorClass(
  colorName: '청록색',
  original: Colors.teal,
  s50: Colors.teal.shade50,
  s100: Colors.teal.shade100, // 178, 223, 219
  s200: Colors.teal.shade200, // 128, 203, 196
  s300: Colors.teal.shade300, // 255, 77, 182, 172
  s400: Colors.teal.shade400,
); //

final red = ColorClass(
  colorName: '빨간색',
  original: Colors.red,
  s50: Colors.red.shade50,
  s100: Colors.red.shade100, // 255, 205, 210
  s200: Colors.red.shade200, // 239, 154, 154
  s300: Colors.red.shade300, // 229, 115, 115
  s400: Colors.red.shade400,
); //

final pink = ColorClass(
  colorName: '핑크색',
  original: Colors.pink,
  s50: Colors.pink.shade50,
  s100: Colors.pink.shade100,
  s200: Colors.pink.shade200,
  s300: Colors.pink.shade300,
  s400: Colors.pink.shade400,
); //

final blue = ColorClass(
  colorName: '파란색',
  original: Colors.blue, // 33, 150, 243
  s50: Colors.blue.shade50, // 227, 242, 253
  s100: Colors.blue.shade100, // 187, 222, 251
  s200: Colors.blue.shade200, // 144, 202, 249
  s300: Colors.blue.shade300, // 100, 181, 246
  s400: Colors.blue.shade400, // 66, 165, 245
); //

final brown = ColorClass(
  colorName: '갈색',
  original: Colors.brown,
  s50: Colors.brown.shade50,
  s100: Colors.brown.shade100, // 215, 204, 200
  s200: Colors.brown.shade200, // 188, 170, 164
  s300: Colors.brown.shade300,
  s400: Colors.brown.shade400,
); //

final orange = ColorClass(
  colorName: '주황색',
  original: Colors.orange,
  s50: Colors.orange.shade50,
  s100: Colors.orange.shade100, // 255, 224, 178
  s200: Colors.orange.shade200, // 255, 204, 128
  s300: Colors.orange.shade300,
  s400: Colors.orange.shade400,
); //

final purple = ColorClass(
  colorName: '보라색',
  original: Colors.purple,
  s50: Colors.purple.shade50,
  s100: Colors.purple.shade100, // 225, 190, 231
  s200: Colors.purple.shade200, // 206, 147, 216
  s300: Colors.purple.shade300,
  s400: Colors.purple.shade400,
); //

final grey = ColorClass(
  colorName: '회색',
  original: Colors.grey.shade600,
  s50: Colors.grey.shade50,
  s100: Colors.grey.shade100,
  s200: Colors.grey.shade200,
  s300: Colors.grey.shade300,
  s400: Colors.grey.shade400,
); //

final lime = ColorClass(
  colorName: '라임색',
  original: Colors.lime,
  s50: Colors.lime.shade50,
  s100: Colors.lime.shade100,
  s200: Colors.lime.shade200,
  s300: Colors.lime.shade300,
  s400: Colors.lime.shade400,
); //

final cyan = ColorClass(
  colorName: '민트색',
  original: Colors.cyan,
  s50: Colors.cyan.shade50, // 224, 247, 250
  s100: Colors.cyan.shade100, // 178, 235, 242
  s200: Colors.cyan.shade200, // 128, 222, 234
  s300: Colors.cyan.shade300, // 77, 208, 225
  s400: Colors.cyan.shade400, // 38, 198, 218
); //

final ember = ColorClass(
  colorName: '노랑색',
  original: Colors.amber,
  s50: Colors.amber.shade50,
  s100: Colors.amber.shade100,
  s200: Colors.amber.shade200,
  s300: Colors.amber.shade300,
  s400: Colors.amber.shade400,
); //

final blueGrey = ColorClass(
  colorName: '청회색',
  original: Colors.blueGrey,
  s50: Colors.blueGrey.shade50, // 236, 239, 241
  s100: Colors.blueGrey.shade100, // 207, 216, 200
  s200: Colors.blueGrey.shade200, // 176, 190, 197
  s300: Colors.blueGrey.shade300,
  s400: Colors.blueGrey.shade400,
); //

final lightBlue = ColorClass(
  colorName: 'lightBlue',
  original: Colors.lightBlue,
  s50: Colors.lightBlue.shade50,
  s100: Colors.lightBlue.shade100,
  s200: Colors.lightBlue.shade200,
  s300: Colors.lightBlue.shade300,
  s400: Colors.lightBlue.shade400,
);

final colorList = [
  indigo,
  red,
  pink,
  green,
  teal,
  blue,
  brown,
  orange,
  purple,
  blueGrey
];

List<Widget> bodyList = const [
  RecordBody(),
  HistoryBody(),
  GraphBody(),
  TrackerBody(),
  SettingBody()
];

List<BNClass> bnList = [
  BNClass(index: 0, name: '기록', icon: Icons.edit_rounded),
  BNClass(index: 1, name: '히스토리', icon: Icons.view_timeline_outlined),
  BNClass(index: 2, name: '그래프', icon: FontAwesomeIcons.chartLine),
  BNClass(index: 3, name: '트래커', icon: Icons.view_agenda_outlined),
  BNClass(index: 4, name: '설정', icon: Icons.settings_rounded),
];

Map<int, BottomNavigationEnum> indexToBn = {
  0: BottomNavigationEnum.record,
  1: BottomNavigationEnum.history,
  2: BottomNavigationEnum.graph,
  3: BottomNavigationEnum.search,
  4: BottomNavigationEnum.setting
};

Map<int, String> indexToName = {
  0: '기록',
  1: '히스토리',
  2: '그래프',
  3: '트래커',
  4: '설정'
};
List<BottomNavigationBarItem> items = bnList
    .map(
      (bn) => BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: bn.index == 2 ? 3 : 0),
          child: Icon(bn.icon, size: bn.index == 2 ? 17 : null),
        ),
        label: bn.name.tr(),
      ),
    )
    .toList();

final themeClassList = [
  [
    ThemeClass(path: '1', name: 'Cloudy Apple'),
    ThemeClass(path: '2', name: 'Snow Again'),
  ],
  [
    ThemeClass(path: '3', name: 'Pastel Sky'),
    ThemeClass(path: '4', name: 'Winter Sky'),
  ],
  [
    ThemeClass(path: '5', name: 'Perfect White'),
    ThemeClass(path: '6', name: 'Kind Steel'),
  ],
];

List<CalendarMakerClass> calendarMakerList = [
  CalendarMakerClass(
    id: CalendarMaker.sticker.toString(),
    title: '스티커',
    desc: '카테고리별 스티커',
    widget: Padding(
      padding: const EdgeInsets.only(left: 3, top: 2),
      child: StickerMaker(
        mainAxisAlignment: MainAxisAlignment.center,
        row1: const ['indigo', 'purple', 'teal'],
        row2: const ['lightBlue', 'brown', 'orange'],
      ),
    ),
  ),
  CalendarMakerClass(
    id: CalendarMaker.weight.toString(),
    title: '체중',
    desc: '날짜별 체중',
    widget: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: WeightMaker(weight: 0.0, weightUnit: 'kg'),
    ),
  ),
  CalendarMakerClass(
    id: CalendarMaker.picture.toString(),
    title: '사진',
    desc: '날짜별 사진 한장',
    widget: PictureMaker(path: 'saled', size: 22.5),
  ),
];

Map<SegmentedTypes, int> rangeInfo = {
  SegmentedTypes.week: 6,
  SegmentedTypes.twoWeek: 13,
  SegmentedTypes.month: 29,
  SegmentedTypes.threeMonth: 89,
  SegmentedTypes.sixMonth: 179,
  SegmentedTypes.oneYear: 364,
};

List<TableTitleClass> trackerTitleClassList = [
  TableTitleClass(id: 'dateTime', title: '날짜', width: 90),
  TableTitleClass(id: FILITER.weight.toString(), title: '체중', width: 52),
  TableTitleClass(id: FILITER.picture.toString(), title: '사진'),
  TableTitleClass(id: FILITER.diet.toString(), title: '식단'),
  TableTitleClass(id: FILITER.exercise.toString(), title: '운동'),
  TableTitleClass(id: FILITER.diary.toString(), title: '일기', width: 100),
];

Map<String, int> filterIndex = {
  fWeight: 1,
  fPicture: 2,
  fDiet: 3,
  fExercise: 4,
  fDiary: 5
};

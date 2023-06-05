import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'enum.dart';

var todayOfWiseSayingList = [
  WiseSayingClass(wiseSaying: '나를 배부르게 하는 것들이 나를 파괴한다.', name: '안젤리나 졸리'),
  WiseSayingClass(wiseSaying: '태어나서 한번도 야식을 먹어본 적이 없어요.', name: '김연아'),
  WiseSayingClass(wiseSaying: '인생은 살이 쪘을 때와 안 졌을 때로 나뉜다.', name: '이소라'),
  WiseSayingClass(wiseSaying: '하얀 음식은 절대 안먹어요. 그건 독이니까요.', name: '미란다 커'),
  WiseSayingClass(wiseSaying: '운동이 끝나고 먹는 거기까지가 운동이다.', name: '김종국'),
  WiseSayingClass(wiseSaying: '먹어봤자 내가 아는 그 맛이다.', name: '옥주현'),
  WiseSayingClass(wiseSaying: '세끼 다 먹으면 살쪄요.', name: '김사랑'),
  WiseSayingClass(wiseSaying: '먹고 싶은 걸 다 먹되 아주 조금만 먹는다.', name: 'AOA 설현'),
  WiseSayingClass(wiseSaying: '죽을 만큼 운동하고 죽지 않을 만큼 먹었어요.', name: '제시카'),
  WiseSayingClass(wiseSaying: '먹는거요? 귀찮아요.', name: '김민희'),
];

var mainActEtc = {
  MainActTypes.diet: '를',
  MainActTypes.exercise: '을',
  MainActTypes.lifestyle: '을',
};

var mainAcyTypeClassList = [
  ActTypeClass(
    id: MainActTypes.diet,
    title: '식이요법',
    desc: '간헐적 단식, 밥 반공기만 먹기 등',
    icon: Icons.dining_outlined,
  ),
  ActTypeClass(
    id: MainActTypes.exercise,
    title: '운동',
    desc: '헬스, 러닝, 산책, 필라테스 등',
    icon: Icons.fitness_center,
  ),
  ActTypeClass(
    id: MainActTypes.lifestyle,
    title: '생활습관',
    desc: '아침에 체중 기록하기, 야식 금지 등',
    icon: Icons.home,
  ),
];

var subActTypeClassList = {
  MainActTypes.diet: dietItemTypeClassList,
  MainActTypes.exercise: exerciseItemTypeClassList,
  MainActTypes.lifestyle: lifeStyleItemTypeClassList,
};

var initItemType = {
  MainActTypes.diet: 'intermittentFasting',
  MainActTypes.exercise: 'health',
  MainActTypes.lifestyle: 'weightRecord',
};

var mainActTypeCounterText = {
  MainActTypes.diet: '(예: 황제 다이어트, 반공기 다이어트 등)',
  MainActTypes.exercise: '(예: 등산, 수영, 테니스 등)',
  MainActTypes.lifestyle: '(예: 저녁에 샐러드 먹기, 다이어트 기간 중 술 안먹기 등)',
};

var dietItemTypeClassList = [
  ActItemClass(
    id: 'intermittentFasting',
    title: '간헐적 단식',
    desc1: '공복을 유지하는',
    desc2: '식이요법',
    icon: Icons.alarm_outlined,
  ),
  ActItemClass(
    id: 'halfRice',
    title: '밥 반공기만 먹기',
    desc1: '매 끼니마다',
    desc2: '밥은 반만 먹기',
    icon: Icons.rice_bowl_outlined,
  ),
  ActItemClass(
    id: 'ketogenic',
    title: '저탄고지 다이어트',
    desc1: '저탄수화물 고지방',
    desc2: '식이요법',
    icon: Icons.savings_outlined,
  ),
  ActItemClass(
    id: 'EveningSaled',
    title: '저녁 식사 샐러드',
    desc1: '연어 샐러드, 치킨 샐러드',
    desc2: '쉬림프 샐러드 등',
    icon: Icons.grass,
  ),
  ActItemClass(
    id: 'oneFood',
    title: '원푸드 다이어트',
    desc1: '특정 음식만 먹는',
    desc2: '다이어트',
    icon: Icons.local_dining,
  ),
  ActItemClass(
    id: 'custom',
    title: '사용자 정의',
    desc1: '나만의 식이요법',
    desc2: '직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var exerciseItemTypeClassList = [
  ActItemClass(
    id: 'health',
    title: '헬스',
    desc1: '러닝 머신, 덤벨, 바벨 등',
    desc2: '기구 운동',
    icon: Icons.fitness_center_outlined,
  ),
  ActItemClass(
    id: 'walk',
    title: '걷기',
    desc1: '산책, 속보, 하루 만보 등',
    desc2: '유산소 운동',
    icon: Icons.directions_walk_outlined,
  ),
  ActItemClass(
    id: 'pilates',
    title: '필라테스',
    desc1: '자세 교정에 특화된',
    desc2: '근력 운동',
    icon: Icons.nordic_walking_outlined,
  ),
  ActItemClass(
    id: 'yoga',
    title: '요가',
    desc1: '명상, 호흡, 스트레칭 등',
    desc2: '심신 수련 운동',
    icon: Icons.self_improvement_outlined,
  ),
  ActItemClass(
    id: 'running',
    title: '러닝',
    desc1: '달리기, 조깅, 스프린트 등',
    desc2: '유산소 운동',
    icon: Icons.self_improvement_outlined,
  ),
  ActItemClass(
    id: 'custom',
    title: '사용자 정의',
    desc1: '나만의 운동',
    desc2: '직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var lifeStyleItemTypeClassList = [
  ActItemClass(
    id: 'weightRecord',
    title: '체중 기록',
    desc1: '아침에 잊지 않고',
    desc2: '체중 기록하기',
    icon: Icons.monitor_weight_outlined,
  ),
  ActItemClass(
    id: 'noMidnightSnack',
    title: '야식 금지',
    desc1: '밤 10시 이후로',
    desc2: '음식 안먹기',
    icon: Icons.nights_stay_outlined,
  ),
  ActItemClass(
    id: 'zeroDrink',
    title: '제로 칼로리 음료',
    desc1: '일반음료 대신',
    desc2: '제로음료 마시기',
    icon: Icons.local_drink_outlined,
  ),
  ActItemClass(
    id: 'noFastFood',
    title: '패스트 푸드 금지',
    desc1: '햄버거, 피자, 라면 등',
    desc2: '살찌는 음식 안먹기',
    icon: Icons.no_food_outlined,
  ),
  ActItemClass(
    id: 'water',
    title: '물 1L 마시기',
    desc1: '하루에 물 1L 이상',
    desc2: '마시기',
    icon: Icons.local_drink_outlined,
  ),
  ActItemClass(
    id: 'custom',
    title: '사용자 정의',
    desc1: '나만의 생활습관',
    desc2: '직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

Map<RecordIconTypes, Map<String, dynamic>> weightContentsTitles = {
  RecordIconTypes.none: {
    'icon': Icons.bar_chart,
    'title': '오늘의 체중',
  },
  RecordIconTypes.addWeight: {
    'icon': Icons.add_circle_outline,
    'title': '오늘의 체중',
  },
  RecordIconTypes.editWeight: {
    'icon': Icons.edit,
    'title': '오늘의 체중',
  },
  RecordIconTypes.editGoalWeight: {
    'icon': Icons.flag,
    'title': '목표 체중',
  },
};



// var defaultDietPlanList = [
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.monitor_weight_outlined,
//       plan: '잊지 않고 체중 기록하기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.nights_stay_outlined,
//       plan: '밤 10시 이후에는 음식 먹지 않기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.local_drink_outlined,
//       plan: '하루에 물 1리터 이상 마시기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.no_food_outlined,
//       plan: '후식과 간식을 먹지 않기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.self_improvement_outlined,
//       plan: '16:8 간헐적 단식 실천하기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.light_mode_outlined,
//       plan: '아침식사 거르지 않고 꼭 챙겨먹기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.rice_bowl_outlined,
//       plan: '반공기 다이어트 실천하기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.rice_bowl_outlined,
//       plan: '백미 대신 현미밥 먹기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.food_bank_outlined,
//       plan: '저녁으로 샐러드 먹기',
//       isChecked: false,
//       isAction: false),
//   DietPlanClass(
//       id: const Uuid().v4(),
//       icon: Icons.ramen_dining_outlined,
//       plan: '라면 먹지 않기',
//       isChecked: false,
//       isAction: false),
// ];
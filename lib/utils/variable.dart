import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'enum.dart';

var todayOfWiseSayingList = [
  WiseSayingClass(wiseSaying: '나를 배부르게 하는것들이 나를 파괴한다.', name: '안젤리나 졸리'),
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

var planTypeDetailInfo = {
  PlanTypeEnum.all: PlanTypeDetailClass(
      title: '계획',
      classList: dietPlanClassList,
      initId: 'intermittentFasting',
      subText: '를',
      counterText: '',
      icon: Icons.list_alt_rounded,
      mainColor: actionColor,
      shadeColor: actionColor.shade50,
      desc: ''),
  PlanTypeEnum.diet: PlanTypeDetailClass(
      title: '식이요법',
      classList: dietPlanClassList,
      initId: 'intermittentFasting',
      subText: '를',
      counterText: '(예: 아침에 사과 반쪽 + 달걀 2개)',
      icon: Icons.dining_outlined,
      mainColor: dietColor,
      shadeColor: dietColor.shade50,
      desc: 'Diet'),
  PlanTypeEnum.exercise: PlanTypeDetailClass(
      title: '운동',
      classList: exercisePlanClassList,
      initId: 'health',
      subText: '을',
      counterText: '(예: 등산, 수영, 테니스 등)',
      icon: Icons.fitness_center,
      mainColor: exerciseColor,
      shadeColor: exerciseColor.shade100,
      desc: 'Exercise'),
  PlanTypeEnum.lifestyle: PlanTypeDetailClass(
      title: '생활습관',
      classList: lifeStylePlanClassList,
      initId: 'weightRecord',
      subText: '을',
      counterText: '(예: 밤 8시 이후로 공복 유지)',
      icon: Icons.home,
      mainColor: lifeStyleColor,
      shadeColor: lifeStyleColor.shade100,
      desc: 'LifeStyle'),
};

var planTypeColors = {
  PlanTypeEnum.diet.toString(): dietColor,
  PlanTypeEnum.exercise.toString(): exerciseColor,
  PlanTypeEnum.lifestyle.toString(): lifeStyleColor,
};

var planTypeClassList = [
  PlanTypeClass(
    id: PlanTypeEnum.diet,
    title: '식이요법',
    desc: '간헐적 단식, 밥 반공기만 먹기 등',
    icon: Icons.dining_outlined,
  ),
  PlanTypeClass(
    id: PlanTypeEnum.exercise,
    title: '운동',
    desc: '헬스, 러닝, 산책, 필라테스 등',
    icon: Icons.fitness_center,
  ),
  PlanTypeClass(
    id: PlanTypeEnum.lifestyle,
    title: '생활습관',
    desc: '아침에 체중 기록하기, 야식 금지 등',
    icon: Icons.home,
  ),
];

var dietPlanClassList = [
  PlanItemClass(
    id: 'intermittentFasting',
    name: '간헐적 단식',
    desc: '공복을 유지하는\n식이요법',
    icon: Icons.alarm_outlined,
  ),
  PlanItemClass(
    id: 'halfRice',
    name: '밥 반공기만 먹기',
    desc: '매 끼니마다\n밥은 반만 먹기',
    icon: Icons.rice_bowl_outlined,
  ),
  PlanItemClass(
    id: 'ketogenic',
    name: '저탄고지 다이어트',
    desc: '저탄수화물 고지방\n식이요법',
    icon: Icons.savings_outlined,
  ),
  PlanItemClass(
    id: 'EveningSaled',
    name: '저녁 식사 샐러드',
    desc: '연어 샐러드, 치킨 샐러드\n쉬림프 샐러드 등',
    icon: Icons.grass,
  ),
  PlanItemClass(
    id: 'oneFood',
    name: '원푸드 다이어트',
    desc: '특정 음식만 먹는\n다이어트',
    icon: Icons.local_dining,
  ),
  PlanItemClass(
    id: 'custom',
    name: '사용자 정의',
    desc: '나만의 식이요법\n직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var exercisePlanClassList = [
  PlanItemClass(
    id: 'health',
    name: '헬스',
    desc: '러닝 머신, 덤벨, 바벨 등\n기구 운동',
    icon: Icons.fitness_center_outlined,
  ),
  PlanItemClass(
    id: 'walk',
    name: '걷기',
    desc: '산책, 속보, 하루 만보 등\n유산소 운동',
    icon: Icons.directions_walk_outlined,
  ),
  PlanItemClass(
    id: 'pilates',
    name: '필라테스',
    desc: '자세 교정에 특화된\n근력 운동',
    icon: Icons.nordic_walking_outlined,
  ),
  PlanItemClass(
    id: 'yoga',
    name: '요가',
    desc: '명상, 호흡, 스트레칭 등\n심신 수련 운동',
    icon: Icons.self_improvement_outlined,
  ),
  PlanItemClass(
    id: 'running',
    name: '러닝',
    desc: '달리기, 조깅, 스프린트 등\n유산소 운동',
    icon: Icons.self_improvement_outlined,
  ),
  PlanItemClass(
    id: 'custom',
    name: '사용자 정의',
    desc: '나만의 운동\n직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var lifeStylePlanClassList = [
  PlanItemClass(
    id: 'weightRecord',
    name: '체중 기록',
    desc: '아침에 잊지 않고\n체중 기록하기',
    icon: Icons.monitor_weight_outlined,
  ),
  PlanItemClass(
    id: 'noMidnightSnack',
    name: '야식 금지',
    desc: '밤 10시 이후로\n음식 안먹기',
    icon: Icons.nights_stay_outlined,
  ),
  PlanItemClass(
    id: 'zeroDrink',
    name: '제로 칼로리 음료',
    desc: '일반음료 대신\n제로음료 마시기',
    icon: Icons.local_drink_outlined,
  ),
  PlanItemClass(
    id: 'noFastFood',
    name: '패스트 푸드 금지',
    desc: '햄버거, 피자, 라면 등\n살찌는 음식 안먹기',
    icon: Icons.no_food_outlined,
  ),
  PlanItemClass(
    id: 'water',
    name: '물 1L 마시기',
    desc: '하루에 물 1L 이상\n마시기',
    icon: Icons.local_drink_outlined,
  ),
  PlanItemClass(
    id: 'custom',
    name: '사용자 정의',
    desc: '나만의 생활습관\n직접 추가하기',
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

var dayOfWeek = {
  'Mon': '월',
  'Tue': '화',
  'Wed': '수',
  'Thu': '목',
  'Fri': '금',
  'Sat': '토',
  'Sun': '일'
};

var planType = {
  PlanTypeEnum.diet.toString(): PlanTypeEnum.diet,
  PlanTypeEnum.exercise.toString(): PlanTypeEnum.exercise,
  PlanTypeEnum.lifestyle.toString(): PlanTypeEnum.lifestyle,
};

var planPriorityInfos = [
  planPrioritys[PlanPriorityEnum.high.toString()],
  planPrioritys[PlanPriorityEnum.medium.toString()],
  planPrioritys[PlanPriorityEnum.low.toString()],
];

var planPrioritys = {
  PlanPriorityEnum.high.toString(): PlanPriorityClass(
    id: PlanPriorityEnum.high,
    name: '높음',
    desc: 'High',
    icon: Icons.looks_one_outlined,
    order: 1,
    bgColor: Colors.red.shade50,
    textColor: Colors.red,
  ),
  PlanPriorityEnum.medium.toString(): PlanPriorityClass(
    id: PlanPriorityEnum.medium,
    name: '중간',
    desc: 'Medium',
    icon: Icons.looks_two_outlined,
    order: 2,
    bgColor: Colors.indigo.shade50,
    textColor: Colors.indigo,
  ),
  PlanPriorityEnum.low.toString(): PlanPriorityClass(
    id: PlanPriorityEnum.low,
    name: '낮음',
    desc: 'Low',
    icon: Icons.looks_3,
    order: 3,
    bgColor: Colors.blueGrey.shade50,
    textColor: Colors.blueGrey,
  ),
};

var planOrder = {
  PlanTypeEnum.diet.toString(): 0,
  PlanTypeEnum.exercise.toString(): 1,
  PlanTypeEnum.lifestyle.toString(): 2,
};

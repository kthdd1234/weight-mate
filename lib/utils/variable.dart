import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'enum.dart';

var todayOfWiseSayingList = [
  WiseSayingClass(wiseSaying: '나를 배부르게 하는것들이\n나를 파괴한다.', name: '안젤리나 졸리'),
  WiseSayingClass(wiseSaying: '태어나서 한번도 야식을\n먹어본 적이 없어요.', name: '김연아'),
  WiseSayingClass(wiseSaying: '인생은 살이 쪘을 때와\n안 졌을 때로 나뉜다.', name: '이소라'),
  WiseSayingClass(wiseSaying: '하얀 음식은 절대 안먹어요.\n그건 독이니까요.', name: '미란다 커'),
  WiseSayingClass(wiseSaying: '운동이 끝나고 먹는\n거기까지가 운동이다.', name: '김종국'),
  WiseSayingClass(wiseSaying: '먹어봤자 내가 아는\n그 맛이다.', name: '옥주현'),
  WiseSayingClass(wiseSaying: '세끼 다 먹으면 살쪄요.', name: '김사랑'),
  WiseSayingClass(wiseSaying: '먹고 싶은 걸 다 먹되\n아주 조금만 먹는다.', name: 'AOA 설현'),
  WiseSayingClass(wiseSaying: '죽을 만큼 운동하고\n죽지 않을 만큼 먹었어요.', name: '제시카'),
  WiseSayingClass(wiseSaying: '먹는거요? 귀찮아요.', name: '김민희'),
];

var planTypeDetailInfo = {
  PlanTypeEnum.diet: PlanTypeDetailClass(
      classList: dietPlanClassList,
      initId: 'intermittentFasting',
      subText: '를',
      counterText: '(예: 덴마크 다이어트, 다이어트 도시락 등)',
      icon: Icons.dining_outlined),
  PlanTypeEnum.exercise: PlanTypeDetailClass(
      classList: exercisePlanClassList,
      initId: 'health',
      subText: '을',
      counterText: '(예: 등산, 수영, 테니스 등)',
      icon: Icons.fitness_center),
  PlanTypeEnum.lifestyle: PlanTypeDetailClass(
      classList: lifeStylePlanClassList,
      initId: 'weightRecord',
      subText: '을',
      counterText: '(예: 저녁에 샐러드 먹기, 금주 선언 등)',
      icon: Icons.home),
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
    desc1: '공복을 유지하는',
    desc2: '식이요법',
    icon: Icons.alarm_outlined,
  ),
  PlanItemClass(
    id: 'halfRice',
    name: '밥 반공기만 먹기',
    desc1: '매 끼니마다',
    desc2: '밥은 반만 먹기',
    icon: Icons.rice_bowl_outlined,
  ),
  PlanItemClass(
    id: 'ketogenic',
    name: '저탄고지 다이어트',
    desc1: '저탄수화물 고지방',
    desc2: '식이요법',
    icon: Icons.savings_outlined,
  ),
  PlanItemClass(
    id: 'EveningSaled',
    name: '저녁 식사 샐러드',
    desc1: '연어 샐러드, 치킨 샐러드',
    desc2: '쉬림프 샐러드 등',
    icon: Icons.grass,
  ),
  PlanItemClass(
    id: 'oneFood',
    name: '원푸드 다이어트',
    desc1: '특정 음식만 먹는',
    desc2: '다이어트',
    icon: Icons.local_dining,
  ),
  PlanItemClass(
    id: 'custom',
    name: '사용자 정의',
    desc1: '나만의 식이요법',
    desc2: '직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var exercisePlanClassList = [
  PlanItemClass(
    id: 'health',
    name: '헬스',
    desc1: '러닝 머신, 덤벨, 바벨 등',
    desc2: '기구 운동',
    icon: Icons.fitness_center_outlined,
  ),
  PlanItemClass(
    id: 'walk',
    name: '걷기',
    desc1: '산책, 속보, 하루 만보 등',
    desc2: '유산소 운동',
    icon: Icons.directions_walk_outlined,
  ),
  PlanItemClass(
    id: 'pilates',
    name: '필라테스',
    desc1: '자세 교정에 특화된',
    desc2: '근력 운동',
    icon: Icons.nordic_walking_outlined,
  ),
  PlanItemClass(
    id: 'yoga',
    name: '요가',
    desc1: '명상, 호흡, 스트레칭 등',
    desc2: '심신 수련 운동',
    icon: Icons.self_improvement_outlined,
  ),
  PlanItemClass(
    id: 'running',
    name: '러닝',
    desc1: '달리기, 조깅, 스프린트 등',
    desc2: '유산소 운동',
    icon: Icons.self_improvement_outlined,
  ),
  PlanItemClass(
    id: 'custom',
    name: '사용자 정의',
    desc1: '나만의 운동',
    desc2: '직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var lifeStylePlanClassList = [
  PlanItemClass(
    id: 'weightRecord',
    name: '체중 기록',
    desc1: '아침에 잊지 않고',
    desc2: '체중 기록하기',
    icon: Icons.monitor_weight_outlined,
  ),
  PlanItemClass(
    id: 'noMidnightSnack',
    name: '야식 금지',
    desc1: '밤 10시 이후로',
    desc2: '음식 안먹기',
    icon: Icons.nights_stay_outlined,
  ),
  PlanItemClass(
    id: 'zeroDrink',
    name: '제로 칼로리 음료',
    desc1: '일반음료 대신',
    desc2: '제로음료 마시기',
    icon: Icons.local_drink_outlined,
  ),
  PlanItemClass(
    id: 'noFastFood',
    name: '패스트 푸드 금지',
    desc1: '햄버거, 피자, 라면 등',
    desc2: '살찌는 음식 안먹기',
    icon: Icons.no_food_outlined,
  ),
  PlanItemClass(
    id: 'water',
    name: '물 1L 마시기',
    desc1: '하루에 물 1L 이상',
    desc2: '마시기',
    icon: Icons.local_drink_outlined,
  ),
  PlanItemClass(
    id: 'custom',
    name: '사용자 정의',
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

var dayOfWeek = {
  'Mon': '월',
  'Tue': '화',
  'Wed': '수',
  'Thu': '목',
  'Fri': '금',
  'Sat': '토',
  'Sun': '일'
};

var planTypeColors = {
  PlanTypeEnum.diet.toString(): dietColor,
  PlanTypeEnum.exercise.toString(): exerciseColor,
  PlanTypeEnum.lifestyle.toString(): lifeStyleColor,
};

var planType = {
  PlanTypeEnum.diet.toString(): PlanTypeEnum.diet,
  PlanTypeEnum.exercise.toString(): PlanTypeEnum.exercise,
  PlanTypeEnum.lifestyle.toString(): PlanTypeEnum.lifestyle,
};

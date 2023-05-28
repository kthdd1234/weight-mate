import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:uuid/uuid.dart';

import 'enum.dart';

var defaultDietPlanList = [
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.monitor_weight_outlined,
      plan: '잊지 않고 체중 기록하기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.nights_stay_outlined,
      plan: '밤 10시 이후에는 음식 먹지 않기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.local_drink_outlined,
      plan: '하루에 물 1리터 이상 마시기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.no_food_outlined,
      plan: '후식과 간식을 먹지 않기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.self_improvement_outlined,
      plan: '16:8 간헐적 단식 실천하기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.light_mode_outlined,
      plan: '아침식사 거르지 않고 꼭 챙겨먹기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.rice_bowl_outlined,
      plan: '반공기 다이어트 실천하기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.rice_bowl_outlined,
      plan: '백미 대신 현미밥 먹기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.food_bank_outlined,
      plan: '저녁으로 샐러드 먹기',
      isChecked: false,
      isAction: false),
  DietPlanClass(
      id: const Uuid().v4(),
      icon: Icons.ramen_dining_outlined,
      plan: '라면 먹지 않기',
      isChecked: false,
      isAction: false),
];

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

var actTitles = {
  ActTypeEnum.diet: '다이어트',
  ActTypeEnum.exercise: '운동',
  ActTypeEnum.lifestyle: '생활 습관'
};

var actSubs = {
  ActTypeEnum.diet: '를',
  ActTypeEnum.exercise: '을',
  ActTypeEnum.lifestyle: '을'
};

var mainItemTypeClassList = [
  ItemTypeClass(
    id: ActTypeEnum.diet,
    title: '다이어트',
    desc: '간헐적 단식, 저탄고지 다이어트 등',
    icon: Icons.monitor_weight,
  ),
  ItemTypeClass(
    id: ActTypeEnum.exercise,
    title: '운동',
    desc: '헬스, 러닝, 산책, 필라테스 등',
    icon: Icons.directions_run_outlined,
  ),
  ItemTypeClass(
    id: ActTypeEnum.lifestyle,
    title: '생활습관',
    desc: '아침에 체중 기록하기, 야식 금지 등',
    icon: Icons.accessibility_new_sharp,
  )
];

var subItemTypeClassList = {
  ActTypeEnum.diet: dietItemTypeClassList,
  ActTypeEnum.exercise: exerciseItemTypeClassList,
  ActTypeEnum.lifestyle: lifeStyleItemTypeClassList,
};

var initItemType = {
  ActTypeEnum.diet: 'intermittentFasting',
  ActTypeEnum.exercise: 'health',
  ActTypeEnum.lifestyle: 'weightRecord',
};

var dietItemTypeClassList = [
  ItemTypeClass(
    id: 'intermittentFasting',
    title: '간헐적 단식',
    desc: '특정 시간 동안 공복을 유지하는 식이요법',
    icon: Icons.alarm_outlined,
  ),
  ItemTypeClass(
    id: 'ketogenic',
    title: '키토제닉 다이어트',
    desc: '저탄수화물 고지방 식이요법',
    icon: Icons.savings_outlined,
  ),
  ItemTypeClass(
    id: 'oneFood',
    title: '원푸드 다이어트',
    desc: '특정한 음식을 집중적으로 먹는 식이요법',
    icon: Icons.food_bank_outlined,
  ),
  ItemTypeClass(
    id: 'denmark',
    title: '덴마크 다이어트',
    desc: '고단백 저열량 식이요법',
    icon: Icons.egg_alt_outlined,
  ),
  ItemTypeClass(
    id: 'custom',
    title: '사용자 정의',
    desc: '다이어트 종류 직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var exerciseItemTypeClassList = [
  ItemTypeClass(
    id: 'health',
    title: '헬스',
    desc: '러닝 머신, 덤벨, 벤치 프레스 등 기구 운동',
    icon: Icons.fitness_center_outlined,
  ),
  ItemTypeClass(
    id: 'walk',
    title: '걷기',
    desc: '산책, 속보, 하루 만보 등 유산소 운동',
    icon: Icons.directions_walk_outlined,
  ),
  ItemTypeClass(
    id: 'pilates',
    title: '필라테스',
    desc: '재활과 자세 교정에 특화된 운동',
    icon: Icons.nordic_walking_outlined,
  ),
  ItemTypeClass(
    id: 'yoga',
    title: '요가',
    desc: '명상과 호흡, 스트레칭 등이 결합된 심신 수련 운동',
    icon: Icons.self_improvement_outlined,
  ),
  ItemTypeClass(
    id: 'custom',
    title: '사용자 정의',
    desc: '운동 종류 직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

var lifeStyleItemTypeClassList = [
  ItemTypeClass(
    id: 'weightRecord',
    title: '체중 기록',
    desc: '아침에 잊지 않고 체중 기록하기',
    icon: Icons.av_timer_outlined,
  ),
  ItemTypeClass(
    id: 'noMidnightSnack',
    title: '야식 금지',
    desc: '밤에 야식 먹지 않기',
    icon: Icons.nights_stay_outlined,
  ),
  ItemTypeClass(
    id: 'zeroDrink',
    title: '제로 칼로리 음료',
    desc: '일반음료 대신 제로 칼로리 음료 마시기',
    icon: Icons.local_drink_outlined,
  ),
  ItemTypeClass(
    id: 'noFastFood',
    title: '패스트 푸드 금지',
    desc: '햄버거, 피자, 라면 등 살찌는 음식 안먹기',
    icon: Icons.no_food_outlined,
  ),
  ItemTypeClass(
    id: 'custom',
    title: '사용자 정의',
    desc: '생활습관 직접 추가하기',
    icon: Icons.add_circle_outline,
  ),
];

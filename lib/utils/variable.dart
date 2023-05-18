import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:uuid/uuid.dart';

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

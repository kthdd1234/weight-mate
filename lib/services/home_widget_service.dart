import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  String appGroupId = 'group.weight-mate-widget';

  Future<bool?> updateWidget({
    required Map<String, String> data,
    required String iosWidgetName,
  }) async {
    data.forEach((key, value) async {
      await HomeWidget.saveWidgetData<String>(key, value);
    });

    return await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName: 'WeightTableWidget',
    );
  }

  Future<bool?> updateWeight() {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    String headerTitle = "오늘의 체중".tr();
    String today = mde(locale: user.language!, dateTime: now);
    String weightTitle = "체중".tr();
    String weight = '${record?.weight ?? ""}${user.weightUnit}';
    String bmiTitle = "BMI";
    String bMI = bmi(
      tall: user.tall,
      tallUnit: user.tallUnit,
      weight: record?.weight,
      weightUnit: user.weightUnit,
    );
    String goalWeightTitle = "목표 체중".tr();
    String goalWeight = '${user.goalWeight}${user.weightUnit}';
    String emptyWeightTitle = "체중 기록하기".tr();
    String fontFamily = '${user.fontFamily}';

    Map<String, String> weightObj = {
      "headerTitle": headerTitle,
      "today": today,
      "weightTitle": weightTitle,
      "weight": weight,
      "bmiTitle": bmiTitle,
      "bmi": bMI,
      "goalWeightTitle": goalWeightTitle,
      "goalWeight": goalWeight,
      "emptyWeightTitle": emptyWeightTitle,
      "fontFamily": fontFamily,
      "isEmpty": record?.weight == null ? "empty" : "show",
    };

    return updateWidget(data: weightObj, iosWidgetName: 'weightWidget');
  }

  Future<bool?> updateDietRecord() {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<String>? dietRecordOrderList = record?.dietRecordOrderList;
    List<String>? exerciseRecordOrderList = record?.exerciseRecordOrderList;
    List<Map<String, dynamic>>? orderList = onOrderList(
          actions: record?.actions,
          type: eDiet,
          dietRecordOrderList: dietRecordOrderList,
          exerciseRecordOrderList: exerciseRecordOrderList,
        ) ??
        [];
    List<WidgetItemClass> widgetItemList = orderList
        .map((action) => WidgetItemClass(
              action['id'],
              action['type'],
              action['title'],
              action['name'],
            ))
        .toList();

    String drHeaderTitle = "오늘의 식단 기록".tr();
    String today = mde(locale: user.language!, dateTime: now);
    String fontFamily = '${user.fontFamily}';
    String emptyTitle = "식단 기록하기".tr();
    String renderCellList = jsonEncode(widgetItemList);

    Map<String, String> dietRecordObj = {
      "drHeaderTitle": drHeaderTitle,
      "drToday": today,
      "drFontFamily": fontFamily,
      "drEmptyTitle": emptyTitle,
      "drIsEmpty": orderList.isEmpty ? "empty" : "show",
      "drRenderCellList": renderCellList,
    };

    return updateWidget(data: dietRecordObj, iosWidgetName: "dietRecordWidget");
  }

  Future<bool?> updateExerciseRecord() {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<String>? dietRecordOrderList = record?.dietRecordOrderList;
    List<String>? exerciseRecordOrderList = record?.exerciseRecordOrderList;
    List<Map<String, dynamic>>? orderList = onOrderList(
          actions: record?.actions,
          type: eExercise,
          dietRecordOrderList: dietRecordOrderList,
          exerciseRecordOrderList: exerciseRecordOrderList,
        ) ??
        [];
    List<WidgetItemClass> widgetItemList = orderList
        .map((action) => WidgetItemClass(
              action['id'],
              action['type'],
              action['title'],
              action['name'],
            ))
        .toList();

    String erHeaderTitle = "오늘의 운동 기록".tr();
    String erToday = mde(locale: user.language!, dateTime: now);
    String erFontFamily = '${user.fontFamily}';
    String erEmptyTitle = "운동 기록하기".tr();
    String erRenderCellList = jsonEncode(widgetItemList);

    Map<String, String> exerciseRecordObj = {
      "erHeaderTitle": erHeaderTitle,
      "erToday": erToday,
      "erFontFamily": erFontFamily,
      "erEmptyTitle": erEmptyTitle,
      "erIsEmpty": orderList.isEmpty ? "empty" : "show",
      "erRenderCellList": erRenderCellList,
    };

    return updateWidget(
      data: exerciseRecordObj,
      iosWidgetName: "exerciseRecordWidget",
    );
  }

  Future<bool?> updateDietGoal() async {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    List<PlanBox> list = planRepository.planBox.values
        .where((plan) => plan.type == eDiet)
        .toList();
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = record?.actions;
    List<String>? dietOrderList = user.dietOrderList;

    String dgHeaderTitle = "오늘의 식단 목표".tr();
    String dgToday = mde(locale: user.language!, dateTime: now);
    String dgFontFamily = '${user.fontFamily}';
    String dgEmptyTitle = "목표 추가하기".tr();
    List<PlanBox> planList = onPlanList(
      planList: list,
      orderList: dietOrderList,
      actions: record?.actions,
    );
    List<WidgetPlanClass> widgetPlanList = planList
        .map((plan) => WidgetPlanClass(plan.id, plan.type, plan.name,
            onAction(actions: actions, planId: plan.id)['id'] != null))
        .toList();
    String dgRenderCellList = jsonEncode(widgetPlanList);

    Map<String, String> dietGoalObj = {
      "dgHeaderTitle": dgHeaderTitle,
      "dgToday": dgToday,
      "dgFontFamily": dgFontFamily,
      "dgEmptyTitle": dgEmptyTitle,
      "dgIsEmpty": planList.isEmpty ? "empty" : "show",
      "dgRenderCellList": dgRenderCellList,
    };

    return updateWidget(data: dietGoalObj, iosWidgetName: "dietGoalWidget");
  }

  Future<bool?> updateExerciseGoal() async {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    List<PlanBox> list = planRepository.planBox.values
        .where((plan) => plan.type == eExercise)
        .toList();
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = record?.actions;
    List<String>? exerciseOrderList = user.exerciseOrderList;

    String egHeaderTitle = "오늘의 운동 목표".tr();
    String egToday = mde(locale: user.language!, dateTime: now);
    String egFontFamily = '${user.fontFamily}';
    String egEmptyTitle = "목표 추가하기".tr();
    List<PlanBox> planList = onPlanList(
      planList: list,
      orderList: exerciseOrderList,
      actions: record?.actions,
    );
    List<WidgetPlanClass> widgetPlanList = planList
        .map((plan) => WidgetPlanClass(plan.id, plan.type, plan.name,
            onAction(actions: actions, planId: plan.id)['id'] != null))
        .toList();
    String egRenderCellList = jsonEncode(widgetPlanList);

    Map<String, String> exerciseGoalObj = {
      "egHeaderTitle": egHeaderTitle,
      "egToday": egToday,
      "egFontFamily": egFontFamily,
      "egEmptyTitle": egEmptyTitle,
      "egIsEmpty": planList.isEmpty ? "empty" : "show",
      "egRenderCellList": egRenderCellList,
    };

    return updateWidget(
      data: exerciseGoalObj,
      iosWidgetName: "exerciseGoalWidget",
    );
  }

  Future<bool?> updateLifeGoal() async {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    List<PlanBox> list = planRepository.planBox.values
        .where((plan) => plan.type == eLife)
        .toList();
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = record?.actions;
    List<String>? lifeOrderList = user.lifeOrderList;

    String lgHeaderTitle = "오늘의 습관".tr();
    String lgToday = mde(locale: user.language!, dateTime: now);
    String lgFontFamily = '${user.fontFamily}';
    String lgEmptyTitle = "습관 추가하기".tr();
    List<PlanBox> planList = onPlanList(
      planList: list,
      orderList: lifeOrderList,
      actions: record?.actions,
    );
    List<WidgetPlanClass> widgetPlanList = planList
        .map((plan) => WidgetPlanClass(plan.id, plan.type, plan.name,
            onAction(actions: actions, planId: plan.id)['id'] != null))
        .toList();
    String lgRenderCellList = jsonEncode(widgetPlanList);

    Map<String, String> lifeGoalObj = {
      "lgHeaderTitle": lgHeaderTitle,
      "lgToday": lgToday,
      "lgFontFamily": lgFontFamily,
      "lgEmptyTitle": lgEmptyTitle,
      "lgIsEmpty": planList.isEmpty ? "empty" : "show",
      "lgRenderCellList": lgRenderCellList,
    };

    return updateWidget(data: lifeGoalObj, iosWidgetName: "lifeGoalWidget");
  }

  updateAndroidWidget(String locale) {
    List<WidgetTableItemClass> widgetTableItemList = [];

    for (var day = 0; day <= 30; day++) {
      DateTime dateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: DateTime.now(),
        days: day,
      );
      int recordKey = getDateTimeToInt(dateTime);
      RecordBox? record = recordRepository.recordBox.get(recordKey);
      double? weight = record?.weight;
      double? beforeWeight = getBeforeWeight(dateTime);
      double? startWeight = getStartWeight();

      String date = mdeShortFormatter(locale: locale, dateTime: dateTime);
      String current = '${weight ?? '-'}';
      String before = weight != null && beforeWeight != null
          ? calculatedWeight(fWeight: weight, lWeight: beforeWeight)
          : '-';
      String start = weight != null && startWeight != null
          ? calculatedWeight(fWeight: weight, lWeight: startWeight)
          : '-';
      String beforeColorName = weight != null && beforeWeight != null
          ? getWeightColorName(fWeight: weight, lWeight: beforeWeight)
          : '검정색';
      String startColorName = weight != null && startWeight != null
          ? getWeightColorName(fWeight: weight, lWeight: startWeight)
          : '검정색';

      WidgetTableItemClass widgetTableItem = WidgetTableItemClass(
        id: '$day',
        date: date,
        current: current,
        before: before,
        start: start,
        beforeColorName: beforeColorName,
        startColorName: startColorName,
      );

      widgetTableItemList.add(widgetTableItem);
    }

    Map<String, String> entry = {
      "emptyText": "기록된 몸무게가 없어요".tr(),
      "dateTitleName": "날짜".tr(),
      "currentTitleName": "체중".tr(),
      "beforeTitleName": "이전과 비교".tr(),
      "startTitleName": "처음과 비교".tr(),
      "tableItemList": jsonEncode(widgetTableItemList),
    };

    updateWidget(data: entry, iosWidgetName: '');
  }
}

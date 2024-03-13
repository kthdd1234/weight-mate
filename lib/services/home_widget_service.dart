import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  String appGroupId = 'group.weight-mate-widget';

  Future<bool?> updateWidget({
    required Map<String, String> data,
    required String widgetName,
  }) async {
    data.forEach((key, value) async {
      await HomeWidget.saveWidgetData<String>(key, value);
    });

    log('data => $data');

    return await HomeWidget.updateWidget(iOSName: widgetName);
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

    return updateWidget(data: weightObj, widgetName: 'weightWidget');
  }

  Future<bool?> updateDietRecord() {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<Map<String, dynamic>>? orderList =
        onOrderList(actions: record?.actions, type: eDiet) ?? [];
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

    return updateWidget(data: dietRecordObj, widgetName: "dietRecordWidget");
  }

  Future<bool?> updateExerciseRecord() {
    DateTime now = DateTime.now();
    UserBox user = userRepository.user;
    int recordKey = getDateTimeToInt(now);
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    List<Map<String, dynamic>>? orderList =
        onOrderList(actions: record?.actions, type: eExercise) ?? [];
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
      widgetName: "exerciseRecordWidget",
    );
  }
}

 // onPlanList
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class RecordInfoListClass {
  RecordInfoListClass({
    required this.recordInfoList,
  });

  List<RecordInfoClass> recordInfoList;
}

class RecordInfoClass {
  RecordInfoClass({
    this.recordDateTime,
    this.weight,
    this.dietPlanList,
    this.memo,
    required this.wiseSaying,
  });

  DateTime? recordDateTime;

  double? weight;
  double? bodyFat;
  List<Map<String, dynamic>>? dietPlanList;
  String? memo;
  Map<String, String> wiseSaying;
}

class UserInfoClass {
  UserInfoClass({
    required this.tall,
    required this.goalWeight,
    required this.startDietDateTime,
    required this.endDietDateTime,
    required this.recordStartDateTime,
  });

  double tall;
  double goalWeight;
  DateTime startDietDateTime;
  DateTime? endDietDateTime;
  DateTime recordStartDateTime;
}

class DietPlanClass {
  DietPlanClass({
    required this.id,
    required this.icon,
    required this.plan,
    required this.isChecked,
    required this.isAction,
  });

  String id;
  IconData icon;
  String plan;
  bool isChecked;
  bool isAction;

  @override
  String toString() {
    return '{ $id, $plan, $isChecked $isAction }';
  }

  Map<String, dynamic> getMapData() {
    return {
      'id': id,
      'iconCodePoint': icon.codePoint,
      'plan': plan,
      'isChecked': isChecked,
      'isAction': isAction
    };
  }
}

class TextInputClass {
  TextInputClass({
    required this.maxLength,
    required this.prefixIcon,
    required this.suffixText,
    required this.hintText,
    required this.inputTextErr,
  });

  int maxLength;
  IconData prefixIcon;
  String suffixText;
  String hintText;
  InputTextErrorClass inputTextErr;

  getErrorText({
    required String text,
    required double min,
    required double max,
    required String errMsg,
  }) {
    return handleCheckErrorText(text: text, min: min, max: max, errMsg: errMsg);
  }
}

class InputTextErrorClass {
  InputTextErrorClass({
    required this.min,
    required this.max,
    required this.errMsg,
  });

  double min;
  double max;
  String errMsg;
}

class WiseSayingClass {
  WiseSayingClass({
    required this.wiseSaying,
    required this.name,
  });

  String wiseSaying;
  String name;
}

class ProgressStatusItemClass {
  ProgressStatusItemClass({
    required this.id,
    required this.icon,
    required this.title,
    required this.sub,
  });

  int id;
  IconData icon;
  String title;
  String sub;
}

class RecordSubTypeClass {
  RecordSubTypeClass({
    required this.enumId,
    required this.icon,
  });

  RecordSubTypes enumId;
  IconData icon;
}

class MoreSeeItemClass {
  MoreSeeItemClass({
    required this.index,
    required this.id,
    required this.icon,
    required this.title,
    required this.value,
    required this.widgetType,
    this.onTapArrow,
    this.onTapSwitch,
    this.bottomWidget,
    this.dateTimeStr,
  });

  int index;
  MoreSeeItem id;
  IconData icon;
  String title;
  dynamic value;
  MoreSeeWidgetTypes widgetType;
  Function(MoreSeeItem id)? onTapArrow;
  Function(MoreSeeItem id, bool value)? onTapSwitch;
  String? bottomWidget;
  String? dateTimeStr;
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class UserInfoClass {
  UserInfoClass({
    required this.userId,
    required this.tall,
    required this.goalWeight,
    required this.recordStartDateTime,
    required this.isAlarm,
    this.alarmTime,
    this.alarmId,
  });

  String userId;
  double tall;
  double goalWeight;
  DateTime recordStartDateTime;
  bool isAlarm;
  DateTime? alarmTime;
  int? alarmId;
}

class RecordInfoClass {
  RecordInfoClass({
    required this.recordDateTime,
    this.weight,
    this.actions,
    this.memo,
  });

  DateTime recordDateTime;
  double? weight;
  List<String>? actions;
  String? memo;
}

class PlanInfoClass {
  PlanInfoClass({
    required this.type,
    required this.title,
    required this.id,
    required this.name,
    required this.priority,
    required this.isAlarm,
    this.alarmTime,
    this.alarmId,
    required this.createDateTime,
    required this.planItemList,
  });

  PlanTypeEnum type;
  String title;
  String id;
  String name;
  PlanPriorityEnum priority;
  bool isAlarm;
  DateTime? alarmTime;
  int? alarmId;
  DateTime createDateTime;
  List<String> planItemList;
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

class RecordIconClass {
  RecordIconClass({
    required this.enumId,
    required this.icon,
  });

  RecordIconTypes enumId;
  IconData icon;
}

class MoreSeeItemClass {
  MoreSeeItemClass({
    required this.id,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    required this.color,
  });

  MoreSeeItem id;
  String title, value, icon;
  Color color;
  Function(MoreSeeItem id) onTap;
}

class PlanTypeClass {
  PlanTypeClass({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
  });

  dynamic id;
  String title;
  String desc;
  IconData icon;
}

// class PlanItemClass {
//   PlanItemClass({
//     required this.id,
//     required this.name,
//     required this.desc,
//     required this.icon,
//   });

//   dynamic id;
//   String name;
//   String desc;
//   IconData icon;
// }

class WeightInfoClass {
  WeightInfoClass({
    required this.id,
    required this.title,
    required this.value,
    required this.icon,
    required this.more,
    required this.tooltipMsg,
    required this.iconColor,
    required this.onTap,
  });

  String id, title, value;
  IconData icon, more;
  String tooltipMsg;
  Color iconColor;
  Function() onTap;
}

// class GridIconClass {
//   GridIconClass({
//     required this.id,
//     required this.icon,
//     required this.isEnabled,
//   });

//   String id;
//   IconData icon;
//   bool isEnabled;
// }

class PlanTypeDetailClass {
  PlanTypeDetailClass({
    required this.title,
    required this.classList,
    required this.initId,
    required this.subText,
    required this.counterText,
    required this.icon,
    required this.mainColor,
    required this.shadeColor,
    required this.desc,
  });

  List<PlanItemClass> classList;
  String title, desc, initId, subText, counterText;
  IconData icon;
  Color mainColor, shadeColor;
}

class ActionItemClass {
  ActionItemClass({
    required this.id,
    required this.title,
    required this.type,
    required this.name,
    required this.priority,
    required this.actionDateTime,
    required this.createDateTime,
    this.isRecord,
  });

  String id, title, type, name, priority;
  DateTime actionDateTime, createDateTime;
  bool? isRecord;

  setObject() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'name': name,
      'priority': priority,
      'actionDateTime': actionDateTime,
      'createDateTime': createDateTime,
      'isRecord': isRecord,
    };
  }
}

// class ArgmentsTypeClass {
//   ArgmentsTypeClass({
//     required this.createDateTime,
//     required this.planId,
//     required this.buttonText,
//     required this.contentsTitleWidget,
//     this.pageTitle,
//   });

//   DateTime createDateTime;
//   String planId, buttonText;
//   String? pageTitle;
//   Widget contentsTitleWidget;
// }

// class PlanPriorityClass {
//   PlanPriorityClass({
//     required this.id,
//     required this.name,
//     required this.desc,
//     required this.icon,
//     required this.order,
//     required this.bgColor,
//     required this.textColor,
//   });

//   PlanPriorityEnum id;
//   String name, desc;
//   IconData icon;
//   int order;
//   Color bgColor, textColor;
// }

class SvgClass {
  SvgClass({required this.emotion, required this.name});
  String emotion, name;
}

class FilterClass {
  FilterClass({required this.id, required this.name});
  String id, name;
}

class PlanItemClass {
  PlanItemClass({
    required this.type,
    required this.name,
  });

  String type, name;
}

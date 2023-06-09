import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class UserInfoClass {
  UserInfoClass({
    required this.userId,
    required this.tall,
    required this.goalWeight,
    required this.recordStartDateTime,
    required this.isWeightAlarm,
    this.weightAlarmTime,
  });

  String userId;
  double tall;
  double goalWeight;
  DateTime recordStartDateTime;
  bool isWeightAlarm;
  DateTime? weightAlarmTime;
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
    required this.startDateTime,
    this.endDateTime,
    required this.isAlarm,
    this.alarmTime,
  });

  PlanTypeEnum type;
  String title;
  String id;
  String name;
  DateTime startDateTime;
  DateTime? endDateTime;
  bool isAlarm;
  DateTime? alarmTime;
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

class PlanItemClass {
  PlanItemClass({
    required this.id,
    required this.name,
    required this.desc1,
    required this.desc2,
    required this.icon,
  });

  dynamic id;
  String name;
  String desc1, desc2;
  IconData icon;
}

class WeightInfoClass {
  WeightInfoClass({
    required this.id,
    required this.title,
    required this.value,
    required this.icon,
    required this.more,
    required this.tooltipMsg,
  });

  String id, title, value;
  IconData icon, more;
  String tooltipMsg;
}

class GridIconClass {
  GridIconClass({
    required this.id,
    required this.icon,
    required this.isEnabled,
  });

  String id;
  IconData icon;
  bool isEnabled;
}

// class RemovePlanClass {
//   RemovePlanClass({
//     required this.id,
//     required this.name,
//     required this.title,
//     required this.isRemove,
//   });

//   String id, name, title;
//   bool isRemove;
// }

class PlanTypeDetailClass {
  PlanTypeDetailClass({
    required this.classList,
    required this.initId,
    required this.subText,
    required this.counterText,
    required this.icon,
  });

  List<PlanItemClass> classList;
  String initId, subText, counterText;
  IconData icon;
}

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UserInfoClass {
  UserInfoClass({
    required this.tall,
    required this.goalWeight,
    required this.weight,
    required this.tallUnit,
    required this.weightUnit,
  });

  double tall;
  double weight;
  double goalWeight;
  String tallUnit, weightUnit;
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
    this.dietExerciseRecordDateTime,
  });

  String id, title, type, name, priority;
  DateTime actionDateTime, createDateTime;
  bool? isRecord;
  DateTime? dietExerciseRecordDateTime;

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
      'dietExerciseRecordDateTime': dietExerciseRecordDateTime
    };
  }
}

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

class historyImageClass {
  historyImageClass({required this.pos, this.unit8List});

  String pos;
  Uint8List? unit8List;
}

class LanguageItemClass {
  LanguageItemClass({required this.name, required this.languageCode});

  String name, languageCode;
}

class WeightButtonClass {
  WeightButtonClass({
    this.text,
    this.imgNumber,
    this.nameArgs,
    this.onTap,
  });

  String? text, imgNumber;
  Map<String, String>? nameArgs;
  Function()? onTap;
}

class AppLifecycleReactor {
  AppLifecycleReactor({required this.context});

  BuildContext context;

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) async {
    String? passwords = userRepository.user.screenLockPasswords;

    if (passwords != null) {
      if (appState == AppState.foreground) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EnterScreenLockPage(),
            fullscreenDialog: true,
          ),
        );
      }
    }
  }
}

class TodoDataClass {
  TodoDataClass({
    required this.filterId,
    required this.color,
    required this.title,
    required this.icon,
  });

  String filterId;
  String color, title;
  IconData icon;
}

class DayColorClass {
  DayColorClass({required this.type, required this.color});

  String type;
  Color color;
}

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:googleapis/drive/v3.dart' as drive;

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
      'dietExerciseRecordDateTime': dietExerciseRecordDateTime,
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

// class AppLifecycleLockScreenReactor {
//   AppLifecycleLockScreenReactor({required this.context});

//   BuildContext context;

//   void listenToAppStateChanges() {
//     AppStateEventNotifier.startListening();
//     AppStateEventNotifier.appStateStream
//         .forEach((state) => _onAppStateChanged(state));
//   }

//   void _onAppStateChanged(AppState appState) async {
//     String? passwords = userRepository.user.screenLockPasswords;

//     try {
//       if (passwords != null) {
//         if (appState == AppState.foreground) {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => EnterScreenLockPage(),
//               fullscreenDialog: true,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       log('e => $e');
//     }
//   }
// }

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

class WidgetItemClass {
  final String id;
  final String type;
  final String title;
  final String name;

  WidgetItemClass(this.id, this.type, this.title, this.name);

  WidgetItemClass.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        type = json['type'] as String,
        title = json['title'] as String,
        name = json['name'] as String;

  Map<String, dynamic> toJson() =>
      {'id': id, 'type': type, 'title': title, 'name': name};
}

class WidgetPlanClass {
  final String id;
  final String type;
  final String name;
  final bool isChecked;

  WidgetPlanClass(this.id, this.type, this.name, this.isChecked);

  WidgetPlanClass.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        type = json['type'] as String,
        name = json['name'] as String,
        isChecked = json['isChecked'] as bool;

  Map<String, dynamic> toJson() =>
      {'id': id, 'type': type, 'name': name, 'isChecked': isChecked};
}

class DriveFileClass {
  DriveFileClass({this.driveFile, this.errorCode});

  drive.File? driveFile;
  int? errorCode;
}

class HiveBoxPathsClass {
  HiveBoxPathsClass({
    required this.userBoxPath,
    required this.recordBoxPath,
    required this.planBoxPath,
  });

  String userBoxPath, recordBoxPath, planBoxPath;
}

class DriveFileIdsClass {
  DriveFileIdsClass({
    required this.userFileId,
    required this.recordFileId,
    required this.planFileId,
  });

  String? userFileId, recordFileId, planFileId;
}

class PremiumBenefitsClass {
  PremiumBenefitsClass({
    required this.svgName,
    required this.title,
    required this.subTitle,
  });

  String svgName, title, subTitle;
}

class GraphData {
  GraphData(this.x, this.y);

  final String x;
  final double? y;
}

class StackGraphData {
  StackGraphData(this.x, this.y);

  final String x;
  final double? y;
}

class DataSourceClass {
  DataSourceClass({
    required this.title,
    required this.max,
    required this.avg,
    required this.min,
  });

  String title;
  List<StackGraphData> max, avg, min;
}

class ColorClass {
  ColorClass({
    required this.s50,
    required this.s100,
    required this.s200,
    required this.s300,
    required this.s400,
    required this.original,
    required this.colorName,
  });

  String colorName;
  Color s50, s100, s200, s300, s400, original;
}

class HashTagClass {
  HashTagClass({required this.id, required this.text, required this.colorName});

  String id, text, colorName;
}

class AppBarInfoClass {
  AppBarInfoClass({
    required this.title,
    this.isCenter,
    this.actions,
  });

  String title;
  bool? isCenter;
  List<Widget>? actions;
}

class BNClass {
  BNClass({required this.index, required this.name, required this.icon});

  int index;
  String name;
  IconData icon;
}

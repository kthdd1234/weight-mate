import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_action_info.dart';
import 'package:flutter_app_weight_management/widgets/calendar_diary_info.dart';
import 'package:flutter_app_weight_management/widgets/calendar_weight_info.dart';
import 'package:hive/hive.dart';

class RecordInfoArgumentsClass {
  RecordInfoArgumentsClass({
    required this.recordInfo,
    required this.currentDay,
    required this.planBox,
  });

  RecordBox? recordInfo;
  Box<PlanBox> planBox;
  DateTime currentDay;
}

class RecordInfoPage extends StatelessWidget {
  const RecordInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RecordInfoArgumentsClass;
    final recordInfo = args.recordInfo;
    final planBox = args.planBox;
    final currentDay = args.currentDay;

    setCalendarContentsBox() {
      if (recordInfo == null) {
        return EmptyTextVerticalArea(
          backgroundColor: Colors.white,
          icon: Icons.info_outline,
          title: '기록된 데이터가 없어요.',
        );
      }

      final weight = recordInfo.weight;
      final actions = recordInfo.actions;
      final whiteText = recordInfo.whiteText;
      final leftEyeBodyFilePath = recordInfo.leftEyeBodyFilePath;
      final rightEyeBodyFilePath = recordInfo.rightEyeBodyFilePath;
      final diary = whiteText ?? leftEyeBodyFilePath ?? rightEyeBodyFilePath;

      return Column(
        children: [
          weight != null
              ? CalendarWeightInfo(
                  weight: weight.toString(),
                  weightDateTime:
                      timeToStringDetail(recordInfo.weightDateTime).toString(),
                )
              : const EmptyArea(),
          actions != null
              ? CalendarActionInfo(planBox: planBox, actions: actions)
              : const EmptyArea(),
          diary != null
              ? CalendarDiaryInfo(
                  whiteText: whiteText,
                  leftEyeBodyFilePath: leftEyeBodyFilePath,
                  rightEyeBodyFilePath: rightEyeBodyFilePath,
                  diaryDateTime: recordInfo!.diaryDateTime,
                )
              : const EmptyArea(),
        ],
      );
    }

    return AddContainer(
      title: '기록 정보',
      body: Column(children: [
        ContentsTitleText(text: '${dateTimeToMMDDEE(currentDay)}'),
        SpaceHeight(height: regularSapce),
        setCalendarContentsBox(),
      ]),
      buttonEnabled: false,
      bottomSubmitButtonText: '',
    );
  }
}

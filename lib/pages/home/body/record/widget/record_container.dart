import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/unit/tag.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_profile.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_todo.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

enum eRecordContainer { edit, history }

class RecordContainer extends StatefulWidget {
  RecordContainer({
    super.key,
    required this.recordType,
  });

  eRecordContainer recordType;

  @override
  State<RecordContainer> createState() => _RecordContainerState();
}

class _RecordContainerState extends State<RecordContainer> {
  String? emotion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecordProfile(),
        RecordPicture(),
        SpaceHeight(height: regularSapce),
        RecordTodo(),
        RecordDiary(),
        SpaceHeight(height: regularSapce),
      ],
    );
  }
}

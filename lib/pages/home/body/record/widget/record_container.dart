import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_profile.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_todo.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

enum eRecordContainer { edit, history }

class RecordContainer extends StatefulWidget {
  RecordContainer({super.key, required this.recordType});

  eRecordContainer recordType;

  @override
  State<RecordContainer> createState() => _RecordContainerState();
}

class _RecordContainerState extends State<RecordContainer> {
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

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_profile.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_todo.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class EditContainer extends StatelessWidget {
  EditContainer({
    super.key,
    required this.importDateTime,
    required this.setActiveCamera,
    required this.recordType,
  });

  DateTime importDateTime;
  Function(bool isActive) setActiveCamera;
  RECORD recordType;

  @override
  Widget build(BuildContext context) {
    bool isEdit = recordType == RECORD.edit;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: regularSapce,
        vertical: smallSpace,
      ),
      child: Column(
        children: [
          EditProfile(importDateTime: importDateTime, recordType: recordType),
          EditPicture(setActiveCamera: setActiveCamera, recordType: recordType),
          EditTodo(importDateTime: importDateTime, recordType: recordType),
          EditDiary(importDateTime: importDateTime, recordType: recordType),
        ],
      ),
    );
  }
}

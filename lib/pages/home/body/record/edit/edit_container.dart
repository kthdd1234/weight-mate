import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_profile.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_todo.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

enum eEditContainer { edit, history }

class EditContainer extends StatelessWidget {
  EditContainer({
    super.key,
    required this.recordType,
    required this.setActiveCamera,
  });

  eEditContainer recordType;
  Function(bool isActive) setActiveCamera;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: regularSapce, vertical: smallSpace),
      child: Column(
        children: [
          EditProfile(),
          EditPicture(setActiveCamera: setActiveCamera),
          EditDiary(),
          EditTodo(),
        ],
      ),
    );
  }
}

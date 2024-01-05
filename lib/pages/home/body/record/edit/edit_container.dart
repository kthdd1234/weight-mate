import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_weight.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_todo.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class EditContainer extends StatelessWidget {
  EditContainer({super.key, required this.setActiveCamera});

  Function(bool isActive) setActiveCamera;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: regularSapce,
        vertical: smallSpace,
      ),
      child: Column(
        children: [
          EditWeight(),
          EditPicture(setActiveCamera: setActiveCamera),
          EditTodo(),
          EditDiary(),
        ],
      ),
    );
  }
}

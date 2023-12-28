import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_profile.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/record_todo.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:provider/provider.dart';

enum eRecordContainer { edit, history }

class RecordContainer extends StatelessWidget {
  RecordContainer({
    super.key,
    required this.recordType,
    required this.setActiveCamera,
  });

  eRecordContainer recordType;
  Function(bool isActive) setActiveCamera;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    return Column(
      children: [
        RecordProfile(),
        RecordPicture(
          setActiveCamera: setActiveCamera,
          importDateTime: importDateTime,
        ),
        RecordTodo(),
        RecordDiary(),
      ],
    );
  }
}

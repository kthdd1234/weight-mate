import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/dash_container.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class EditDiary extends StatefulWidget {
  const EditDiary({super.key});

  @override
  State<EditDiary> createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    Box<RecordBox> recordBox = recordRepository.recordBox;
    RecordBox? recordInfo = recordBox.get(getDateTimeToInt(importDateTime));
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;
    bool isContainDiary =
        filterList != null && filterList.contains(FILITER.diary.toString());

    onTap() {
      textController.text = recordInfo?.whiteText ?? '';

      setState(() => isShowInput = !isShowInput);
    }

    onEditingComplete() {
      if (textController.text != '') {
        recordInfo?.whiteText = textController.text;
        recordInfo?.save();
      }

      setState(() => isShowInput = false);
    }

    return isContainDiary
        ? Column(
            children: [
              isShowInput
                  ? TextFormField(
                      controller: textController,
                      autofocus: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      keyboardType: TextInputType.text,
                      maxLength: 150,
                      textInputAction: TextInputAction.done,
                      minLines: null,
                      maxLines: null,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: tinySpace,
                        ),
                      ),
                      onEditingComplete: onEditingComplete,
                    )
                  : Row(
                      children: [
                        recordInfo?.whiteText != null
                            ? CommonText(
                                text: '📌${recordInfo!.whiteText!}',
                                size: 14,
                                onTap: onTap,
                              )
                            : DashContainer(
                                height: 40,
                                text: '메모',
                                borderType: BorderType.RRect,
                                radius: 10,
                                onTap: onTap,
                              ),
                      ],
                    ),
              SpaceHeight(height: smallSpace)
            ],
          )
        : const EmptyArea();
  }
}

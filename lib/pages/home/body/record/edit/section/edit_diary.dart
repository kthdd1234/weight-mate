import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonTag.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/title_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_picture.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class EditDiary extends StatefulWidget {
  EditDiary({
    super.key,
    required this.importDateTime,
    required this.recordType,
  });

  DateTime importDateTime;
  RECORD recordType;

  @override
  State<EditDiary> createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.recordType == RECORD.edit;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    RecordBox? recordInfo =
        recordBox.get(getDateTimeToInt(widget.importDateTime));
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;
    bool isContainDiary =
        filterList != null && filterList.contains(FILITER.diary.toString());

    onTap() {
      textController.text = recordInfo?.whiteText ?? '';

      setState(() => isShowInput = !isShowInput);
    }

    onTapRequest() {
      //
    }

    onEditingComplete() {
      if (textController.text != '') {
        recordInfo?.whiteText = textController.text;
        recordInfo?.save();
      }

      setState(() => isShowInput = false);
    }

    onTapRemove(_) {
      recordInfo?.whiteText = null;
      textController.text = '';

      recordInfo?.save();
    }

    onTapCollapse() {
      //
    }

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        ContentsBox(
          contentsWidget: Column(
            children: [
              TitleContainer(
                title: '일기',
                icon: Icons.auto_fix_high,
                tags: [
                  TagClass(
                    text: '질문 변경',
                    color: 'orange',
                    onTap: onTapRequest,
                  ),
                  TagClass(
                    icon: Icons.keyboard_arrow_down,
                    color: 'orange',
                    onTap: onTapCollapse,
                  )
                ],
              ),
              CommonText(
                text: '오늘의 다이어트는 어땠나요?',
                size: 15,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
  }
}



// Row(
//                           children: [
//                             recordInfo?.whiteText != null
//                                 ? Stack(
//                                     children: [
//                                       CommonText(
//                                         text:
//                                             '${'📌'}${recordInfo!.whiteText!}',
//                                         size: 14,
//                                         isWidth: true,
//                                         onTap: onTap,
//                                       ),
//                                       CloseIcon(
//                                         isEdit: isEdit,
//                                         onTapRemove: onTapRemove,
//                                         pos: '',
//                                       )
//                                     ],
//                                   )
//                                 : DashContainer(
//                                     height: 40,
//                                     text: '한줄 메모',
//                                     borderType: BorderType.RRect,
//                                     radius: 5,
//                                     onTap: onTap,
//                                   ),
//                           ],
//                         )

// isEdit
//         ? isContainDiary
//             ? Column(
//                 children: [
//                   SpaceHeight(height: smallSpace),
//                   isShowInput
//                       ? TextFormField(
//                           controller: textController,
//                           autofocus: true,
//                           style: Theme.of(context).textTheme.bodyMedium,
//                           keyboardType: TextInputType.text,
//                           maxLength: 150,
//                           textInputAction: TextInputAction.done,
//                           minLines: null,
//                           maxLines: null,
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: tinySpace,
//                             ),
//                           ),
//                           onEditingComplete: onEditingComplete,
//                         )
//                       : ,
//                 ],
//               )
//             : const EmptyArea()
//         : recordInfo?.whiteText != null
//             ? Text(recordInfo!.whiteText!,
//                 style: const TextStyle(
//                   color: themeColor,
//                   fontSize: 13,
//                 ))
//             : const EmptyArea();

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/title_container.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(widget.importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;
    String? emotion = recordInfo?.emotion;
    bool isContainDiary =
        filterList != null && filterList.contains(FILITER.diary.toString());

    onTapDiary() {
      textController.text = recordInfo?.whiteText ?? '';

      setState(() => isShowInput = !isShowInput);
    }

    onTapEmtion(String selectedEmotion) {
      if (recordInfo == null) {
        recordRepository.updateRecord(
          key: recordKey,
          record: RecordBox(
            createDateTime: widget.importDateTime,
            emotion: selectedEmotion,
          ),
        );
      } else {
        recordInfo.emotion = selectedEmotion;
      }

      recordInfo?.save();
      closeDialog(context);
    }

    onTapEmotionList() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => EmotionModal(
          emotion: emotion ?? '',
          onTap: onTapEmtion,
        ),
      );
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
                    text: '감정 기록',
                    color: 'orange',
                    onTap: onTapEmotionList,
                  ),
                  TagClass(
                    icon: Icons.keyboard_arrow_down_rounded,
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

class EmotionModal extends StatelessWidget {
  EmotionModal({super.key, required this.emotion, required this.onTap});

  String emotion;
  Function(String selectedEmotion) onTap;

  @override
  Widget build(BuildContext context) {
    onTapStreamline() async {
      await launchUrl(Uri(scheme: 'https', host: 'home.streamlinehq.com'));
    }

    onTapCCBY() async {
      await launchUrl(
        Uri(
            scheme: 'https',
            host: 'creativecommons.org',
            path: 'licenses/by/4.0/'),
      );
    }

    return DefaultBottomSheet(
      title: '감정',
      height: 560,
      contents: Expanded(
        child: ContentsBox(
          contentsWidget: GridView.builder(
            itemCount: emotionList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              SvgClass data = emotionList[index];
              String svgPath = 'assets/svgs/${data.emotion}.svg';

              return InkWell(
                onTap: () => onTap(data.emotion),
                child: Column(
                  children: [
                    SvgPicture.asset(svgPath, height: 40),
                    SpaceHeight(height: tinySpace),
                    data.emotion == emotion
                        ? CommonTag(color: 'orange', text: data.name)
                        : CommonText(text: data.name, size: 12, isCenter: true),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      subContents: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonText(
            text: '저작권 출처: ',
            size: 11,
            color: Colors.grey,
          ),
          CommonText(
            text: 'streamline',
            color: Colors.grey,
            size: 11,
            decoration: 'underLine',
            decoColor: Colors.grey,
            onTap: onTapStreamline,
          ),
          CommonText(
            text: ' / ',
            size: 11,
            color: Colors.grey,
          ),
          CommonText(
            text: 'CC BY',
            decoration: 'underLine',
            size: 11,
            decoColor: Colors.grey,
            color: Colors.grey,
            onTap: onTapCCBY,
          ),
        ],
      ),
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

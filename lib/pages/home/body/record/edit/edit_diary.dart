import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EditDiary extends StatefulWidget {
  EditDiary({super.key});

  @override
  State<EditDiary> createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController textController = TextEditingController();
  bool isStartDiary = false;
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    String fDiary = FILITER.diary.toString();
    UserBox user = userRepository.user;
    bool? isOpen = user.filterList?.contains(fDiary) == true;

    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    String? emotion = recordInfo?.emotion;

    onTapEditDiary() {
      setState(() {
        textController.text = recordInfo?.whiteText ?? '';
        isStartDiary = true;
        isShowInput = true;
      });
    }

    onTapEmtion(String selectedEmotion) {
      if (recordInfo == null) {
        recordRepository.updateRecord(
          key: recordKey,
          record: RecordBox(
            createDateTime: importDateTime,
            emotion: selectedEmotion,
          ),
        );
      } else {
        recordInfo.emotion = selectedEmotion;
      }

      bool? isContain = user.filterList?.contains(fDiary);
      if (isContain == false || isContain == null) {
        user.filterList?.add(fDiary);
      }

      recordInfo?.save();
      closeDialog(context);
    }

    onTapOpenEmotion() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => EmotionModal(
          emotion: emotion ?? '',
          onTap: onTapEmtion,
        ),
      );
    }

    onEditingComplete() async {
      if (textController.text != '') {
        DateTime now = DateTime.now();
        DateTime diaryDateTime = DateTime(
          importDateTime.year,
          importDateTime.month,
          importDateTime.day,
          now.hour,
          now.minute,
        );

        if (recordInfo == null) {
          await recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: diaryDateTime,
              diaryDateTime: diaryDateTime,
              whiteText: textController.text,
            ),
          );
        } else {
          recordInfo.whiteText = textController.text;
          recordInfo.diaryDateTime = diaryDateTime;
        }

        recordInfo?.save();
      }

      setState(() => isShowInput = false);
    }

    onTapOpen() {
      isOpen ? user.filterList?.remove(fDiary) : user.filterList?.add(fDiary);
      user.save();
    }

    onTapRemoveDiary() {
      if (recordInfo?.whiteText != null) {
        recordInfo?.whiteText = null;
        recordInfo?.diaryDateTime = null;
        recordInfo?.save();
      }

      setState(() {
        isStartDiary = false;
        isShowInput = false;
      });
      closeDialog(context);
    }

    onTapRemoveEmotion() {
      if (recordInfo?.emotion != null) {
        recordInfo?.emotion = null;
        recordInfo?.save();
      }

      closeDialog(context);
    }

    onTapMore() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return DefaultBottomSheet(
            title: '일기 설정',
            height: 220,
            contents: Row(
              children: [
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.edit,
                  title: '내용 수정',
                  onTap: () {
                    closeDialog(context);
                    onTapEditDiary();
                  },
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonVerti(
                  mainColor: Colors.red,
                  icon: Icons.delete_forever,
                  title: '내용 삭제',
                  onTap: onTapRemoveDiary,
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonVerti(
                  mainColor: Colors.red,
                  icon: Icons.delete_forever,
                  title: '감정 삭제',
                  onTap: onTapRemoveEmotion,
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: [
        ContentsBox(
          isBoxShadow: true,
          contentsWidget: Column(
            children: [
              TitleContainer(
                isDivider: isOpen,
                title: '일기',
                icon: Icons.auto_fix_high,
                tags: [
                  TagClass(
                    text: recordInfo?.diaryDateTime != null
                        ? timeToString(recordInfo?.diaryDateTime)
                        : '미작성',
                    color: 'orange',
                    isHide: isOpen,
                    onTap: onTapOpen,
                  ),
                  TagClass(
                    text: '감정 기록',
                    color: 'orange',
                    onTap: onTapOpenEmotion,
                  ),
                  TagClass(
                    icon: isOpen
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: 'orange',
                    onTap: onTapOpen,
                  )
                ],
              ),
              isOpen
                  ? Column(
                      children: [
                        DiaryTitle(
                          importDateTime: importDateTime,
                          emotion: emotion,
                          onTapMore: onTapMore,
                          onTapEmotion: onTapOpenEmotion,
                        ),
                        isShowInput
                            ? TextFormField(
                                autofocus: true,
                                textInputAction: TextInputAction.done,
                                controller: textController,
                                maxLength: 200,
                                maxLines: null,
                                minLines: null,
                                onEditingComplete: onEditingComplete,
                              )
                            : recordInfo?.whiteText != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SpaceHeight(height: smallSpace),
                                      InkWell(
                                        onTap: onTapEditDiary,
                                        child: Text(
                                          recordInfo?.whiteText ?? '',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: themeColor,
                                          ),
                                        ),
                                      ),
                                      SpaceHeight(height: smallSpace),
                                      CommonText(
                                        text: recordInfo?.diaryDateTime != null
                                            ? timeToString(
                                                recordInfo!.diaryDateTime,
                                              )
                                            : '',
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SpaceHeight(height: smallSpace),
                                      InkWell(
                                        onTap: onTapEditDiary,
                                        child: ContentsBox(
                                          padding:
                                              const EdgeInsets.all(smallSpace),
                                          imgUrl: 'assets/images/t-16.png',
                                          contentsWidget: CommonText(
                                            text: '일기 작성하기',
                                            size: 14,
                                            isCenter: true,
                                            isBold: true,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                      ],
                    )
                  : const EmptyArea(),
            ],
          ),
        ),
      ],
    );
  }
}

class DiaryTitle extends StatelessWidget {
  DiaryTitle({
    super.key,
    required this.importDateTime,
    required this.emotion,
    required this.onTapMore,
    required this.onTapEmotion,
  });

  DateTime importDateTime;
  String? emotion;
  Function() onTapMore;
  Function() onTapEmotion;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        emotion != null
            ? Row(
                children: [
                  InkWell(
                    onTap: onTapEmotion,
                    child: SvgPicture.asset(
                      'assets/svgs/$emotion.svg',
                      height: 40,
                    ),
                  ),
                  SpaceWidth(width: smallSpace),
                ],
              )
            : const EmptyArea(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: dateTimeFormatter(
                format: 'M월 d일',
                dateTime: importDateTime,
              ),
              size: 13,
              isBold: true,
            ),
            CommonText(
              text: dateTimeFormatter(
                format: 'EE요일',
                dateTime: importDateTime,
              ),
              size: 13,
              color: Colors.grey,
            )
          ],
        ),
        const Spacer(),
        CommonIcon(
          icon: Icons.more_vert_rounded,
          size: 20,
          color: Colors.grey,
          onTap: onTapMore,
        )
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
            text: '출처: ',
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

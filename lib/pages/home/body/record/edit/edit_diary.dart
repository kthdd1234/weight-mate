// ignore_for_file: use_build_context_synchronously, prefer_is_empty
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/EmotionBottomSheet.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/HashTagBottomSheet.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/diary_write_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class EditDiary extends StatelessWidget {
  const EditDiary({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    String fDiary = FILITER.diary.toString();
    UserBox user = userRepository.user;
    bool? isDisplay = user.displayList?.contains(fDiary) == true;
    bool? isOpen = user.filterList?.contains(fDiary) == true;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    String? emotion = recordInfo?.emotion;
    List<Map<String, String>>? recordHashTagList =
        recordInfo?.recordHashTagList;

    onTapWriteDiary() async {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              DiaryWritePage(dateTime: importDateTime),
        ),
      );
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
        builder: (BuildContext context) => EmotionBottomSheet(
          emotion: emotion ?? '',
          onTap: onTapEmtion,
        ),
      );
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
          return CommonBottomSheet(
            title: '일기 설정'.tr(),
            height: 220,
            contents: Row(
              children: [
                ExpandedButtonVerti(
                  mainColor: textColor,
                  icon: Icons.edit,
                  title: '내용 수정',
                  onTap: () {
                    closeDialog(context);
                    onTapWriteDiary();
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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

    onTapDiaryCollection() {
      Navigator.pushNamed(context, '/diary-collection-page');
    }

    onTapHashTag(String id) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => HashTagBottomSheet(
          hashTagIdList: getHashTagClassList(recordInfo?.recordHashTagList)
              .map((hashTag) => hashTag.id)
              .toList(),
          onCompleted: (List<HashTagClass> newHashTagList) async {
            if (recordInfo == null) {
              recordRepository.updateRecord(
                key: recordKey,
                record: RecordBox(
                  createDateTime: importDateTime,
                  recordHashTagList: getHashTagMapList(newHashTagList),
                ),
              );
            } else {
              log('$newHashTagList');
              recordInfo.recordHashTagList = getHashTagMapList(newHashTagList);
            }

            bool? isContain = user.filterList?.contains(fDiary);
            if (isContain == false || isContain == null) {
              user.filterList?.add(fDiary);
            }

            await recordInfo?.save();
          },
        ),
      );
    }

    bool isRecordHashTagList = recordInfo?.recordHashTagList == null ||
        recordInfo?.recordHashTagList?.length == 0;
    bool isDateTime = recordInfo?.whiteText == null &&
        recordInfo?.emotion == null &&
        isRecordHashTagList;
    bool isWhite = recordInfo?.whiteText == null && isRecordHashTagList;

    List<TagClass> tags = [
      TagClass(
        text: !isWhite
            ? hm(
                locale: context.locale.toString(),
                dateTime: recordInfo?.diaryDateTime ?? DateTime.now(),
              )
            : '미작성',
        isNotTr: recordInfo?.whiteText != null,
        color: 'orange',
        isHide: isOpen,
        onTap: onTapOpen,
      ),
      TagClass(
        text: '일기 모아보기',
        color: 'orange',
        onTap: onTapDiaryCollection,
      ),
      TagClass(
        icon: isOpen
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_right_rounded,
        color: 'orange',
        onTap: onTapOpen,
      )
    ];

    return isDisplay
        ? SizedBox(
            child: Column(
              children: [
                ContentsBox(
                  contentsWidget: Column(
                    children: [
                      TitleContainer(
                        isDivider: isOpen,
                        title: '일기',
                        icon: Icons.auto_fix_high,
                        tags: tags,
                        onTap: onTapOpen,
                      ),
                      isOpen
                          ? isDateTime
                              ? DiaryButton(
                                  paddingTop: 0,
                                  onTap: onTapWriteDiary,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DiaryTitle(
                                      importDateTime: importDateTime,
                                      emotion: emotion,
                                      onTapMore: onTapMore,
                                      onTapEmotion: onTapOpenEmotion,
                                    ),
                                    isWhite
                                        ? DiaryButton(
                                            paddingTop: 10,
                                            onTap: onTapWriteDiary,
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DiaryWriteText(
                                                whiteText:
                                                    recordInfo?.whiteText,
                                                diaryDateTime:
                                                    recordInfo?.diaryDateTime,
                                                onTap: onTapMore,
                                              ),
                                              DiaryHashTag(
                                                hashTagClassList:
                                                    getHashTagClassList(
                                                  recordInfo?.recordHashTagList,
                                                ),
                                                onItem: onTapHashTag,
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
            ),
          )
        : const EmptyArea();
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
              text: md(
                locale: context.locale.toString(),
                dateTime: importDateTime,
              ),
              isNotTr: true,
              size: 13,
              color: themeColor,
            ),
            CommonText(
              text: e(
                locale: context.locale.toString(),
                dateTime: importDateTime,
              ),
              isNotTr: true,
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

class DiaryButton extends StatelessWidget {
  DiaryButton({super.key, required this.onTap, required this.paddingTop});

  double paddingTop;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: ContentsBox(
          borderRadius: 7,
          padding: const EdgeInsets.all(14),
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
    );
  }
}

class DiaryHashTag extends StatelessWidget {
  DiaryHashTag({
    super.key,
    required this.hashTagClassList,
    this.paddingTop,
    this.onItem,
  });

  List<HashTagClass> hashTagClassList;
  double? paddingTop;
  Function(String)? onItem;

  @override
  Widget build(BuildContext context) {
    return hashTagClassList.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(top: paddingTop ?? 10),
            child: Wrap(
                spacing: 5,
                runSpacing: 7,
                children: hashTagClassList
                    .map((hashTag) => HashTag(
                          id: hashTag.id,
                          text: hashTag.text,
                          colorName: hashTag.colorName,
                          isFilled: true,
                          isEditMode: false,
                          onItem: onItem ?? (_) {},
                          onRemove: (_) {},
                        ))
                    .toList()),
          )
        : const EmptyArea();
  }
}

class DiaryWriteText extends StatelessWidget {
  DiaryWriteText({
    super.key,
    this.whiteText,
    this.diaryDateTime,
    required this.onTap,
  });

  String? whiteText;
  DateTime? diaryDateTime;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return whiteText != null
        ? InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    whiteText!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                  SpaceHeight(height: 5),
                  CommonText(
                    isNotTr: true,
                    size: 12,
                    color: grey.original,
                    text: hm(
                      locale: context.locale.toString(),
                      dateTime: diaryDateTime ?? DateTime.now(),
                    ),
                  )
                ],
              ),
            ),
          )
        : const EmptyArea();
  }
}

// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/diary_write_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
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

    onTapWriteDiary() async {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              DiaryWritePage(dateTime: importDateTime),
        ),
      );
      // final result = await Navigator.pushNamed(context, '/diary-write-page');

      // if (result == 'save') {
      //   onClick(BottomNavigationEnum enumId) async {
      //     context
      //         .read<BottomNavigationProvider>()
      //         .setBottomNavigation(enumId: enumId);
      //     closeDialog(context);
      //   }

      //   await showDialog(
      //     context: context,
      //     builder: (context) => NativeAdDialog(
      //       loadingText: '일기 데이터 저장 중...',
      //       title: '📝 일기 작성 완료!',
      //       leftText: '히스토리',
      //       rightText: '그래프',
      //       onLeftClick: () => onClick(BottomNavigationEnum.history),
      //       onRightClick: () => onClick(BottomNavigationEnum.graph),
      //     ),
      //   );
      // }
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
                  mainColor: themeColor,
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

    List<TagClass> tags = [
      TagClass(
        text: recordInfo?.whiteText != null
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
                          ? recordInfo?.whiteText == null &&
                                  recordInfo?.emotion == null
                              ? DiaryWriteButton(onTap: onTapWriteDiary)
                              : Column(
                                  children: [
                                    DiaryTitle(
                                      importDateTime: importDateTime,
                                      emotion: emotion,
                                      onTapMore: onTapMore,
                                      onTapEmotion: onTapOpenEmotion,
                                    ),
                                    SpaceHeight(height: smallSpace),
                                    recordInfo?.whiteText == null
                                        ? DiaryWriteButton(
                                            onTap: onTapWriteDiary,
                                          )
                                        : InkWell(
                                            onTap: onTapMore,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recordInfo!.whiteText!,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: themeColor,
                                                  ),
                                                ),
                                                SpaceHeight(height: smallSpace),
                                                CommonText(
                                                  isNotTr: true,
                                                  size: 12,
                                                  color: Colors.grey,
                                                  text: hm(
                                                    locale: context.locale
                                                        .toString(),
                                                    dateTime: recordInfo
                                                            .diaryDateTime ??
                                                        DateTime.now(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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

class DiaryWriteButton extends StatelessWidget {
  DiaryWriteButton({super.key, required this.onTap});

  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              text: md(
                locale: context.locale.toString(),
                dateTime: importDateTime,
              ),
              isNotTr: true,
              size: 13,
              isBold: true,
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

class EmotionBottomSheet extends StatelessWidget {
  EmotionBottomSheet({super.key, required this.emotion, required this.onTap});

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
          path: 'licenses/by/4.0/',
        ),
      );
    }

    return CommonBottomSheet(
      title: '감정'.tr(),
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
            isNotTr: true,
            text: 'streamline',
            color: Colors.grey,
            size: 11,
            decoration: 'underLine',
            decoColor: Colors.grey,
            onTap: onTapStreamline,
          ),
          CommonText(
            isNotTr: true,
            text: ' / ',
            size: 11,
            color: Colors.grey,
          ),
          CommonText(
            isNotTr: true,
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

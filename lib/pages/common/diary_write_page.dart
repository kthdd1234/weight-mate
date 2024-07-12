// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/HashTagBottomSheet.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_diary.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_svg/svg.dart';

class DiaryWritePage extends StatefulWidget {
  DiaryWritePage({super.key, this.dateTime});

  DateTime? dateTime;

  @override
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  DateTime? targetDateTime;
  RecordBox? recordInfo;
  bool isEnabledButton = false;
  String emotion = '';

  @override
  void didChangeDependencies() {
    setState(() {
      targetDateTime = widget.dateTime ?? DateTime.now();
      recordInfo =
          recordRepository.recordBox.get(getDateTimeToInt(targetDateTime));
      controller.text = recordInfo?.whiteText ?? '';
      emotion = recordInfo?.emotion ?? '';

      if (recordInfo?.emotion != null || recordInfo?.whiteText != null) {
        isEnabledButton = true;
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    onTapEmotion() {
      showModalBottomSheet(
        context: context,
        builder: (context) => EmotionBottomSheet(
          emotion: emotion,
          onTap: (selectedEmotion) {
            setState(() {
              emotion = selectedEmotion;
              isEnabledButton = true;
            });

            closeDialog(context);
          },
        ),
      );
    }

    onChanged(String newValue) {
      setState(() {
        isEnabledButton = newValue == '' && emotion == '' ? false : true;
      });
    }

    onCompleted() async {
      if (isEnabledButton) {
        DateTime now = DateTime.now();
        DateTime diaryDateTime = DateTime(
          targetDateTime!.year,
          targetDateTime!.month,
          targetDateTime!.day,
          now.hour,
          now.minute,
        );
        String? rEmotion = emotion != '' ? emotion : null;
        String? whiteText = controller.text != '' ? controller.text : null;

        if (recordInfo == null) {
          recordRepository.updateRecord(
            key: getDateTimeToInt(targetDateTime),
            record: RecordBox(
              createDateTime: diaryDateTime,
              diaryDateTime: diaryDateTime,
              whiteText: whiteText,
              emotion: rEmotion,
            ),
          );
        } else {
          recordInfo?.emotion = rEmotion;
          recordInfo?.whiteText = whiteText;
          recordInfo?.diaryDateTime = diaryDateTime;
        }

        await recordInfo?.save();
        Navigator.pop(context, 'save');
      }
    }

    hashTagBtn() {
      return Expanded(
        flex: 0,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => HashTagBottomSheet(),
            );
          },
          child: ContentsBox(
            borderRadius: 10,
            height: submitButtonHeight,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            imgUrl: 'assets/images/t-23.png',
            contentsWidget: CommonText(
              text: '#해시태그',
              size: 15,
              color: Colors.white,
              isBold: true,
              isCenter: true,
            ),
          ),
        ),
      );
    }

    completedBtn() {
      return Expanded(
        child: BottomSubmitButton(
          padding: const EdgeInsets.all(0),
          isEnabled: isEnabledButton,
          borderRadius: 10,
          text: '작성 완료'.tr(),
          onPressed: onCompleted,
        ),
      );
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('일기'.tr(), style: const TextStyle(fontSize: 20)),
          backgroundColor: Colors.transparent,
          foregroundColor: textColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ContentsBox(
                      contentsWidget: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CommonTag(
                                  color: 'orange',
                                  text: '키보드 내리기',
                                  onTap: () => focusNode.unfocus(),
                                ),
                              ],
                            ),
                            SpaceHeight(height: 5),
                            emotion == ''
                                ? Row(
                                    children: [
                                      DashContainer(
                                        height: 50,
                                        text: '감정',
                                        borderType: BorderType.Circle,
                                        radius: 100,
                                        onTap: onTapEmotion,
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: onTapEmotion,
                                    child: SvgPicture.asset(
                                      'assets/svgs/$emotion.svg',
                                      height: 50,
                                    ),
                                  ),
                            SpaceHeight(height: 10),
                            CommonText(
                              text: ymd(
                                locale: context.locale.toString(),
                                dateTime: targetDateTime ?? DateTime.now(),
                              ),
                              size: 12,
                              isNotTr: true,
                              isCenter: true,
                              isBold: true,
                            ),
                            SpaceHeight(height: 3),
                            CommonText(
                              text: e(
                                locale: context.locale.toString(),
                                dateTime: targetDateTime ?? DateTime.now(),
                              ),
                              size: 12,
                              isNotTr: true,
                              isCenter: true,
                              color: Colors.grey,
                            ),
                            SpaceHeight(height: 10),
                            TextFormField(
                              focusNode: focusNode,
                              controller: controller,
                              autofocus: true,
                              maxLines: null,
                              minLines: null,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '오늘 다이어트를 하면서 어땠는지 기록해보아요 :D'.tr(),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              onChanged: onChanged,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    hashTagBtn(),
                    SpaceWidth(width: 5),
                    completedBtn(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

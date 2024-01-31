import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_diary.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DiaryWritePage extends StatefulWidget {
  const DiaryWritePage({super.key});

  @override
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  DateTime? importDateTime;
  RecordBox? recordInfo;
  bool isEnabledButton = false;
  String emotion = '';

  @override
  void initState() {
    String? passwords = userRepository.user.screenLockPasswords;
    AppLifecycleReactor(context: context).listenToAppStateChanges();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      importDateTime =
          context.watch<ImportDateTimeProvider>().getImportDateTime();
      recordInfo =
          recordRepository.recordBox.get(getDateTimeToInt(importDateTime));
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
        builder: (context) => EmotionModal(
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

    onTapCompleted() {
      if (isEnabledButton) {
        DateTime now = DateTime.now();
        DateTime diaryDateTime = DateTime(
          importDateTime!.year,
          importDateTime!.month,
          importDateTime!.day,
          now.hour,
          now.minute,
        );
        String? rEmotion = emotion != '' ? emotion : null;
        String? whiteText = controller.text != '' ? controller.text : null;

        if (recordInfo == null) {
          recordRepository.updateRecord(
            key: getDateTimeToInt(importDateTime),
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

        recordInfo?.save();
        Navigator.pop(context, 'save');
        //
      }
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('일기', style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
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
                    padding: const EdgeInsets.only(bottom: 20),
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
                              text: dateTimeFormatter(
                                format: 'yyyy년 M월 d일',
                                dateTime: importDateTime ?? DateTime.now(),
                              ),
                              size: 12,
                              isCenter: true,
                              isBold: true,
                            ),
                            SpaceHeight(height: 3),
                            CommonText(
                              text: dateTimeFormatter(
                                format: 'EE요일',
                                dateTime: importDateTime ?? DateTime.now(),
                              ),
                              size: 12,
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
                                hintText: '오늘 다이어트를 하면서 어땠는지 기록해보아요 :D',
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
                BottomSubmitButton(
                  padding: const EdgeInsets.all(0),
                  isEnabled: isEnabledButton,
                  text: '작성 완료',
                  onPressed: onTapCompleted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

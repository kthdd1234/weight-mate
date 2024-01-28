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
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';

class DiaryWritePage extends StatefulWidget {
  const DiaryWritePage({super.key});

  @override
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);

    onTapEmptyEmotion() {
      //
    }

    onPressed() {
      //
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
                                  onTap: () => FocusScope.of(context).unfocus(),
                                ),
                              ],
                            ),
                            SpaceHeight(height: 5),
                            Row(
                              children: [
                                DashContainer(
                                  height: 60,
                                  text: '감정',
                                  borderType: BorderType.Circle,
                                  radius: 100,
                                  onTap: onTapEmptyEmotion,
                                ),
                              ],
                            ),
                            SpaceHeight(height: 10),
                            CommonText(
                              text: dateTimeFormatter(
                                format: 'yyyy년 M월 d일',
                                dateTime: importDateTime,
                              ),
                              size: 12,
                              isCenter: true,
                              isBold: true,
                            ),
                            SpaceHeight(height: 3),
                            CommonText(
                              text: dateTimeFormatter(
                                format: 'EE요일',
                                dateTime: importDateTime,
                              ),
                              size: 12,
                              isCenter: true,
                              color: Colors.grey,
                            ),
                            SpaceHeight(height: 10),
                            TextFormField(
                              controller: controller,
                              autofocus: true,
                              maxLines: null,
                              minLines: null,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '오늘 다이어트를 하면서 어땠는지 기록해보아요 :D',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade300)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                BottomSubmitButton(
                  padding: EdgeInsets.all(0),
                  isEnabled: true,
                  text: '작성 완료',
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

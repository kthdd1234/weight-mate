// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/dot_container.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SvgClass {
  SvgClass({required this.emotion, required this.name});
  String emotion, name;
}

List<SvgClass> svgData = [
  SvgClass(emotion: 'slightly-smiling-face', name: '흐뭇'),
  SvgClass(emotion: 'grinning-face-with-smiling-eyes', name: '기쁨'),
  SvgClass(emotion: 'grinning-squinting-face', name: '짜릿'),
  SvgClass(emotion: 'kissing-face', name: '신남'),
  SvgClass(emotion: 'neutral-face', name: '보통'),
  SvgClass(emotion: 'amazed-face', name: '놀람'),
  SvgClass(emotion: 'anxious-face', name: '서운'),
  SvgClass(emotion: 'crying-face', name: '슬픔'),
  SvgClass(emotion: 'determined-face', name: '다짐'),
  SvgClass(emotion: 'disappointed-face', name: '실망'),
  SvgClass(emotion: 'dizzy-face', name: '피곤'),
  SvgClass(emotion: 'grinning-face-with-sweat', name: '다행'),
  SvgClass(emotion: 'expressionless-face', name: '고요'),
  SvgClass(emotion: 'face-blowing-a-kiss', name: '사랑'),
  SvgClass(emotion: 'sneezing-face', name: '아픔'),
  SvgClass(emotion: 'worried-face', name: '걱정'),
  SvgClass(emotion: 'winking-face-with-tongue', name: '장난'),
  SvgClass(emotion: 'face-with-steam-from-nose', name: '화남'),
  SvgClass(emotion: 'loudly-crying-face', name: '감동'),
  SvgClass(emotion: 'smiling-face-with-halo', name: '해탈'),
];

class RecordProfile extends StatefulWidget {
  const RecordProfile({super.key});

  @override
  State<RecordProfile> createState() => _RecordProfileState();
}

class _RecordProfileState extends State<RecordProfile> {
  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.read<ImportDateTimeProvider>().getImportDateTime();
    DateTime now = DateTime.now();
    int recordKey = getDateTimeToInt(now);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    String? emotion = recordInfo?.emotion;

    onTap(String emotion) {
      if (recordInfo == null) {
        recordRepository.updateRecord(
          key: recordKey,
          record: RecordBox(
            createDateTime: importDateTime,
            emotion: emotion,
          ),
        );
      } else {
        recordInfo.emotion = emotion;
      }

      recordInfo?.save();
      closeDialog(context);
    }

    onTapEmotion() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DefaultBottomSheet(
            title: '감정',
            height: 600,
            contents: Expanded(
              child: GridView.builder(
                itemCount: svgData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  SvgClass data = svgData[index];
                  String svgPath = 'assets/svgs/${data.emotion}.svg';

                  return InkWell(
                    onTap: () => onTap(data.emotion),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(svgPath, height: 40),
                            SpaceHeight(height: tinySpace),
                            CommonText(
                              text: data.name,
                              size: 12,
                              isCenter: true,
                            ),
                          ],
                        ),
                        data.emotion == emotion
                            ? Positioned(
                                right: 7,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.purple.shade200,
                                  size: 18,
                                ),
                              )
                            : const EmptyArea(),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    onTapWeight() {
      //
    }

    onTapFilter() {
      //
    }

    Widget wSvg = SvgPicture.asset('assets/svgs/$emotion.svg', height: 70);
    Widget wEmotion = emotion != null
        ? InkWell(onTap: onTapEmotion, child: wSvg)
        : DotContainer(
            height: 100,
            text: '감정',
            borderType: BorderType.Circle,
            radius: 100,
            onTap: onTapEmotion,
          );

    return Column(
      children: [
        Row(
          children: [
            wEmotion,
            SpaceWidth(width: smallSpace + tinySpace),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(text: '21일 목요일 (오늘)', size: 15, isBold: true),
                      CommonText(
                        text: '필터',
                        size: 13,
                        leftIcon: Icons.filter_alt_outlined,
                        color: Colors.grey,
                        onTap: onTapFilter,
                      ),
                    ],
                  ),
                  SpaceHeight(height: smallSpace),
                  Row(
                    children: [
                      DotContainer(
                        height: 40,
                        text: '체중(kg)',
                        borderType: BorderType.RRect,
                        radius: 10,
                        onTap: onTapWeight,
                      ),
                    ],
                  ),
                  // TextInput(
                  //   suffixText: 'kg',
                  //   hintText: '체중을 입력해주세요.',
                  //   onChanged: (String newValue) {},
                  //   errorText: null,
                  // )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: smallSpace)
      ],
    );
  }
}

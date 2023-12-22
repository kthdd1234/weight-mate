// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/dot_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';

class SvgClass {
  SvgClass({required this.id, required this.name});
  String id, name;
}

List<SvgClass> svgData = [
  SvgClass(id: 'slightly-smiling-face', name: '흐뭇'),
  SvgClass(id: 'grinning-face-with-smiling-eyes', name: '기쁨'),
  SvgClass(id: 'grinning-squinting-face', name: '짜릿'),
  SvgClass(id: 'kissing-face', name: '신남'),
  SvgClass(id: 'neutral-face', name: '보통'),
  SvgClass(id: 'amazed-face', name: '놀람'),
  SvgClass(id: 'anxious-face', name: '서운'),
  SvgClass(id: 'crying-face', name: '슬픔'),
  SvgClass(id: 'determined-face', name: '다짐'),
  SvgClass(id: 'disappointed-face', name: '실망'),
  SvgClass(id: 'dizzy-face', name: '피곤'),
  SvgClass(id: 'grinning-face-with-sweat', name: '다행'),
  SvgClass(id: 'expressionless-face', name: '고요'),
  SvgClass(id: 'face-blowing-a-kiss', name: '사랑'),
  SvgClass(id: 'sneezing-face', name: '아픔'),
  SvgClass(id: 'worried-face', name: '걱정'),
  SvgClass(id: 'winking-face-with-tongue', name: '장난'),
  SvgClass(id: 'face-with-steam-from-nose', name: '화남'),
  SvgClass(id: 'loudly-crying-face', name: '감동'),
  SvgClass(id: 'smiling-face-with-halo', name: '해탈'),
];

class RecordProfile extends StatefulWidget {
  const RecordProfile({super.key});

  @override
  State<RecordProfile> createState() => _RecordProfileState();
}

class _RecordProfileState extends State<RecordProfile> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    RecordBox? recordInfo =
        recordRepository.recordBox.get(getDateTimeToInt(now));
    String? emotion = recordInfo?.emotion;

    onTap(String id) {
      // todo
    }

    onTapEmptyEmotion() {
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

                  return InkWell(
                    onTap: () => onTap(data.id),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: emotion == data.id
                                  ? Colors.purple.shade100
                                  : Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svgs/${data.id}.svg',
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SpaceHeight(height: tinySpace),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            emotion == data.id
                                ? Column(
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: themeColor,
                                      ),
                                      SpaceWidth(width: 3),
                                    ],
                                  )
                                : const EmptyArea(),
                            Text(
                              data.name,
                              style: const TextStyle(
                                color: themeColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            submitText: '확인',
          );
        },
      );
    }

    onTapEmptyWeight() {
      //
    }

    Widget wSvg = SvgPicture.asset('assets/svgs/amazed-face.svg', height: 70);
    Widget wEmotion = emotion != null
        ? wSvg
        : DotContainer(
            height: 100,
            text: '감정',
            borderType: BorderType.Circle,
            radius: 100,
            onTap: onTapEmptyEmotion,
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
                  const Text(
                    '21일 목요일 (오늘)',
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SpaceHeight(height: smallSpace),
                  Row(
                    children: [
                      DotContainer(
                        height: 40,
                        text: '체중(kg)',
                        borderType: BorderType.RRect,
                        radius: 10,
                        onTap: onTapEmptyWeight,
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

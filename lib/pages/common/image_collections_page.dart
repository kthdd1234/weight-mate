// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_carousel_slider_page.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/TimeLabel.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class InitClearClass {
  InitClearClass({required this.isMode, required this.selectionList});

  bool isMode;
  List<int> selectionList;
}

class ImageCollectionsPage extends StatefulWidget {
  const ImageCollectionsPage({super.key});

  @override
  State<ImageCollectionsPage> createState() => _ImageCollectionsPageState();
}

class _ImageCollectionsPageState extends State<ImageCollectionsPage> {
  bool isRecent = true;
  InitClearClass initClearState =
      InitClearClass(isMode: false, selectionList: []);
  List<Map<String, dynamic>> fileItemList = [];

  onInitList() {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();
    List<Map<String, dynamic>> list = [];

    for (var i = 0; i < recordList.length; i++) {
      RecordBox record = recordList[i];

      List<Map<String, dynamic>> itemList = [
        {'pos': 'left', 'file': record.leftFile, 'time': record.leftFileTime},
        {
          'pos': 'right',
          'file': record.rightFile,
          'time': record.rightFileTime
        },
        {
          'pos': 'bottom',
          'file': record.bottomFile,
          'time': record.bottomFileTime
        },
        {'pos': 'top', 'file': record.topFile, 'time': record.topFileTime}
      ];

      itemList.forEach((item) {
        if (item['file'] != null) {
          list.add({
            'dateTime': record.createDateTime,
            'file': item['file'],
            'pos': item['pos'],
            'time': item['time'],
          });
        }
      });

      fileItemList = list.reversed.toList();
    }
  }

  @override
  void initState() {
    onInitList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTapPicture({required int index, required bool isAutoPlay}) async {
      if (fileItemList.isEmpty) {
        return showSnackBar(
          context: context,
          text: '사진이 없어요.',
          buttonName: '확인',
          width: 230,
        );
      }

      await Navigator.push(
        context,
        FadePageRoute(
          page: ImageCarouselSliderPage(
            initPageIndex: index,
            fileItemList: fileItemList,
            isAutoPlay: isAutoPlay,
          ),
        ),
      );
    }

    onTapSelection(int index) {
      List<int> selectionList = initClearState.selectionList;

      setState(() {
        selectionList.contains(index)
            ? selectionList.remove(index)
            : selectionList.add(index);
      });
    }

    onTapOrder() {
      setState(() {
        isRecent = !isRecent;
        fileItemList = fileItemList.reversed.toList();
      });
    }

    onTapInitClear(bool isValue) {
      if (fileItemList.isEmpty) {
        return showSnackBar(
          context: context,
          text: '사진이 없어요.',
          buttonName: '확인',
          width: 230,
        );
      }

      setState(() {
        if (isValue == false) {
          initClearState.isMode = false;
          initClearState.selectionList = [];
        }

        initClearState.isMode = isValue;
      });
    }

    wTag({
      required String colorName,
      required String text,
      required Function() onTap,
      Map<String, String>? nameArgs,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: CommonTag(
          color: colorName,
          text: text,
          nameArgs: nameArgs,
          onTap: onTap,
        ),
      );
    }

    onTapRemoveSelection() {
      List<int> selectionList = initClearState.selectionList;

      if (selectionList.isNotEmpty) {
        showDialog(
            context: context,
            builder: (context) => CommonPopup(
                  height: 155,
                  child: ContentsBox(
                    contentsWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonName(
                          text: '장의 사진을 삭제할까요?',
                          nameArgs: {'length': '${selectionList.length}'},
                          fontSize: 15,
                        ),
                        SpaceHeight(height: 10),
                        Row(
                          children: [
                            ExpandedButtonHori(
                              padding: const EdgeInsets.all(12),
                              imgUrl: 'assets/images/t-4.png',
                              text: '삭제',
                              onTap: () {
                                selectionList.forEach((idx) async {
                                  Map<String, dynamic> item = fileItemList[idx];
                                  String pos = item['pos'];
                                  DateTime dateTime = item['dateTime'];
                                  int recordKey = getDateTimeToInt(dateTime);
                                  RecordBox? record =
                                      recordRepository.recordBox.get(recordKey);

                                  switch (pos) {
                                    case 'left':
                                      record?.leftFile = null;
                                      break;
                                    case 'right':
                                      record?.rightFile = null;
                                      break;
                                    case 'bottom':
                                      record?.bottomFile = null;
                                      break;
                                    case 'top':
                                      record?.topFile = null;
                                      break;
                                    default:
                                  }

                                  await record?.save();
                                });

                                setState(() {
                                  initClearState.isMode = false;
                                  initClearState.selectionList = [];
                                  isRecent = true;

                                  onInitList();
                                });
                                closeDialog(context);
                              },
                            ),
                            SpaceWidth(width: tinySpace),
                            ExpandedButtonHori(
                              padding: const EdgeInsets.all(12),
                              imgUrl: 'assets/images/t-1.png',
                              text: '취소',
                              onTap: () => Navigator.of(context).pop(false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
      }
    }

    return CommonBackground(
      child: CommonScaffold(
        padding: const EdgeInsets.all(5),
        appBarInfo: AppBarInfoClass(
          title: '',
          actions: [
            initClearState.isMode
                ? Row(
                    children: [
                      wTag(
                        colorName: initClearState.selectionList.isNotEmpty
                            ? 'whiteRed'
                            : 'whiteGrey',
                        text: '장 삭제하기',
                        onTap: onTapRemoveSelection,
                        nameArgs: {
                          'length': '${initClearState.selectionList.length}'
                        },
                      ),
                      wTag(
                        colorName: 'whiteGrey',
                        text: '취소하기',
                        onTap: () => onTapInitClear(false),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      wTag(
                        colorName: 'whiteIndigo',
                        text: '사진 슬라이드로 보기',
                        onTap: () => onTapPicture(index: 0, isAutoPlay: true),
                      ),
                      wTag(
                        colorName: 'whitePink',
                        text: '사진 정리하기',
                        onTap: () => onTapInitClear(true),
                      ),
                      wTag(
                        colorName: isRecent ? 'whiteBlue' : 'whiteRed',
                        text: isRecent ? '최신순' : '과거순',
                        onTap: onTapOrder,
                      ),
                    ],
                  ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            initClearState.isMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonText(
                        text: '삭제 할 사진을 모두 선택해주세요.',
                        size: 11,
                        leftIcon: Icons.check,
                        color: Colors.grey,
                      ),
                      SpaceWidth(width: 5)
                    ],
                  )
                : const EmptyArea(),
            SpaceHeight(height: smallSpace),
            fileItemList.isNotEmpty
                ? Expanded(
                    child: GridView.builder(
                      itemCount: fileItemList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemBuilder: (BuildContext buildContext, int index) {
                        Map<String, dynamic> item = fileItemList[index];
                        Uint8List file = item['file'];
                        DateTime dateTime = item['dateTime'];
                        DateTime? time = item['time'];

                        return InkWell(
                          onTap: () => initClearState.isMode
                              ? onTapSelection(index)
                              : onTapPicture(
                                  index: index,
                                  isAutoPlay: false,
                                ),
                          child: Stack(
                            children: [
                              DefaultImage(
                                unit8List: file,
                                height: MediaQuery.of(context).size.height,
                              ),
                              DateTimeLabel(
                                dateTime: dateTime,
                                onTap: () => onTapPicture(
                                  index: index,
                                  isAutoPlay: false,
                                ),
                              ),
                              TimeLabel(time: time, size: 10),
                              initClearState.isMode &&
                                      initClearState.selectionList
                                          .contains(index)
                                  ? Stack(
                                      children: [MaskLabel(), SelectionLabel()],
                                    )
                                  : const EmptyArea()
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : EmptyTextVerticalArea(
                    iconSize: 30,
                    titleSize: 15,
                    icon: Icons.wallpaper,
                    title: '추가한 사진이 없어요.',
                    backgroundColor: Colors.transparent,
                  ),
            SpaceHeight(height: smallSpace),
          ],
        ),
      ),
    );
  }
}

class MaskLabel extends StatelessWidget {
  MaskLabel({super.key, this.width, this.height, this.opacity});

  double? width, height, opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(opacity ?? 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class DateTimeLabel extends StatelessWidget {
  DateTimeLabel({super.key, required this.dateTime, required this.onTap});

  DateTime dateTime;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextIcon(
          padding: 5,
          backgroundColor: textColor,
          backgroundColorOpacity: 0.5,
          text: md(
            locale: context.locale.toString(),
            dateTime: dateTime,
          ),
          borderRadius: 5,
          textColor: typeBackgroundColor,
          fontSize: 10,
          onTap: onTap,
        ),
      ),
    );
  }
}

class SelectionLabel extends StatelessWidget {
  SelectionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: CommonIcon(
          icon: Icons.check_rounded,
          size: 20,
          color: Colors.red.shade300,
        ),
      ),
    );
  }
}

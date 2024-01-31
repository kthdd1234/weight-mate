// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/route/fade_page_route.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_carousel_slider_page.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class ImageCollectionsPage extends StatefulWidget {
  const ImageCollectionsPage({super.key});

  @override
  State<ImageCollectionsPage> createState() => _ImageCollectionsPageState();
}

class _ImageCollectionsPageState extends State<ImageCollectionsPage> {
  bool isRecent = true;
  List<Map<String, dynamic>> fileItemList = [];

  @override
  void initState() {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();
    List<Map<String, dynamic>> itemList = [];

    for (var i = 0; i < recordList.length; i++) {
      RecordBox record = recordList[i];
      List<Uint8List?> fileList = [
        record.leftFile,
        record.rightFile,
        record.bottomFile
      ];

      fileList.forEach((file) {
        if (file != null) {
          itemList.add({'dateTime': record.createDateTime, 'binaryData': file});
        }
      });
    }

    fileItemList = itemList.reversed.toList();

    AppLifecycleReactor(context: context).listenToAppStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onNavigatorPage({required int index, required bool isAutoPlay}) async {
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

    onTapFilter() {
      setState(() {
        isRecent = !isRecent;
        fileItemList = fileItemList.reversed.toList();
      });
    }

    onTapPictureClear() {
      //
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
          elevation: 0.0,
          actions: [
            CommonTag(
              color: 'whiteIndigo',
              text: '사진 슬라이드로 보기',
              onTap: () => onNavigatorPage(index: 0, isAutoPlay: true),
            ),
            // SpaceWidth(width: tinySpace),
            // CommonTag(
            //   color: 'whitePink',
            //   text: '사진 정리하기',
            //   onTap: onTapPictureClear,
            // ),
            SpaceWidth(width: tinySpace),
            CommonTag(
              color: isRecent ? 'whiteBlue' : 'whiteRed',
              text: isRecent ? '최신순' : '과거순',
              onTap: onTapFilter,
            ),
            SpaceWidth(width: tinySpace),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                        Uint8List binaryData = item['binaryData'];
                        DateTime dateTime = item['dateTime'];

                        return InkWell(
                          onTap: () => onNavigatorPage(
                            index: index,
                            isAutoPlay: false,
                          ),
                          child: Stack(
                            children: [
                              DefaultImage(
                                unit8List: binaryData,
                                height: MediaQuery.of(context).size.height,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0) / 3,
                                  child: TextIcon(
                                    padding: 5,
                                    backgroundColor: themeColor,
                                    backgroundColorOpacity: 0.5,
                                    text: dateTimeFormatter(
                                      dateTime: dateTime,
                                      format: 'MM월 dd일',
                                    ),
                                    borderRadius: 5,
                                    textColor: typeBackgroundColor,
                                    fontSize: 10,
                                    onTap: () => onNavigatorPage(
                                      index: index,
                                      isAutoPlay: false,
                                    ),
                                  ),
                                ),
                              )
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

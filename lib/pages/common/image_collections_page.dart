import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/route/fade_page_route.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_carousel_slider_page.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';

class ImageCollectionsPage extends StatefulWidget {
  const ImageCollectionsPage({super.key});

  @override
  State<ImageCollectionsPage> createState() => _ImageCollectionsPageState();
}

class _ImageCollectionsPageState extends State<ImageCollectionsPage> {
  List<Map<String, dynamic>> fileItemList = [];

  @override
  void initState() {
    Box<RecordBox> recordBox = Hive.box<RecordBox>('recordBox');
    List<RecordBox> recordValueList = recordBox.values.toList();
    List<Map<String, dynamic>> itemList = [];

    for (var i = 0; i < recordValueList.length; i++) {
      RecordBox recordValue = recordValueList[i];

      if (recordValue.leftFile != null) {
        itemList.add({
          'dateTime': recordValue.createDateTime,
          'binaryData': recordValue.leftFile!
        });
      }

      if (recordValue.rightFile != null) {
        itemList.add({
          'dateTime': recordValue.createDateTime,
          'binaryData': recordValue.rightFile!
        });
      }
    }

    fileItemList = itemList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onNavigatorPage({required int index, required bool isAutoPlay}) async {
      if (fileItemList.isEmpty) {
        return showSnackBar(
          context: context,
          text: '사진 슬라이드가 없어요.',
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

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: buttonBackgroundColor,
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: () => onNavigatorPage(index: 0, isAutoPlay: true),
              child: const Text('사진 슬라이드로 보기'),
            )
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
                                data: binaryData,
                                height: 150,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: TextIcon(
                                    backgroundColor: buttonBackgroundColor,
                                    backgroundColorOpacity: 0.5,
                                    text: dateTimeFormatter(
                                        dateTime: dateTime, format: 'MM월 dd일'),
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

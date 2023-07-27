import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class ImageCarouselSliderPage extends StatefulWidget {
  ImageCarouselSliderPage({
    super.key,
    required this.fileItemList,
    required this.initPageIndex,
    required this.isAutoPlay,
  });

  List<Map<String, dynamic>> fileItemList;
  int initPageIndex;
  bool isAutoPlay;

  @override
  State<ImageCarouselSliderPage> createState() =>
      _ImageCarouselSliderPageState();
}

class _ImageCarouselSliderPageState extends State<ImageCarouselSliderPage> {
  int currentPageIndex = 0;
  bool isEnabled = false;

  @override
  void initState() {
    currentPageIndex = widget.initPageIndex;
    isEnabled = widget.isAutoPlay;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = widget.fileItemList
        .map((item) => Image.memory(item['binaryData']))
        .toList();

    onPageChanged(int index, _) {
      setState(() => currentPageIndex = index);
    }

    setAppBarTitle() {
      DateTime dateTime = widget.fileItemList[currentPageIndex]['dateTime'];
      return dateTimeFormatter(format: 'MM월 dd일', dateTime: dateTime);
    }

    onChanged(bool newValue) {
      setState(() => isEnabled = newValue);
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(setAppBarTitle()),
          leading: const CloseButton(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          foregroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => onChanged(!isEnabled),
              child: const Text(
                '자동 재생',
                style: TextStyle(color: enableBackgroundColor),
              ),
            ),
            CupertinoSwitch(
              activeColor: enableTextColor,
              value: isEnabled,
              onChanged: onChanged,
            )
          ],
        ),
        body: CarouselSlider(
          items: items,
          options: CarouselOptions(
            autoPlay: isEnabled,
            autoPlayInterval: const Duration(seconds: 3),
            initialPage: widget.initPageIndex,
            height: MediaQuery.of(context).size.height,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            onPageChanged: onPageChanged,
          ),
        ),
      ),
    );
  }
}


// Center(child: Image.memory(binaryData))

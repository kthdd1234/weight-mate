import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
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
  bool isAutoPlay = false;
  bool isWeight = true;

  @override
  void initState() {
    currentPageIndex = widget.initPageIndex;
    isAutoPlay = widget.isAutoPlay;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.fileItemList[currentPageIndex]['dateTime'];
    int recordKey = getDateTimeToInt(dateTime);
    RecordBox? record = recordRepository.recordBox.get(recordKey);
    UserBox? user = userRepository.user;
    String weight = '${record?.weight ?? '-'}${user.weightUnit}';

    List<Widget> items = widget.fileItemList
        .map(
          (item) => Center(
            child: Stack(
              children: [
                Image.memory(item['file']),
                isWeight
                    ? Positioned(
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextIcon(
                              padding: 5,
                              backgroundColor: textColor,
                              backgroundColorOpacity: 0.5,
                              text: weight,
                              borderRadius: 5,
                              textColor: typeBackgroundColor,
                              fontSize: 11,
                              onTap: () => null),
                        ),
                      )
                    : const EmptyArea()
              ],
            ),
          ),
        )
        .toList();

    onPageChanged(int index, _) {
      setState(() => currentPageIndex = index);
    }

    setAppBarTitle() {
      return md(locale: context.locale.toString(), dateTime: dateTime);
    }

    onChangedWeight(bool newValue) {
      setState(() => isWeight = newValue);
    }

    onChangedAutoPlay(bool newValue) {
      setState(() => isAutoPlay = newValue);
    }

    return CommonBackground(
      child: CommonScaffold(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        appBarInfo: AppBarInfoClass(
          title: setAppBarTitle(),
          titleColor: Colors.white,
          isBold: true,
          isCenter: false,
          actions: [
            Column(
              children: [
                CupertinoSwitch(
                  activeColor: enableTextColor,
                  value: isWeight,
                  onChanged: onChangedWeight,
                ),
                CommonText(
                  text: '체중 표시',
                  size: 10,
                  color: Colors.white,
                  isBold: true,
                )
              ],
            ),
            Column(
              children: [
                CupertinoSwitch(
                  activeColor: enableTextColor,
                  value: isAutoPlay,
                  onChanged: onChangedAutoPlay,
                ),
                CommonText(
                  text: '자동 재생',
                  size: 10,
                  color: Colors.white,
                  isBold: true,
                )
              ],
            ),
          ],
        ),
        body: CarouselSlider(
          items: items,
          options: CarouselOptions(
            autoPlay: isAutoPlay,
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

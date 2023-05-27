import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/wise_saying_item_widget.dart';

class TodayWiseSayingWidget extends StatefulWidget {
  TodayWiseSayingWidget({super.key, required this.recordSelectedDateTime});

  DateTime recordSelectedDateTime;

  @override
  State<TodayWiseSayingWidget> createState() => _TodayWiseSayingWidgetState();
}

class _TodayWiseSayingWidgetState extends State<TodayWiseSayingWidget> {
  late WiseSayingClass wiseSaying;
  bool isClose = false;

  @override
  void initState() {
    final randomIndex = Random().nextInt(todayOfWiseSayingList.length);
    final info = todayOfWiseSayingList[randomIndex];
    wiseSaying = info;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTapClose() {
      setState(() => isClose = !isClose);
    }

    return isClose
        ? const SizedBox.shrink()
        : ContentsBox(
            isBoxShadow: true,
            contentsWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularIcon(
                  widthAndHeight: 40,
                  borderRadius: 30,
                  icon: Icons.auto_awesome_outlined,
                  backgroundColor: dialogBackgroundColor,
                ),
                SpaceWidth(width: smallSpace + tinySpace),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentsTitleText(text: '오늘의 명언'),
                      SpaceHeight(height: smallSpace),
                      WiseSayingItemWidget(
                        wiseSaying: wiseSaying.wiseSaying,
                        name: wiseSaying.name,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: InkWell(
                    onTap: onTapClose,
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          );
  }
}

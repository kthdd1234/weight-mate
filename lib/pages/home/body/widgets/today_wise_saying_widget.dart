import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/wise_saying_animate_widget.dart';

class TodayWiseSayingWidget extends StatefulWidget {
  const TodayWiseSayingWidget({super.key});

  @override
  State<TodayWiseSayingWidget> createState() => _TodayWiseSayingWidgetState();
}

class _TodayWiseSayingWidgetState extends State<TodayWiseSayingWidget> {
  bool isClose = false;

  @override
  Widget build(BuildContext context) {
    onTap() {
      setState(() => isClose = true);
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
                      ContentsTitleText(text: '오늘의 다이어트 명언'),
                      SpaceHeight(height: smallSpace),
                      WiseSayingAnimateWidget()
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: InkWell(onTap: onTap, child: const Icon(Icons.close)),
                ),
              ],
            ),
          );
  }
}

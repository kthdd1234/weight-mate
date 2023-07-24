import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/route/fade_page_route.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_contents_box.dart';

import '../components/area/empty_area.dart';

class CalendarDiaryInfo extends StatelessWidget {
  CalendarDiaryInfo({
    super.key,
    this.whiteText,
    this.leftFile,
    this.rightFile,
    this.diaryDateTime,
  });

  String? whiteText;
  Uint8List? leftFile, rightFile;
  DateTime? diaryDateTime;

  @override
  Widget build(BuildContext context) {
    setRowWidgets(List<Widget> children) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      );
    }

    onTap(Uint8List binaryData) {
      Navigator.push(
        context,
        FadePageRoute(page: ImagePullSizePage(binaryData: binaryData)),
      );
    }

    return CalendarContentsBox(
      color: diaryColor,
      rowWidgetList: [
        setRowWidgets([
          ContentsTitleText(text: '눈바디 작성'),
          ColorDot(width: 10, height: 10, color: diaryColor),
        ]),
        SpaceHeight(height: smallSpace),
        setRowWidgets([
          leftFile != null
              ? Expanded(
                  child: InkWell(
                    onTap: () => onTap(leftFile!),
                    child: DefaultImage(data: leftFile!, height: 150),
                  ),
                )
              : const EmptyArea(),
          leftFile != null ? SpaceWidth(width: tinySpace) : const EmptyArea(),
          rightFile != null
              ? Expanded(
                  child: InkWell(
                    onTap: () => onTap(leftFile!),
                    child: DefaultImage(data: rightFile!, height: 150),
                  ),
                )
              : const EmptyArea(),
        ]),
        SpaceHeight(height: smallSpace),
        whiteText != null
            ? Row(children: [Expanded(child: Text(whiteText!))])
            : const EmptyArea(),
        SpaceHeight(height: regularSapce),
        setRowWidgets([
          const EmptyArea(),
          BodySmallText(text: '${timeToStringDetail(diaryDateTime)} 작성 완료'),
        ]),
      ],
    );
  }
}

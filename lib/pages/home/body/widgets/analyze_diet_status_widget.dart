import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/analyze_progress_item_widget.dart';

class AnalyzeDietStatusWidget extends StatelessWidget {
  const AnalyzeDietStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProgressStatusItemClass> progressStates = [
      ProgressStatusItemClass(
        id: 0,
        icon: Icons.calendar_month_rounded,
        title: '000과 함께한 날',
        sub: '90일차',
      ),
      ProgressStatusItemClass(
        id: 1,
        icon: Icons.access_time,
        title: '다이어트 남은 기간',
        sub: '77일 18시간 31분 4초',
      ),
      ProgressStatusItemClass(
        id: 2,
        icon: Icons.flag,
        title: '목표 체중까지',
        sub: '-11kg',
      ),
      ProgressStatusItemClass(
        id: 3,
        icon: Icons.auto_fix_high,
        title: '체중 기록 횟수',
        sub: '12회',
      ),
      ProgressStatusItemClass(
        id: 4,
        icon: Icons.fact_check_outlined,
        title: '계획 실천 횟수',
        sub: '31회',
      ),
      // {
      //   'icon': Icons.today,
      //   'title': '000과 함께한 날',
      //   'sub': "90일차",
      // },
      // {
      //   'icon': Icons.access_time,
      //   'title': '남은 다이어트 기간',
      //   'sub': "77일 18시간 31분 4초"
      // },
      // {
      //   'icon': Icons.flag,
      //   'title': '목표 체중까지',
      //   'sub': "-7kg",
      // },
      // {
      //   'icon': Icons.auto_fix_high,
      //   'title': '기록한 체중 횟수',
      //   'sub': "12회",
      // },
      // {
      //   'icon': Icons.checklist,
      //   'title': '실천한 계획 횟수',
      //   'sub': "31회",
      // }
    ];

    setProgressStatusItems() {
      return progressStates
          .map((item) => AnalyzeProgressItemWidget(
                icon: item.icon,
                title: item.title,
                sub: item.sub,
                isLastIndex: progressStates.length - 1 == item.id,
              ))
          .toList();
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(text: '진행 상태'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Column(
              children: setProgressStatusItems(),
            ),
          )
        ],
      ),
    );
  }
}

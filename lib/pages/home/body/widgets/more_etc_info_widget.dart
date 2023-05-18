import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';

class MoreEtcInfoWidget extends StatelessWidget {
  const MoreEtcInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    onTapArrow(MoreSeeItem id) {}

    List<MoreSeeItemClass> moreSeeEtcItems = [
      MoreSeeItemClass(
        index: 0,
        id: MoreSeeItem.appEval,
        icon: Icons.rate_review_outlined,
        title: '앱 평가',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 1,
        id: MoreSeeItem.appShare,
        icon: Icons.share,
        title: '앱 공유',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 2,
        id: MoreSeeItem.developerInp,
        icon: Icons.drafts_outlined,
        title: '개발자 문의',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 3,
        id: MoreSeeItem.appVersion,
        icon: Icons.error_outline,
        title: '앱 버전',
        value: '1.1',
        widgetType: MoreSeeWidgetTypes.none,
      ),
    ];

    List<MoreSeeItemWidget> widgetList = moreSeeEtcItems
        .map((item) => MoreSeeItemWidget(
              index: item.index,
              id: item.id,
              icon: item.icon,
              title: item.title,
              value: item.value,
              widgetType: item.widgetType,
              onTapArrow: item.onTapArrow,
            ))
        .toList();

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(text: '기타'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Column(children: widgetList),
          )
        ],
      ),
    );
  }
}

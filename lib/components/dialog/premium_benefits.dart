import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class PremiumBenefits extends StatelessWidget {
  const PremiumBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    onTap() {
      //
    }

    List<PremiumBenefitsClass> premiumBenefitsClassList = [
      PremiumBenefitsClass(
        svgName: 'premium-free',
        title: '평생 무료로 이용 할 수 있어요',
        subTitle: '커피 한잔의 가격으로 단 한번 결제!',
      ),
      PremiumBenefitsClass(
        svgName: 'premium-no-ads',
        title: '모든 화면에서 광고가 나오지 않아요',
        subTitle: '광고없이 쾌적하게 앱을 사용해보세요!',
      ),
      PremiumBenefitsClass(
        svgName: 'premium-category-detail',
        title: '좀 더 자세한 통계 기능을 제공해드려요',
        subTitle: '체중 통계표, 체중 분석표, 기록 모아보기, 실천 모아보기 등 ',
      ),
      PremiumBenefitsClass(
        svgName: 'premium-photos-four',
        title: '사진을 최대 4장까지 추가 할 수 있어요',
        subTitle: '보다 많은 식단, 운동, 눈바디 사진을 추가해보세요!',
      ),
    ];

    List<Widget> premiumBenefitsWidgetList = premiumBenefitsClassList
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Row(
              children: [
                CommonSvg(name: item.svgName, width: 45),
                SpaceWidth(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text: item.title, size: 14),
                    SpaceHeight(height: 3),
                    CommonText(
                      text: item.subTitle,
                      size: 11,
                      color: Colors.grey.shade400,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
        .toList();

    return ContentsBox(
      contentsWidget: Column(
        children: [
          Column(children: premiumBenefitsWidgetList),
          CommonText(
            text: '구매 복원하기',
            size: 12,
            isCenter: true,
            color: Colors.grey.shade400,
          ),
          SpaceHeight(height: 15),
          Row(
            children: [
              ExpandedButtonHori(
                borderRadius: 5,
                padding: const EdgeInsets.symmetric(vertical: 15),
                imgUrl: 'assets/images/t-15.png',
                text: '구매하기 (￦4,900)',
                onTap: onTap,
              )
            ],
          ),
        ],
      ),
    );
  }
}

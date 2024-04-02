import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class PremiumBenefits extends StatelessWidget {
  const PremiumBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    onPurchase() {
      //
    }

    onRestore() {
      //
    }

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
            onTap: onRestore,
          ),
          SpaceHeight(height: 15),
          Row(
            children: [
              ExpandedButtonHori(
                borderRadius: 5,
                padding: const EdgeInsets.symmetric(vertical: 15),
                imgUrl: 'assets/images/t-15.png',
                text: '구매하기 (￦4,900)',
                onTap: onPurchase,
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:provider/provider.dart';

class CommonBlur extends StatelessWidget {
  CommonBlur({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPremium = context.watch<PremiumProvider>().premiumValue();

    onPremium() {
      Navigator.pushNamed(context, '/premium-page');
    }

    return isPremium == false
        ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonSvg(name: 'crown', width: 40),
                SpaceHeight(height: 15),
                CommonText(
                  text: 'Premium',
                  size: 18,
                  isBold: true,
                  isCenter: true,
                ),
                SpaceHeight(height: 5),
                CommonText(
                  text: '프리미엄을 구매한 분들에게만 제공되는 기능이에요.',
                  size: 15,
                  isCenter: true,
                ),
                SpaceHeight(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ExpandedButtonHori(
                        borderRadius: 30,
                        imgUrl: 'assets/images/t-23.png',
                        text: '프리미엄 구매 페이지로 이동',
                        onTap: onPremium,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : const EmptyArea();
  }
}

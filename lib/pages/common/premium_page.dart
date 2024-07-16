// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  Package? package;

  @override
  void initState() {
    initIAP() async {
      try {
        Offerings offerings = await Purchases.getOfferings();

        List<Package>? availablePackages =
            offerings.getOffering(entitlement_identifier)?.availablePackages;

        if (availablePackages != null && availablePackages.isNotEmpty) {
          setState(() => package = availablePackages[0]);
        }
      } on PlatformException catch (e) {
        log('PlatformException =>> $e');
      }
    }

    initIAP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPremium = context.watch<PremiumProvider>().isPremium;

    onPurchase() async {
      if (package != null) {
        try {
          showDialog(
            context: context,
            builder: (context) => LoadingDialog(
              text: '데이터 불러오는 중...',
              color: Colors.white,
            ),
          );

          bool isPurchaseResult = await setPurchasePremium(package!);
          context.read<PremiumProvider>().setPremiumValue(isPurchaseResult);
        } on PlatformException catch (e) {
          log('e =>> ${e.toString()}');
          PurchasesErrorCode errorCode = PurchasesErrorHelper.getErrorCode(e);

          if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
            log('errorCode =>> $errorCode');
          }
        } finally {
          closeDialog(context);
        }
      }
    }

    onRestore() async {
      bool isRestorePremium = await isPurchaseRestore();
      context.read<PremiumProvider>().setPremiumValue(isRestorePremium);
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
                        text: item.subTitle, size: 11, color: grey.original),
                  ],
                )
              ],
            ),
          ),
        )
        .toList();

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '프리미엄'.tr(),
            style: const TextStyle(fontSize: 20, color: textColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                ContentsBox(
                  contentsWidget: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CommonText(text: '프리미엄 혜택', size: 14, isBold: true),
                          CommonText(
                            text: '구매 내역 가져오기',
                            size: 12,
                            color: grey.original,
                            onTap: onRestore,
                          ),
                        ],
                      ),
                      SpaceHeight(height: 15),
                      Column(children: premiumBenefitsWidgetList),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isPremium
                              ? Row(
                                  children: [
                                    CommonSvg(name: 'premium-badge', width: 16),
                                    SpaceWidth(width: 5),
                                    CommonText(text: '구매가 완료되었어요 :D', size: 14),
                                  ],
                                )
                              : ExpandedButtonHori(
                                  borderRadius: 5,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  imgUrl: 'assets/images/t-23.png',
                                  text: '구매하기',
                                  nameArgs: {
                                    "price":
                                        package?.storeProduct.priceString ??
                                            '없음'
                                  },
                                  onTap: onPurchase,
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

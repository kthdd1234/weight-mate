import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

        log('뭐고 =>> $availablePackages');

        if (availablePackages != null && availablePackages.isNotEmpty) {
          setState(() => package = availablePackages[0]);
        }
      } on PlatformException catch (e) {
        log('PlatformException =>> $e');
      }
    }

    initCustomer() async {
      try {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        log('customerInfo =>> ${customerInfo.originalAppUserId}');
      } on PlatformException catch (e) {
        log('PlatformException =>> $e');
      }
    }

    initIAP();
    initCustomer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    Map<String, dynamic>? customerInfoJson = user.customerInfoJson;

    // todo

    onPurchase() async {
      try {
        if (package != null) {
          CustomerInfo customerInfo = await Purchases.purchasePackage(package!);
          bool isActive =
              customerInfo.entitlements.all[entitlement_identifier]?.isActive ==
                  true;

          if (isActive) {
            log('isActive!! => ${customerInfo.toJson()}');

            user.customerInfoJson = customerInfo.toJson();
            await user.save();
          }
        }
      } on PlatformException catch (e) {
        log('e =>> ${e.toString()}');

        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          log('errorCode =>> $errorCode');
        }
      }
    }

    onRestore() async {
      try {
        CustomerInfo customerInfo = await Purchases.restorePurchases();
        Map<String, dynamic> customerInfoJson = customerInfo.toJson();
        user.customerInfoJson = customerInfoJson;

        log('onRestore!! customerInfo.toJson => ${customerInfo.toJson()}');

        await user.save();
      } on PlatformException catch (e) {
        log('e =>> ${e.toString()}');
      }
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

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '프리미엄'.tr(),
            style: const TextStyle(fontSize: 20, color: themeColor),
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
                          CommonText(text: '프리미엄 혜택', size: 15),
                          CommonText(
                            text: '구매 복원하기',
                            size: 12,
                            color: Colors.grey.shade400,
                            onTap: onRestore,
                          ),
                        ],
                      ),
                      SpaceHeight(height: 15),
                      Column(children: premiumBenefitsWidgetList),
                      Row(
                        children: [
                          ExpandedButtonHori(
                            borderRadius: 5,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            imgUrl: 'assets/images/t-15.png',
                            text:
                                '구매하기 (${package?.storeProduct.priceString ?? 'none'})',
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

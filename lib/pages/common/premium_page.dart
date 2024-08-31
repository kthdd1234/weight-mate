// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/popup/LoadingPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
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
            builder: (context) => LoadingPopup(
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
            padding: const EdgeInsets.only(bottom: 10),
            child: ContentsBox(
              contentsWidget: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: item.title, size: 14),
                          SpaceHeight(height: 5),
                          CommonText(
                            text: item.subTitle,
                            size: 11.5,
                            color: grey.original,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpaceWidth(width: 20),
                  CommonSvg(name: item.svgName, width: 45),
                ],
              ),
            ),
          ),
        )
        .toList();

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(
          title: '프리미엄 혜택',
          isCenter: false,
          actions: [PremiumRestoreButton(onRestore: onRestore)],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: premiumBenefitsWidgetList),
              ),
            ),
            PremiumPurchaseButton(
              isPremium: isPremium,
              package: package,
              onPurchase: onPurchase,
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumPurchaseButton extends StatelessWidget {
  PremiumPurchaseButton({
    super.key,
    required this.isPremium,
    required this.package,
    required this.onPurchase,
  });

  final bool isPremium;
  final Package? package;
  final Function() onPurchase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  imgUrl: 'assets/images/t-4.png',
                  text: '구매하기',
                  nameArgs: {
                    "price": package?.storeProduct.priceString ?? '없음'
                  },
                  onTap: onPurchase,
                )
        ],
      ),
    );
  }
}

class PremiumRestoreButton extends StatelessWidget {
  PremiumRestoreButton({super.key, required this.onRestore});

  Function() onRestore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: CommonTag(
        text: '구매 항목 복원',
        color: 'whiteIndigo',
        onTap: onRestore,
      ),
    );
  }
}

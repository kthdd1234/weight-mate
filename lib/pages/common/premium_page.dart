import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/services/auth_service.dart';
import 'package:flutter_app_weight_management/services/iap_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
// import 'package:app_store_server_sdk/app_store_server_sdk.dart';

List<String> _productIds = <String>["premium_wm"];

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;
  ProductDetails? _productDetail;
  late StreamSubscription<List<PurchaseDetails>> _iapSubscription;

  @override
  void initState() {
    initStoreInfo();
    initPurchaseUpdated();

    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() => _isAvailable = isAvailable);

    if (!_isAvailable) {
      setState(() => _notice = "There are no upgrades at this time");
      return;
    }

    setState(() {
      _notice = "There is a connection to the store";
    });

    // get IAP
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_productIds.toSet());

    if (productDetailsResponse.error != null) {
      setState(() {
        _notice = "There was a problem connecting to the store";
      });
    } else if (productDetailsResponse.productDetails.isEmpty) {
      setState(() {
        _notice = "There are no upgrades at this time";
      });
    }

    setState(() {
      for (var product in productDetailsResponse.productDetails) {
        if (product.id == 'premium_wm') _productDetail = product;
      }
    });
  }

  initPurchaseUpdated() {
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _iapSubscription = purchaseUpdated.listen((purchaseDetailsList) {
      print('Purchase stream started');
      IAPService(context.read<AuthService>().currentUser!.uid)
          .listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _iapSubscription.cancel();
    }, onError: (e) {
      _iapSubscription.cancel();
    }) as StreamSubscription<List<PurchaseDetails>>;
  }

  @override
  Widget build(BuildContext context) {
    onPurchase() async {
      if (_productDetail != null) {
        PurchaseParam purchaseParam = PurchaseParam(
          productDetails: _productDetail!,
        );

        await InAppPurchase.instance.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      }
    }

    onRestore() async {
      print('_productDetail =>>');
      await InAppPurchase.instance.restorePurchases();
    }

    log('_notice => $_notice');

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
                            text: '구매하기 (${_productDetail?.price})',
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

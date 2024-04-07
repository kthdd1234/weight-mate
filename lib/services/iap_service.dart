import 'dart:developer';

import 'package:app_store_server_sdk/app_store_server_sdk.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  String uid;
  IAPService(this.uid);

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _handleSuccessfulPurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        print(purchaseDetails.error!);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print('Purchase marked complete');
      }
    });
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'premium_wm') {
      //
    }
    // log('productID =>> ${purchaseDetails.productID}');
    // log('purchaseID =>> ${purchaseDetails.purchaseID}');
    // log('status =>> ${purchaseDetails.status}');
    // log('pendingCompletePurchase =>> ${purchaseDetails.pendingCompletePurchase}');
    // log('transactionDate =>> ${purchaseDetails.transactionDate}');
    // log('localVerificationData =>> ${purchaseDetails.verificationData.localVerificationData}');
    // log('serverVerificationData =>> ${purchaseDetails.verificationData.serverVerificationData}');
    // log('localVerificationData == serverVerificationData =>> ${purchaseDetails.verificationData.localVerificationData == purchaseDetails.verificationData.serverVerificationData}');
  }
}

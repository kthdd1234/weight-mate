import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  IAPService();

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print('purchaseDetails.status ${purchaseDetails.status}');

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);

        if (valid) {
          log('앱 스토어 결제 인증 완료!');
        }
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

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    String verificationData =
        purchaseDetails.verificationData.serverVerificationData;

    log('verificationData => $verificationData');

    print('Verifying Purchase start');
    try {
      final verifier = FirebaseFunctions.instanceFor(region: 'asia-northeast3')
          .httpsCallable('verifyPurchase');
      final results = await verifier({
        'source': purchaseDetails.verificationData.source,
        'verificationData': verificationData,
      });

      print('Called verify purchase with following result $results');
      return results.data as bool;
    } on FirebaseFunctionsException catch (e) {
      print(e.code);
      print(e.details);
      print(e.message);
      return false;
    }
  }
}

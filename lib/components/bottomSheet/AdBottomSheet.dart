// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/common/CommonModalSheet.dart';
// import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
// import 'package:flutter_app_weight_management/etc/add_plan_list.dart';
// import 'package:flutter_app_weight_management/pages/common/premium_page.dart';
// import 'package:flutter_app_weight_management/provider/ads_provider.dart';
// import 'package:flutter_app_weight_management/services/ads_service.dart';
// import 'package:flutter_app_weight_management/utils/function.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';

// class AdBottomSheet extends StatefulWidget {
//   AdBottomSheet({super.key, required this.category});

//   String category;

//   @override
//   State<AdBottomSheet> createState() => _AdBottomSheetState();
// }

// class _AdBottomSheetState extends State<AdBottomSheet> {
//   NativeAd? nativeAd;
//   bool isLoaded = false;

//   @override
//   void didChangeDependencies() {
//     AdsService adsState = Provider.of<AdsProvider>(context).adsState;

//     nativeAd = loadNativeAd(
//       adUnitId: adsState.nativeAdUnitId,
//       onAdLoaded: () {
//         setState(() => isLoaded = true);
//       },
//       onAdFailedToLoad: () {
//         setState(() {
//           isLoaded = false;
//           nativeAd = null;
//         });
//       },
//     );

//     super.didChangeDependencies();
//   }

//   onPremium() {
//     closeDialog(context);
//     navigator(context: context, page: const PremiumPage());
//   }

//   onClose() {
//     closeDialog(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CommonModalSheet(
//       title: '👏🏻기록을 완료했어요!',
//       nameArgs: {'category': widget.category.tr()},
//       height: 460,
//       isClose: true,
//       child: Column(
//         children: [
//           Expanded(
//             child: ContentsBox(
//               padding: EdgeInsets.all(0),
//               width: double.infinity,
//               contentsWidget: isLoaded == false
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                       strokeWidth: 3,
//                     ))
//                   : AdWidget(ad: nativeAd!),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

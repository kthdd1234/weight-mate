// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/common/CommonModalSheet.dart';
// import 'package:flutter_app_weight_management/common/CommonName.dart';
// import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
// import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
// import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
// import 'package:flutter_app_weight_management/components/popup/LoadingPopup.dart';
// import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
// import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
// import 'package:flutter_app_weight_management/main.dart';
// import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
// import 'package:flutter_app_weight_management/provider/ads_provider.dart';
// import 'package:flutter_app_weight_management/services/ads_service.dart';
// import 'package:flutter_app_weight_management/utils/function.dart';
// import 'package:flutter_app_weight_management/utils/variable.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';

// class AdBottomSheet extends StatefulWidget {
//   AdBottomSheet({super.key, required this.onChanged});

//   Function() onChanged;

//   @override
//   State<AdBottomSheet> createState() => _AdBottomSheetState();
// }

// class _AdBottomSheetState extends State<AdBottomSheet> {
//   onClose() {
//     closeDialog(context);
//   }

//   wText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 2),
//       child: CommonName(text: text, fontSize: 13),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     AdsService adsState = Provider.of<AdsProvider>(context).adsState;
//     String path = 'assets/images/';

//     onAd() async {
//       try {
//         showDialog(
//           context: context,
//           builder: (context) => LoadingPopup(
//             text: '',
//             color: indigo.s400,
//           ),
//         );

//         await RewardedInterstitialAd.load(
//           adUnitId: adsState.rewardedInterstitialAdUnitId,
//           request: const AdRequest(),
//           rewardedInterstitialAdLoadCallback:
//               RewardedInterstitialAdLoadCallback(
//             onAdLoaded: (loadedAd) async {
//               await loadedAd.show(
//                 onUserEarnedReward: (
//                   AdWithoutView ad,
//                   RewardItem rewardItem,
//                 ) async {
//                   UserBox user = userRepository.user;

//                   widget.onChanged();
//                   user.watchingAdDatetTime = DateTime.now();

//                   await user.save();
//                 },
//               );
//             },
//             onAdFailedToLoad: (err) async {
//               log('$err ㅠㅠ');

//               await showDialog(
//                 context: context,
//                 builder: (context) => AlertPopup(
//                   height: 185,
//                   text1: '광고 불러오기를 실패했어요',
//                   text2: '(${err.message})',
//                   buttonText: '확인',
//                   onTap: () => closeDialog(context),
//                 ),
//               );
//             },
//           ),
//         );
//       } finally {
//         closeDialog(context);
//       }
//     }

//     return CommonModalSheet(
//       title: '전면 광고 안내',
//       height: 285,
//       child: Column(
//         children: [
//           Expanded(
//             child: ContentsBox(
//               width: double.infinity,
//               contentsWidget: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     wText('체중 메이트 앱의 지속적인 발전과 지원을 위해'),
//                     wText('기간 변경 시 전면 광고가 노출됩니다.'),
//                     wText('이점 이해해주시면 감사하겠습니다.'),
//                     wText('(광고 시청 시 24시간 동안 광고 노출x)'),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SpaceHeight(height: 10),
//           Row(
//             children: [
//               ExpandedButtonHori(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 imgUrl: '$path/t-3.png',
//                 text: '닫기',
//                 onTap: () => closeDialog(context),
//               ),
//               SpaceWidth(width: 10),
//               ExpandedButtonHori(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 text: '짧은 광고 보기',
//                 textColor: Colors.white,
//                 imgUrl: '$path/t-4.png',
//                 onTap: () {
//                   closeDialog(context);
//                   onAd();
//                 },
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

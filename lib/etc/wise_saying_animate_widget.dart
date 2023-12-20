// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/utils/variable.dart';
// import 'package:flutter_app_weight_management/widgets/wise_saying_item_widget.dart';

// class WiseSayingAnimateWidget extends StatefulWidget {
//   const WiseSayingAnimateWidget({super.key});

//   @override
//   State<WiseSayingAnimateWidget> createState() =>
//       _WiseSayingAnimateWidgetState();
// }

// class _WiseSayingAnimateWidgetState extends State<WiseSayingAnimateWidget> {
//   late Widget randomWidget;
//   List<WiseSayingItemWidget> fadeInDownList = todayOfWiseSayingList
//       .map((data) =>
//           WiseSayingItemWidget(wiseSaying: data.wiseSaying, name: data.name))
//       .toList();

//   callback(_) {
//     Random rnd = Random();
//     Widget widget = fadeInDownList[rnd.nextInt(fadeInDownList.length)];

//     setState(() => randomWidget = widget);
//   }

//   @override
//   void initState() {
//     randomWidget = fadeInDownList[0];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WiseSayingItemWidget(
//       wiseSaying: todayOfWiseSayingList[0].wiseSaying,
//       name: todayOfWiseSayingList[0].name,
//     );
//   }
// }
// // WiseSayingItemWidget(wiseSaying: data.wiseSaying, name: data.name))
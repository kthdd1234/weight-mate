// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
// import 'package:flutter_app_weight_management/components/text/popup_menu_item_text.dart';
// import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
// import 'package:flutter_app_weight_management/provider/popup_menu_item_provider.dart';
// import 'package:flutter_app_weight_management/utils/enum.dart';
// import 'package:provider/provider.dart';

// class PopupMenuButtonWidget extends StatefulWidget {
//   PopupMenuButtonWidget({super.key, required this.id});

//   String id;

//   @override
//   State<PopupMenuButtonWidget> createState() => _PopupMenuButtonWidgetState();
// }

// class _PopupMenuButtonWidgetState extends State<PopupMenuButtonWidget> {
//   @override
//   Widget build(BuildContext context) {
//     showConfirmDialog(ePopupMenuItem enumId) {
//       if (ePopupMenuItem.resetDietPlan == enumId) {
//         resetDietPlan() =>
//             context.read<DietInfoProvider>().changeDietPlanList([]);

//         showDialog(
//           context: context,
//           builder: (context) => ConfirmDialog(
//             titleText: '계획 초기화',
//             contentIcon: Icons.replay_rounded,
//             contentText1: '오늘의 다이어트 계획을',
//             contentText2: '초기화하시겠습니까?',
//             onPressedOk: resetDietPlan,
//           ),
//         );
//       }
//     }

//     onTapPopupMenuItem(ePopupMenuItem enumId) async {
//       context.read<PopupMenuItemProvider>().setSeletedPopupMenuItem(enumId);

//       if ([ePopupMenuItem.resetDietPlan, ePopupMenuItem.deleteNote]
//           .contains(enumId)) {
//         await Future.delayed(const Duration(seconds: 0));
//         showConfirmDialog(enumId);
//       }
//     }

//     onTapDownPopupMenuButton({
//       required TapDownDetails details,
//       required String id,
//     }) async {
//       Offset offset = details.globalPosition;
//       double left = offset.dx;
//       double top = offset.dy;

//       List<PopupMenuItem> todayOfWeightPopupMenuItemList = [
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.weightReRecood.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.weightReRecood),
//           child: PopupMenuItemText(
//             icon: Icons.monitor_weight_rounded,
//             text: '현재 체중 변경',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.goalWeightChange.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.goalWeightChange),
//           child: PopupMenuItemText(
//             icon: Icons.flag_rounded,
//             text: '목표 체중 변경',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.enterBodyFatPercentage.toString(),
//           onTap: () =>
//               onTapPopupMenuItem(ePopupMenuItem.enterBodyFatPercentage),
//           child: PopupMenuItemText(
//             icon: Icons.align_vertical_bottom,
//             text: '체지방률 입력',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.tallChange.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.tallChange),
//           child: PopupMenuItemText(
//             icon: Icons.accessibility_new_rounded,
//             text: '키 변경',
//           ),
//         ),
//       ];

//       List<PopupMenuItem> todayOfDietPlanPopupMenuItemList = [
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.actDietPlan.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.actDietPlan),
//           child: PopupMenuItemText(
//             icon: Icons.check,
//             text: '계획 체크 ',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.addDietPlan.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.addDietPlan),
//           child: PopupMenuItemText(
//             icon: Icons.add,
//             text: '계획 추가',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.removeDietPlan.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.removeDietPlan),
//           child: PopupMenuItemText(
//             icon: Icons.delete,
//             text: '계획 삭제',
//           ),
//         ),
//       ];
//       List<PopupMenuItem> todayOfMemoPopupMenuItemList = [
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.editNote.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.editNote),
//           child: PopupMenuItemText(
//             icon: Icons.edit_rounded,
//             text: '메모 편집',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.editNote.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.deleteNote),
//           child: PopupMenuItemText(
//             icon: Icons.delete,
//             text: '메모 삭제',
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: ePopupMenuItem.addEyeBody.toString(),
//           onTap: () => onTapPopupMenuItem(ePopupMenuItem.addEyeBody),
//           child: PopupMenuItemText(
//             icon: Icons.photo,
//             text: '눈바디 추가',
//           ),
//         ),
//       ];

//       var mapPopupMenuItems = {
//         'tw': todayOfWeightPopupMenuItemList,
//         'td': todayOfDietPlanPopupMenuItemList,
//         'tm': todayOfMemoPopupMenuItemList
//       };

//       var popupMenuItems = mapPopupMenuItems[id];

//       await showMenu(
//         context: context,
//         position: RelativeRect.fromLTRB(left, top, 0, 0),
//         items: popupMenuItems!,
//       );
//     }

//     return Row(
//       children: [],
//     );
//   }
// }

// // InkWell(
// //       onTapDown: (TapDownDetails details) =>
// //           onTapDownPopupMenuButton(details: details, id: widget.id),
// //       child: const Icon(Icons.more_vert, size: 22),
// //     )

// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
// import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
// import 'package:flutter_app_weight_management/components/check/plan_contents.dart';
// import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
// import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
// import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
// import 'package:flutter_app_weight_management/utils/constants.dart';
// import 'package:flutter_app_weight_management/utils/function.dart';
// import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';

// class PlanCheckClass {
//   PlanCheckClass({
//     required this.id,
//     required this.text,
//     required this.isChecked,
//     required this.priority,
//     this.alarmTime,
//     required this.createDateTime,
//   });

//   String id, text;
//   bool isChecked;
//   String priority;
//   DateTime createDateTime;
//   DateTime? alarmTime;
// }

// class BeforePlanListDialog extends StatefulWidget {
//   BeforePlanListDialog({
//     super.key,
//     required this.title,
//     required this.planList,
//     required this.onPressedOk,
//     required this.emptyIcon,
//   });

//   String title;
//   List<PlanBox> planList;
//   IconData emptyIcon;
//   Function(List<String> idList) onPressedOk;

//   @override
//   State<BeforePlanListDialog> createState() => _BeforePlanListDialogState();
// }

// class _BeforePlanListDialogState extends State<BeforePlanListDialog> {
//   List<String> checkedIdList = [];

//   @override
//   Widget build(BuildContext context) {
//     onTap({required String id, required bool isSelected}) {
//       setState(() {
//         isSelected ? checkedIdList.add(id) : checkedIdList.remove(id);
//       });
//     }

//     setListView() {
//       List<PlanCheckClass> planCheckClassList = widget.planList
//           .map((e) => PlanCheckClass(
//                 id: e.id,
//                 isChecked: checkedIdList.contains(e.id),
//                 priority: e.priority,
//                 text: e.name,
//                 createDateTime: e.createDateTime,
//                 alarmTime: e.alarmTime,
//               ))
//           .toList();

//       return Scrollbar(
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: widget.planList.length,
//           itemBuilder: (context, index) {
//             PlanCheckClass item = planCheckClassList[index];

//             return PlanContents(
//               id: item.id,
//               text: item.text,
//               type: 'diet',
//               checkIcon: Icons.check_box_outlined,
//               notCheckIcon: Icons.check_box_outline_blank,
//               isChecked: item.isChecked,
//               notCheckColor: buttonBackgroundColor,
//               alarmTime: item.alarmTime,
//               createDateTime: item.createDateTime,
//               onTapCheck: onTap,
//               onTapContents: (_) {},
//             );
//           },
//         ),
//       );
//     }

//     return AlertDialog(
//       shape: containerBorderRadious,
//       backgroundColor: dialogBackgroundColor,
//       elevation: 0.0,
//       title: AlertDialogTitleWidget(
//         text: '이전의 ${widget.title} 계획',
//         onTap: () => closeDialog(context),
//       ),
//       content: SizedBox(
//         height: 340,
//         child: Column(
//           children: [
//             ContentsBox(
//               width: double.maxFinite,
//               height: 270,
//               contentsWidget: widget.planList.isNotEmpty
//                   ? setListView()
//                   : EmptyTextVerticalArea(
//                       backgroundColor: Colors.transparent,
//                       icon: widget.emptyIcon,
//                       title: '이전의 ${widget.title} 계획이 없어요.',
//                     ),
//             ),
//             SpaceHeight(height: regularSapce),
//             OkAndCancelButton(
//               okText: '가져오기 ${checkedIdList.length}',
//               cancelText: '닫기',
//               onPressedOk: checkedIdList.isNotEmpty
//                   ? () => widget.onPressedOk(checkedIdList)
//                   : null,
//               onPressedCancel: () => closeDialog(context),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

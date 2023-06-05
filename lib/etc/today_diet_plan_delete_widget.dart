// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
// import 'package:flutter_app_weight_management/components/check/delete_diet_plan_check.dart';
// import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
// import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
// import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
// import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
// import 'package:flutter_app_weight_management/utils/class.dart';
// import 'package:flutter_app_weight_management/utils/constants.dart';
// import 'package:flutter_app_weight_management/utils/enum.dart';
// import 'package:provider/provider.dart';

// class TodayDietPlanDeleteWdiget extends StatefulWidget {
//   TodayDietPlanDeleteWdiget({
//     super.key,
//     required this.dietPlanList,
//   });

//   List<DietPlanClass> dietPlanList;

//   @override
//   State<TodayDietPlanDeleteWdiget> createState() =>
//       _TodayDietPlanDeleteWdigetState();
// }

// class _TodayDietPlanDeleteWdigetState extends State<TodayDietPlanDeleteWdiget> {
//   List<String> deleteIds = [];

//   @override
//   void dispose() {
//     deleteIds = [];
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     setDeleteIds({id, isSelected}) {
//       setState(() {
//         !isSelected ? deleteIds.add(id) : deleteIds.remove(id);
//       });
//     }

//     setOkText() {
//       return deleteIds.isNotEmpty ? '(${deleteIds.length})' : '';
//     }

//     onPressedOk() {
//       var filterList = widget.dietPlanList
//           .where((DietPlanClass dietPlan) =>
//               deleteIds.contains(dietPlan.id) == false)
//           .toList();
//       // context.read<DietInfoProvider>().changeDietPlanList(filterList);
//       context
//           .read<RecordIconTypeProvider>()
//           .setSeletedRecordIconType(RecordIconTypes.none);
//     }

//     onPressedCancel() {
//       context
//           .read<RecordIconTypeProvider>()
//           .setSeletedRecordIconType(RecordIconTypes.none);
//     }

//     List<DeleteDietPlanCheck> todayDietPlanList = widget.dietPlanList
//         .map((DietPlanClass dietPlan) => DeleteDietPlanCheck(
//               id: dietPlan.id,
//               text: dietPlan.plan,
//               onTap: setDeleteIds,
//             ))
//         .toList();

//     return Column(children: [
//       ...todayDietPlanList,
//       WidthDivider(width: double.infinity),
//       SpaceHeight(height: smallSpace),
//       OkAndCancelButton(
//         okText: '삭제 ${setOkText()}',
//         cancelText: '취소',
//         onPressedOk: deleteIds.isNotEmpty ? onPressedOk : null,
//         onPressedCancel: onPressedCancel,
//       )
//     ]);
//   }
// }

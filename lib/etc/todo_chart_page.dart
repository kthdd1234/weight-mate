// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/common/CommonBackground.dart';
// import 'package:flutter_app_weight_management/common/CommonBlur.dart';
// import 'package:flutter_app_weight_management/common/CommonIcon.dart';
// import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
// import 'package:flutter_app_weight_management/common/CommonText.dart';
// import 'package:flutter_app_weight_management/components/area/empty_area.dart';
// import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
// import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
// import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
// import 'package:flutter_app_weight_management/main.dart';
// import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
// import 'package:flutter_app_weight_management/utils/class.dart';
// import 'package:flutter_app_weight_management/utils/function.dart';
// import 'package:flutter_app_weight_management/utils/variable.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import '../../utils/constants.dart';

// class TodoChartPage extends StatefulWidget {
//   const TodoChartPage({super.key});

//   @override
//   State<TodoChartPage> createState() => _TodoChartPageState();
// }

// class _TodoChartPageState extends State<TodoChartPage> {
//   DateTime selectedMonth = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     Map<String, String> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//     String type = args['type']!;
//     String title = args['title']!;
//     int selectedMonthKey = mToInt(selectedMonth);
//     List<RecordBox?> recordList = recordRepository.recordBox.values.toList();

//     isDisplayRecord(RecordBox? record) {
//       bool isSelectedMonth =
//           (mToInt(record?.createDateTime) == selectedMonthKey);
//       bool? isRecordAction = record?.actions?.any(
//         (item) => item['isRecord'] == true && item['type'] == type,
//       );

//       return isSelectedMonth && isRecordAction == true;
//     }

//     onTapMonthTitle() {
//       onShowDateTimeDialog(
//         context: context,
//         view: DateRangePickerView.year,
//         initialSelectedDate: selectedMonth,
//         onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//           setState(() => selectedMonth = args.value);
//           closeDialog(context);
//         },
//       );
//     }

//     List<RecordBox?> displayRecordList = recordList
//         .where((record) => isDisplayRecord(record))
//         .toList()
//         .reversed
//         .toList();

//     return CommonBackground(
//       child: CommonScaffold(
//         appBarInfo: AppBarInfoClass(title: '$title 모아보기'),
//         body: Stack(
//           children: [
//             ContentsBox(
//               contentsWidget: Column(
//                 children: [
//                   RowTitle(
//                     type: type,
//                     selectedMonth: selectedMonth,
//                     onTap: onTapMonthTitle,
//                   ),
//                   Divider(color: Colors.grey.shade200),
//                   displayRecordList.isNotEmpty
//                       ? Expanded(
//                           child: ListView(
//                             children: displayRecordList
//                                 .map((record) => ColumnContainer(
//                                       recordInfo: record,
//                                       dateTime: record!.createDateTime,
//                                       type: type,
//                                       actions: record.actions,
//                                     ))
//                                 .toList(),
//                           ),
//                         )
//                       : Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CommonIcon(
//                                 icon: todoData[type]!.icon,
//                                 size: 20,
//                                 color: grey.original,
//                               ),
//                               SpaceHeight(height: 10),
//                               CommonText(
//                                 text: '기록이 없어요.',
//                                 size: 15,
//                                 isCenter: true,
//                                 color: grey.original,
//                               ),
//                               SpaceHeight(height: 20),
//                             ],
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//             CommonBlur(),
//           ],
//         ),
//       ),
//     );
//   }
// }

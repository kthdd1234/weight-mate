// import 'package:flutter/material.dart';
// import 'package:flutter_app_weight_management/components/dialog/calendar_month_dialog.dart';
// import 'package:flutter_app_weight_management/utils/constants.dart';
// import 'package:flutter_app_weight_management/utils/function.dart';

// class AppBarCalendarMonthWidget extends StatefulWidget {
//   const AppBarCalendarMonthWidget({super.key});

//   @override
//   State<AppBarCalendarMonthWidget> createState() =>
//       _AppBarCalendarMonthWidgetState();
// }

// class _AppBarCalendarMonthWidgetState extends State<AppBarCalendarMonthWidget> {
//   String dateTimeToStr = '';
//   String yearAndMonth = '';

//   @override
//   void initState() {
//     dateTimeToStr = getDateTimeToStr(DateTime.now());
//     yearAndMonth = getDateTimeToMonthStr(DateTime.now());

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     onSubmit(DateTime dateTime) {
//       setState(() {
//         dateTimeToStr = getDateTimeToStr(dateTime);
//         yearAndMonth = getDateTimeToMonthStr(dateTime);
//       });
//       closeDialog(context);
//     }

//     onCancel() {
//       closeDialog(context);
//     }

//     onTap() {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return CalendarMonthDialog(
//               initDate: dateTimeToStr,
//               onSubmit: onSubmit,
//               onCancel: onCancel,
//             );
//           });
//     }

//     return AppBarTextWidget(
//       dateTimeToStr: yearAndMonth,
//       onTap: onTap,
//       actionIcons: Row(
//         children: [
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.swap_vert, color: buttonBackgroundColor))
//         ],
//       ),
//     );
//   }
// }

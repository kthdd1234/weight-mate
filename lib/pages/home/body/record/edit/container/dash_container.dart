import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';

class DashContainer extends StatelessWidget {
  DashContainer({
    super.key,
    required this.height,
    required this.text,
    required this.borderType,
    required this.radius,
    required this.onTap,
    this.adjustHeight,
  });

  double height, radius;
  String text;
  BorderType borderType;
  Function() onTap;
  double? adjustHeight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: height - (adjustHeight ?? 0),
        child: GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            color: Colors.grey,
            dashPattern: const [2, 5],
            borderType: borderType,
            radius: Radius.circular(radius),
            child: SizedBox(
              height: height,
              child: CommonText(
                text: text,
                color: Colors.grey,
                size: 13,
                isCenter: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// Expanded(
//       child: Container(
//         height: height - (adjustHeight ?? 0),
//         decoration: BoxDecoration(
//           color: dialogBackgroundColor,
//           borderRadius: BorderRadius.all(
//             Radius.circular(radius),
//           ),
//         ),
//         child: CommonText(
//           text: text,
//           color: Colors.grey,
//           size: 13,
//           isCenter: true,
//         ),
//       ),
//     );
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';

class DotContainer extends StatelessWidget {
  DotContainer({
    super.key,
    required this.height,
    required this.text,
    required this.borderType,
    required this.radius,
    required this.onTap,
  });

  double height, radius;
  String text;
  BorderType borderType;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: DottedBorder(
          color: Colors.grey,
          dashPattern: const [4, 4],
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
    );
  }
}

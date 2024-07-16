import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

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
      child: DottedBorderContainer(
        height: height,
        adjustHeight: adjustHeight,
        onTap: onTap,
        borderType: borderType,
        radius: radius,
        text: text,
      ),
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({
    super.key,
    required this.height,
    required this.adjustHeight,
    required this.onTap,
    required this.borderType,
    required this.radius,
    required this.text,
  });

  final double height;
  final double? adjustHeight;
  final Function() onTap;
  final BorderType borderType;
  final double radius;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              color: grey.original,
              size: 13,
              isCenter: true,
            ),
          ),
        ),
      ),
    );
  }
}

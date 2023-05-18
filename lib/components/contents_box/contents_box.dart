import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ContentsBox extends StatelessWidget {
  ContentsBox({
    super.key,
    required this.contentsWidget,
    this.backgroundColor,
    this.isBoxShadow,
    this.padding,
    this.width,
    this.height,
  });

  Widget contentsWidget;
  EdgeInsetsGeometry? padding;
  Color? backgroundColor;
  double? width;
  double? height;
  bool? isBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isBoxShadow != null
            ? [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 206, 206, 206).withOpacity(0.5),
                  blurRadius: 10,
                  // spreadRadius: 1.0,
                  offset: Offset(2, 4),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? pagePadding,
        child: contentsWidget,
      ),
    );
  }
}

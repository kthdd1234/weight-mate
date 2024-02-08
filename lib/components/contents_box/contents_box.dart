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
    this.imgUrl,
    this.borderRadius,
  });

  Widget contentsWidget;
  EdgeInsetsGeometry? padding;
  Color? backgroundColor;
  double? width;
  double? height;
  bool? isBoxShadow;
  String? imgUrl;
  double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? pagePadding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: imgUrl != null
            ? DecorationImage(image: AssetImage(imgUrl!), fit: BoxFit.cover)
            : null,
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        boxShadow: isBoxShadow == null
            ? [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 206, 206, 206).withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(2, 4),
                )
              ]
            : null,
      ),
      child: contentsWidget,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonContainer.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class ModalButton extends StatelessWidget {
  ModalButton({
    super.key,
    required this.actionText,
    required this.color,
    required this.onTap,
    this.icon,
    this.svgName,
    this.bgColor,
    this.isBold,
    this.innerPadding,
    this.isNotSvgColor,
    this.isNotTr,
  });

  String? svgName;
  IconData? icon;
  String actionText;
  Color color;
  Color? bgColor;
  bool? isBold, isNotTr, isNotSvgColor;
  EdgeInsets? innerPadding;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: innerPadding ?? const EdgeInsets.all(0),
        child: CommonContainer(
          color: bgColor,
          onTap: onTap,
          radius: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              svgName != null
                  ? svgAsset(
                      name: svgName!,
                      width: 25,
                      color: isNotSvgColor == true ? null : color,
                    )
                  : const EmptyArea(),
              icon != null
                  ? Icon(icon!, size: 25, color: color)
                  : const EmptyArea(),
              SpaceHeight(height: 10),
              CommonName(
                text: actionText,
                color: color,
                isBold: isBold,
                isNotTr: isNotTr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

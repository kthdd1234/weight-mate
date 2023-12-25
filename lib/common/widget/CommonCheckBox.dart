import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonCheckBox extends StatelessWidget {
  CommonCheckBox({
    super.key,
    required this.id,
    required this.isCheck,
    required this.checkColor,
    required this.onTap,
  });

  dynamic id;
  bool isCheck;
  Color checkColor;
  Function({required dynamic id, required bool newValue}) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id: id, newValue: !isCheck),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 0,
                child: Icon(
                    isCheck
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: isCheck ? checkColor : themeColor),
              ),
              SpaceWidth(width: tinySpace),
            ],
          ),
          SpaceHeight(height: tinySpace),
        ],
      ),
    );
  }
}

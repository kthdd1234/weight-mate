import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';

class CommonCheckBox extends StatelessWidget {
  CommonCheckBox(
      {super.key,
      required this.id,
      required this.isCheck,
      required this.checkColor,
      required this.onTap,
      this.isNotBottom,
      this.isDisabled,
      this.isOulined});

  dynamic id;
  bool isCheck;
  bool? isDisabled, isNotBottom, isOulined;
  Color checkColor;

  Function({required dynamic id, required bool newValue}) onTap;

  @override
  Widget build(BuildContext context) {
    IconData icon = isCheck
        ? Icons.check_box_rounded
        : isOulined == true
            ? Icons.check_box
            : Icons.check_box_outline_blank_rounded;
    Color color = isCheck ? checkColor : grey.s300;

    return InkWell(
      onTap: () => onTap(id: id, newValue: !isCheck),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 0,
                child: isDisabled == true
                    ? SvgPicture.asset('assets/svgs/square-dashed.svg')
                    : Icon(icon, color: color),
              ),
              SpaceWidth(width: smallSpace),
            ],
          ),
          SpaceHeight(height: isNotBottom == true ? 0 : tinySpace),
        ],
      ),
    );
  }
}

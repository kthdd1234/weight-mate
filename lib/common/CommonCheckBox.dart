import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/dash_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_svg/svg.dart';

class CommonCheckBox extends StatelessWidget {
  CommonCheckBox({
    super.key,
    required this.id,
    required this.isCheck,
    required this.checkColor,
    required this.onTap,
    this.isDisabled,
  });

  dynamic id;
  bool isCheck;
  bool? isDisabled;
  Color checkColor;
  Function({required dynamic id, required bool newValue}) onTap;

  @override
  Widget build(BuildContext context) {
    IconData icon = isCheck ? Icons.check_box_rounded : Icons.check_box;
    Color color = isCheck ? checkColor : Colors.grey.shade300;

    return InkWell(
      onTap: () => onTap(id: id, newValue: !isCheck),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 0,
                  child: isDisabled == true
                      ? SvgPicture.asset(
                          'assets/svgs/square-dashed.svg',
                        )
                      : Icon(
                          icon,
                          color: color,
                        )),
              SpaceWidth(width: smallSpace),
            ],
          ),
          SpaceHeight(height: tinySpace),
        ],
      ),
    );
  }
}

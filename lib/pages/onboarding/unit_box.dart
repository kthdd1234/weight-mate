import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class UnitBox extends StatelessWidget {
  UnitBox({
    super.key,
    required this.sTallUnit,
    required this.sWeightUnit,
    required this.onTap,
  });

  final String sTallUnit;
  final String sWeightUnit;
  final Function({
    required String type,
    required String unit,
  }) onTap;

  @override
  Widget build(BuildContext context) {
    unitTitle({required String text}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: CommonText(text: text, size: 15, isBold: true),
      );
    }

    commonButton({
      required String type,
      required String unit,
      required String state,
    }) {
      return CommonButton(
        text: unit,
        fontSize: state == unit ? 15 : 14,
        bgColor: state == unit ? themeColor : Colors.grey.shade100,
        radious: 5,
        textColor: state == unit ? Colors.white : Colors.grey,
        isBold: state == unit,
        isNotTr: true,
        onTap: () => onTap(unit: unit, type: type),
      );
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          unitTitle(text: '키 단위'),
          Row(
            children: [
              commonButton(
                unit: 'cm',
                state: sTallUnit,
                type: 'tall',
              ),
              SpaceWidth(width: 5),
              commonButton(
                unit: 'inch',
                state: sTallUnit,
                type: 'tall',
              )
            ],
          ),
          SpaceHeight(height: 30),
          unitTitle(text: '체중 단위'),
          Row(
            children: [
              commonButton(
                unit: 'kg',
                state: sWeightUnit,
                type: 'weight',
              ),
              SpaceWidth(width: 5),
              commonButton(
                unit: 'lb',
                state: sWeightUnit,
                type: 'weight',
              )
            ],
          ),
        ],
      ),
    );
  }
}

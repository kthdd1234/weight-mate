import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonCircle.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class ColorListView extends StatelessWidget {
  ColorListView({
    super.key,
    required this.selectedColorName,
    required this.onColor,
  });

  String selectedColorName;
  Function(String) onColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 30,
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: colorList
              .map(
                (color) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: GestureDetector(
                    onTap: () => onColor(color.colorName),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        CommonCircle(color: color.s100, size: 30),
                        selectedColorName == color.colorName
                            ? getSvg(
                                name: 'mark-V',
                                width: 15,
                                color: color.s300,
                              )
                            : const EmptyArea(),
                      ],
                    ),
                  ),
                ),
              )
              .toList()),
    );
  }
}

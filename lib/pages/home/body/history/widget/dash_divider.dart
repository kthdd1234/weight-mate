import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DashDivider extends StatelessWidget {
  DashDivider({
    Key? key,
    this.height = 1,
    this.color = Colors.black,
  }) : super(key: key);

  double height;
  Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: regularSapce,
            vertical: smallSpace,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

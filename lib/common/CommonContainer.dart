import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget {
  CommonContainer({
    super.key,
    required this.child,
    this.innerPadding,
    this.outerPadding,
    this.color,
    this.radius,
    this.onTap,
    this.height,
  });

  Widget child;
  Color? color;
  double? radius, height;
  EdgeInsets? innerPadding, outerPadding;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // themeContainerColor
    return Padding(
      padding: outerPadding ?? const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          padding: innerPadding ?? const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(radius ?? 10),
          ),
          child: child,
        ),
      ),
    );
  }
}

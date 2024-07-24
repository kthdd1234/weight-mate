import 'package:flutter/material.dart';

class CommonBackground extends StatelessWidget {
  CommonBackground({
    super.key,
    required this.child,
    this.isRadius,
    this.height,
    this.borderRadius,
  });

  bool? isRadius;
  double? height;
  BorderRadius? borderRadius;
  Widget child;

  @override
  Widget build(BuildContext context) {
    // 1, 4, 6, 18
    return Container(
      height: height ?? MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: borderRadius ??
              BorderRadius.circular(isRadius == true ? 10.0 : 0.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/backDrop/b-1.png'),
            fit: BoxFit.cover,
          )),
      child: child,
    );
  }
}

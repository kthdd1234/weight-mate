import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonSvg extends StatelessWidget {
  CommonSvg({super.key, required this.name, required this.width});

  double width;
  String name;

  @override
  Widget build(BuildContext context) {
    SvgPicture svgIcon =
        SvgPicture.asset('assets/svgs/$name.svg', width: width);

    return svgIcon;
  }
}

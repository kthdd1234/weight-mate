import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';

class ExpandedButtonVerti extends StatelessWidget {
  ExpandedButtonVerti({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.mainColor,
  });

  IconData icon;
  String title;
  Color? mainColor;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: EmptyTextVerticalArea(
          icon: icon,
          title: title,
          height: 105,
          mainColor: mainColor,
        ),
      ),
    );
  }
}

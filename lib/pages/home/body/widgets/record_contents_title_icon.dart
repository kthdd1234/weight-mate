import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class RecordContentsTitleIcon extends StatelessWidget {
  RecordContentsTitleIcon({
    super.key,
    required this.id,
    required this.icon,
    required this.onTap,
  });

  RecordIconTypes id;
  IconData icon;
  Function(dynamic id) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceWidth(width: tinySpace),
        DefaultIcon(id: id, icon: icon, onTap: onTap)
        // CircularIcon(
        //   id: id,
        //   size: 30,
        //   borderRadius: 5,
        //   icon: icon,
        //   backgroundColor: typeBackgroundColor,
        //   adjustSize: 12,
        //   onTap: onTap,
        // ),
      ],
    );
  }
}

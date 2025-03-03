import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon({
    super.key,
    required this.isEdit,
    required this.onTapRemove,
    required this.pos,
  });

  final bool isEdit;
  final Function(String pos)? onTapRemove;
  final String pos;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: isEdit == true
          ? CircularIcon(
              padding: 5,
              icon: Icons.close,
              iconColor: typeBackgroundColor,
              adjustSize: 3,
              size: 20,
              borderRadius: 5,
              backgroundColor: textColor,
              backgroundColorOpacity: 0.5,
              onTap: (_) => onTapRemove != null ? onTapRemove!(pos) : null,
            )
          : const EmptyArea(),
    );
  }
}

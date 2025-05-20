import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class WeightEditBottomSheet extends StatelessWidget {
  WeightEditBottomSheet({
    super.key,
    required this.onEdit,
    required this.onRemove,
  });

  Function() onEdit, onRemove;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '현재 체중',
      height: 210,
      contents: Row(
        children: [
          ExpandedButtonVerti(
            icon: Icons.edit,
            title: '수정하기',
            mainColor: themeColor,
            onTap: onEdit,
          ),
          SpaceWidth(width: 5),
          ExpandedButtonVerti(
            icon: Icons.delete_forever,
            title: '삭제하기',
            mainColor: red.original,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistoryMore extends StatelessWidget {
  HistoryMore({
    super.key,
    required this.onTapEdit,
    required this.onTapPartialDelete,
    required this.onTapRemove,
  });

  Function() onTapEdit, onTapPartialDelete, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExpandedButtonVerti(
          mainColor: textColor,
          icon: Icons.edit,
          title: '기록 수정',
          onTap: onTapEdit,
        ),
        SpaceWidth(width: tinySpace),
        ExpandedButtonVerti(
          mainColor: Colors.red,
          icon: Icons.delete_sweep,
          title: '부분 삭제',
          onTap: onTapPartialDelete,
        ),
        SpaceWidth(width: tinySpace),
        ExpandedButtonVerti(
          mainColor: Colors.red,
          icon: Icons.delete_forever,
          title: '모두 삭제',
          onTap: onTapRemove,
        ),
      ],
    );
  }
}

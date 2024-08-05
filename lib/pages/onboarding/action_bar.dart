import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ActionBar extends StatelessWidget {
  ActionBar({super.key, required this.node});

  FocusNode node;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(tinySpace),
        child: Row(
          children: [
            CommonButton(
              text: '닫기',
              fontSize: 16,
              radious: 5,
              bgColor: Colors.white,
              textColor: textColor,
              onTap: () => node.unfocus(),
            ),
            SpaceWidth(width: tinySpace),
            CommonButton(
              text: '다음',
              fontSize: 16,
              radious: 5,
              isBold: true,
              bgColor: textColor,
              textColor: Colors.white,
              onTap: () => node.nextFocus(),
            ),
          ],
        ),
      ),
    );
  }
}

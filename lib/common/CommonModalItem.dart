import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonDivider.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class CommonModalItem extends StatelessWidget {
  CommonModalItem({
    super.key,
    required this.title,
    required this.child,
    required this.onTap,
  });

  String title;
  Widget child;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: title,
                  size: 14,
                ),
                SpaceWidth(width: 50),
                child
              ],
            ),
          ),
          CommonDivider(color: grey.s200),
        ],
      ),
    );
  }
}

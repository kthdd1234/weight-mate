import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/height_divider.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class PlanCheckItem extends StatelessWidget {
  PlanCheckItem({
    super.key,
    required this.id,
    required this.icon,
    required this.groupName,
    required this.itemName,
    required this.isChecked,
    required this.onTap,
  });

  String id, groupName, itemName;
  IconData icon;
  bool isChecked;
  Function({required String id, required bool checked}) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id: id, checked: !isChecked),
      child: ContentsBox(
        padding: const EdgeInsets.fromLTRB(1, 25, 25, 25),
        backgroundColor:
            isChecked ? dialogBackgroundColor : typeBackgroundColor,
        contentsWidget: Row(
          children: [
            HeightDivider(
              width: 3,
              height: 40,
              color: isChecked
                  ? Colors.purple[100]
                  : disabledButtonBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            SpaceWidth(width: regularSapce),
            CircularIcon(
              size: 40,
              borderRadius: 40,
              icon: icon,
              backgroundColor: isChecked ? typeBackgroundColor : Colors.white,
              iconColor: isChecked ? enableTextColor : disEnabledTypeColor,
            ),
            SpaceWidth(width: regularSapce),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmallText(text: groupName),
                  SpaceHeight(height: tinySpace),
                  Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 13,
                      color: isChecked ? themeColor : enabledTypeColor,
                    ),
                  )
                ],
              ),
            ),
            CircularIcon(
              size: 35,
              borderRadius: 35,
              adjustSize: 15,
              icon: isChecked ? Icons.check : null,
              iconColor: enableTextColor,
              backgroundColor: typeBackgroundColor,
              borderColor: isChecked ? enableBackgroundColor : Colors.grey[300],
              onTap: (_) => onTap(id: id, checked: !isChecked),
            ),
          ],
        ),
      ),
    );
  }
}

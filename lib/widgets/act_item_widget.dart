import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ActItemWidget extends StatelessWidget {
  ActItemWidget({
    super.key,
    required this.id,
    required this.title,
    required this.desc1,
    required this.desc2,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  dynamic id;
  String title;
  String desc1;
  String desc2;
  IconData icon;
  bool isEnabled;
  Function(dynamic id) onTap;

  @override
  Widget build(BuildContext context) {
    setDesc(desc) {
      return Text(
        desc,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isEnabled ? enabledTypeColor : disEnabledTypeColor,
        ),
      );
    }

    return InkWell(
      onTap: () => onTap(id),
      child: ContentsBox(
        backgroundColor:
            isEnabled ? buttonBackgroundColor : typeBackgroundColor,
        contentsWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isEnabled ? buttonTextColor : primaryColor,
              ),
            ),
            SpaceHeight(height: tinySpace),
            setDesc(desc1),
            SpaceHeight(height: tinySpace),
            setDesc(desc2),
            SpaceHeight(height: tinySpace - 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularIcon(
                  icon: icon,
                  size: 50,
                  borderRadius: 40,
                  backgroundColor: dialogBackgroundColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

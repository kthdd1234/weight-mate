import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class PlanItemWidget extends StatelessWidget {
  PlanItemWidget({
    super.key,
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    this.width,
  });

  dynamic id;
  String name;
  String desc;
  IconData icon;
  bool isEnabled;
  Function(dynamic id) onTap;
  double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      child: ContentsBox(
        width: width,
        backgroundColor: isEnabled ? themeColor : typeBackgroundColor,
        contentsWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? buttonTextColor : primaryColor,
                    ),
                  ),
                  SpaceHeight(height: tinySpace),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isEnabled ? enabledTypeColor : disEnabledTypeColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularIcon(
                  icon: icon,
                  size: 50,
                  borderRadius: 40,
                  backgroundColor: dialogBackgroundColor,
                  onTap: (_) => onTap(id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

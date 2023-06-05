import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ActTypeWidget extends StatelessWidget {
  ActTypeWidget({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  dynamic id;
  String title;
  String desc;
  IconData icon;
  bool isEnabled;
  Function(dynamic id) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(id),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isEnabled ? buttonBackgroundColor : typeBackgroundColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: pagePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isEnabled
                              ? enabledTypeColor
                              : disEnabledTypeColor,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: dialogBackgroundColor,
                    child: Icon(icon),
                  )
                ],
              ),
            ),
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
    );
  }
}

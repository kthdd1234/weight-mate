import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ContetnsBoxType extends StatelessWidget {
  ContetnsBoxType({
    super.key,
    required this.id,
    required this.titleText,
    required this.subText,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  String id;
  String titleText;
  String subText;
  IconData icon;
  bool isEnabled;
  Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    titleText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? buttonTextColor : primaryColor,
                    ),
                  ),
                  SpaceHeight(height: tinySpace),
                  Text(
                    subText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isEnabled ? enabledTypeColor : disEnabledTypeColor,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: const Color(0xffffffff),
                child: Icon(icon),
              )
            ],
          ),
        ),
      ),
    );
  }
}

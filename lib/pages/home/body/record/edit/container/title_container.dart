import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TitleContainer extends StatelessWidget {
  TitleContainer(
      {super.key,
      required this.title,
      required this.icon,
      required this.tags,
      required this.isDivider,
      this.onTap});

  String title;
  IconData icon;
  List<TagClass> tags;
  bool isDivider;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    List<Row> wRow = tags
        .map((tag) => tag.isHide != true
            ? Row(
                children: [
                  SpaceWidth(width: tinySpace),
                  CommonTag(
                    color: tag.color,
                    text: tag.text,
                    onTap: tag.onTap,
                    icon: tag.icon,
                    leftIcon: tag.leftIcon,
                  )
                ],
              )
            : Row(children: []))
        .toList();

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: title,
                size: 15,
                leftIcon: icon,
                isBold: true,
                color: Colors.grey.shade600,
              ),
              Row(children: wRow)
            ],
          ),
          isDivider
              ? Divider(color: Colors.grey.shade100, height: 30)
              : const EmptyArea(),
        ],
      ),
    );
  }
}

class TagClass {
  TagClass({
    required this.color,
    required this.onTap,
    this.isHide,
    this.icon,
    this.text,
    this.leftIcon,
  });

  String color;
  String? text;
  IconData? icon, leftIcon;
  bool? isHide;
  Function() onTap;
}

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class TitleContainer extends StatelessWidget {
  TitleContainer({
    super.key,
    required this.title,
    required this.svg,
    required this.tags,
    required this.isDivider,
    this.onTap,
    this.isNotTr,
  });

  String title, svg;
  List<TagClass> tags;
  bool isDivider;
  bool? isNotTr;
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
                    nameArgs: tag.nameArgs,
                    isNotTr: tag.isNotTr,
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
              Row(children: [
                svgWidget(
                  name: svg,
                  width: 15,
                  color: Colors.grey.shade600,
                ),
                SpaceWidth(width: 7),
                CommonName(
                  text: title,
                  fontSize: 15,
                  isBold: true,
                  color: Colors.grey.shade600,
                ),
              ]),
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
    this.nameArgs,
    this.isNotTr,
  });

  String color;
  String? text;
  IconData? icon, leftIcon;
  bool? isHide, isNotTr;
  Map<String, String>? nameArgs;
  Function() onTap;
}

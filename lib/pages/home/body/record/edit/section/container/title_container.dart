import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonTag.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TitleContainer extends StatelessWidget {
  TitleContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.tags,
  });

  String title;
  IconData icon;
  List<TagClass> tags;

  @override
  Widget build(BuildContext context) {
    List<Row> wRow = tags
        .map((tag) => Row(
              children: [
                SpaceWidth(width: tinySpace),
                CommonTag(
                  color: tag.color,
                  text: tag.text,
                  onTap: tag.onTap,
                  icon: tag.icon,
                )
              ],
            ))
        .toList();

    return Column(
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
        // SpaceHeight(height: regularSapce),
        Divider(color: Colors.grey.shade100, height: 30),
      ],
    );
  }
}

class TagClass {
  TagClass({
    required this.color,
    required this.onTap,
    this.icon,
    this.text,
  });

  String color;
  String? text;
  IconData? icon;
  Function() onTap;
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/dot_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class RecordPicture extends StatelessWidget {
  const RecordPicture({super.key});

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;

    onTapLeft() {
      //
    }

    onTapRight() {
      //
    }

    bool isContainPicture = user.filterList!.contains(
      FILITER.picture.toString(),
    );

    return Column(
      children: isContainPicture
          ? [
              SpaceHeight(height: smallSpace),
              Row(
                children: [
                  DotContainer(
                    height: 150,
                    text: '사진1',
                    borderType: BorderType.RRect,
                    radius: 10,
                    onTap: onTapLeft,
                  ),
                  SpaceWidth(width: smallSpace),
                  DotContainer(
                    height: 150,
                    text: '사진2',
                    borderType: BorderType.RRect,
                    radius: 10,
                    onTap: onTapRight,
                  ),
                ],
              ),
              SpaceHeight(height: smallSpace),
            ]
          : [SpaceHeight(height: smallSpace)],
    );
  }
}

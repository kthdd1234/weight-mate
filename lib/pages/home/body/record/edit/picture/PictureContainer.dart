import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/Picture.dart';

class PictureContainer extends StatelessWidget {
  PictureContainer({
    super.key,
    required this.pos,
    required this.file,
    required this.time,
    required this.onTapPicture,
    required this.onTapRemove,
  });

  String pos;
  Uint8List? file;
  DateTime? time;
  Function(String pos) onTapPicture, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return file != null
        ? Picture(
            pos: pos,
            isEdit: true,
            file: file,
            time: time,
            onTapPicture: onTapPicture,
            onTapRemove: onTapRemove,
          )
        : DashContainer(
            height: 150,
            text: '사진',
            borderType: BorderType.RRect,
            radius: 10,
            onTap: () => onTapPicture(pos),
          );
  }
}

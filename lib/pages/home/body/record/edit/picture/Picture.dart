import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/CloseIcon.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/TimeLabel.dart';

class Picture extends StatelessWidget {
  Picture({
    super.key,
    required this.pos,
    required this.isEdit,
    this.file,
    this.time,
    this.onTapRemove,
    this.onTapPicture,
  });

  String pos;
  bool isEdit;
  Uint8List? file;
  DateTime? time;
  Function(String pos)? onTapPicture, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          InkWell(
            onTap: () => onTapPicture != null ? onTapPicture!(pos) : null,
            child: DefaultImage(unit8List: file!, height: 150),
          ),
          CloseIcon(isEdit: isEdit, onTapRemove: onTapRemove, pos: pos),
          TimeLabel(time: time),
        ],
      ),
    );
  }
}

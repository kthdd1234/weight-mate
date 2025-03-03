import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/TimeLabel.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class PictureModalBottomSheet extends StatelessWidget {
  PictureModalBottomSheet({
    super.key,
    required this.isFilePath,
    required this.pos,
    required this.fileInfo,
    required this.timeInfo,
    required this.onTapImage,
    required this.onImagePicker,
  });

  bool isFilePath;
  String pos;
  Map<String, Uint8List?> fileInfo;
  Map<String, DateTime?> timeInfo;
  Function(Uint8List) onTapImage;
  Function(ImageSource, String) onImagePicker;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '사진 ${isFilePath ? '편집' : '추가'}'.tr(),
      height: isFilePath ? 500 : 220,
      contents: Column(
        children: [
          isFilePath
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => onTapImage(fileInfo[pos]!),
                    child: Stack(
                      children: [
                        DefaultImage(unit8List: fileInfo[pos]!, height: 280),
                        TimeLabel(time: timeInfo[pos])
                      ],
                    ),
                  ),
                )
              : const EmptyArea(),
          Row(
            children: [
              ExpandedButtonVerti(
                mainColor: textColor,
                icon: Icons.add_a_photo,
                title: '사진 촬영하기',
                onTap: () => onImagePicker(ImageSource.camera, pos),
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonVerti(
                mainColor: textColor,
                icon: Icons.collections,
                title: '사진 가져오기',
                onTap: () => onImagePicker(ImageSource.gallery, pos),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

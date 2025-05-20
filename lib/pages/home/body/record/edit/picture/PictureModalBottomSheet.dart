import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonContainer.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/TimeLabel.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class PictureModalBottomSheet extends StatefulWidget {
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
  State<PictureModalBottomSheet> createState() =>
      _PictureModalBottomSheetState();
}

class _PictureModalBottomSheetState extends State<PictureModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    bool isImageTime = user.isImageTime ?? true;

    onImageTime(bool newValue) async {
      user.isImageTime = newValue;
      await user.save();

      setState(() {});
    }

    return CommonBottomSheet(
      title: '사진 ${widget.isFilePath ? '편집' : '추가'}'.tr(),
      height: widget.isFilePath ? 500 : 280,
      contents: Column(
        children: [
          widget.isFilePath
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () =>
                        widget.onTapImage(widget.fileInfo[widget.pos]!),
                    child: Stack(
                      children: [
                        DefaultImage(
                            unit8List: widget.fileInfo[widget.pos]!,
                            height: 280),
                        TimeLabel(time: widget.timeInfo[widget.pos])
                      ],
                    ),
                  ),
                )
              : const EmptyArea(),
          !widget.isFilePath
              ? CommonContainer(
                  outerPadding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      CommonText(text: '사진에 시간도 표시할까요?', size: 14),
                      const Spacer(),
                      SizedBox(
                        height: 30,
                        child: CupertinoSwitch(
                          value: isImageTime,
                          activeColor: themeColor,
                          onChanged: onImageTime,
                        ),
                      )
                    ],
                  ),
                )
              : const EmptyArea(),
          Row(
            children: [
              ExpandedButtonVerti(
                mainColor: textColor,
                icon: Icons.add_a_photo,
                title: '사진 촬영하기',
                onTap: () =>
                    widget.onImagePicker(ImageSource.camera, widget.pos),
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonVerti(
                mainColor: textColor,
                icon: Icons.collections,
                title: '사진 가져오기',
                onTap: () =>
                    widget.onImagePicker(ImageSource.gallery, widget.pos),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

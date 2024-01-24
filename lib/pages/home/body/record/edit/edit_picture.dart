import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/route/fade_page_route.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditPicture extends StatelessWidget {
  EditPicture({super.key, required this.setActiveCamera});

  Function(bool newValue) setActiveCamera;

  @override
  Widget build(BuildContext context) {
    String fPicture = FILITER.picture.toString();
    UserBox user = userRepository.user;
    bool? isDisplay = user.displayList?.contains(fPicture) == true;
    bool isOpen = user.filterList?.contains(fPicture) == true;
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    Map<String, Uint8List?> fileInfo = {
      'left': recordInfo?.leftFile,
      'right': recordInfo?.rightFile,
      'bottom': recordInfo?.bottomFile,
    };

    setFile({required Uint8List? newValue, required String pos}) {
      switch (pos) {
        case 'left':
          recordInfo?.leftFile = newValue;
          break;
        case 'right':
          recordInfo?.rightFile = newValue;
          break;
        case 'bottom':
          recordInfo?.bottomFile = newValue;
          break;
        default:
      }

      recordInfo?.save();
    }

    convertUnit8List(XFile? xFile) async {
      return await File(xFile!.path).readAsBytes();
    }

    onNavigatorImageCollectionsPage() async {
      closeDialog(context);
      await Navigator.pushNamed(context, '/image-collections-page');
    }

    onNavigatorImagePullSizePage({required Uint8List binaryData}) async {
      closeDialog(context);

      Navigator.push(
        context,
        FadePageRoute(page: ImagePullSizePage(binaryData: binaryData)),
      );
    }

    setImagePicker({
      required ImageSource source,
      required String pos,
    }) async {
      XFile? xFileData;
      setActiveCamera(true);

      await ImagePicker().pickImage(source: source).then(
        (xFile) async {
          if (xFile == null) return;

          xFileData = xFile;
        },
      ).catchError(
        (error) {
          print('error 확인 ==>> $error');

          showSnackBar(
            context: context,
            text: '${ImageSource.camera == source ? '카메라' : '사진'} 접근 권한이 없습니다.',
            buttonName: '설정으로 이동',
            onPressed: openAppSettings,
          );
        },
      );

      return xFileData;
    }

    showDialogPopup({required String title, required Uint8List binaryData}) {
      showDialog(
        context: context,
        builder: (context) {
          return NativeAdDialog(
            title: title,
            leftText: '사진 확인',
            rightText: '사진 앨범',
            onLeftClick: () =>
                onNavigatorImagePullSizePage(binaryData: binaryData),
            onRightClick: onNavigatorImageCollectionsPage,
          );
        },
      );
    }

    setPickedImage({required String pos, required XFile? xFile}) async {
      if (xFile == null) return;

      Uint8List pickedImage = await File(xFile.path).readAsBytes();

      if (recordInfo == null) {
        recordRepository.recordBox.put(
          recordKey,
          RecordBox(
              createDateTime: importDateTime,
              leftFile: pos == 'left' ? pickedImage : null,
              rightFile: pos == 'right' ? pickedImage : null,
              bottomFile: pos == 'bottom' ? pickedImage : null),
        );
      } else {
        setFile(pos: pos, newValue: pickedImage);
      }
    }

    onShowImagePicker(ImageSource source, String pos) async {
      closeDialog(context);

      XFile? xFileData = await setImagePicker(source: source, pos: pos);

      if (xFileData != null) {
        setPickedImage(pos: pos, xFile: xFileData);

        // Uint8List unit8List = await convertUnit8List(xFileData);
        // showDialogPopup(title: '사진 기록 완료!', binaryData: unit8List);
      }
    }

    onTapPicture(String pos) {
      bool isFilePath = fileInfo[pos] != null;

      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => CommonBottomSheet(
          title: '사진 ${isFilePath ? '편집' : '추가'}',
          height: isFilePath ? 500 : 220,
          contents: Column(
            children: [
              isFilePath
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () => onNavigatorImagePullSizePage(
                            binaryData: fileInfo[pos]!,
                          ),
                          child: DefaultImage(
                              unit8List: fileInfo[pos]!, height: 280),
                        ),
                        SpaceHeight(height: smallSpace)
                      ],
                    )
                  : const EmptyArea(),
              Row(
                children: [
                  ExpandedButtonVerti(
                    mainColor: themeColor,
                    icon: Icons.add_a_photo,
                    title: '사진 촬영하기',
                    onTap: () => onShowImagePicker(ImageSource.camera, pos),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonVerti(
                    mainColor: themeColor,
                    icon: Icons.collections,
                    title: '사진 가져오기',
                    onTap: () => onShowImagePicker(ImageSource.gallery, pos),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    onTapRemove(String pos) {
      setFile(pos: pos, newValue: null);
    }

    onTapOpen() {
      isOpen
          ? user.filterList?.remove(fPicture)
          : user.filterList?.add(fPicture);
      user.save();
    }

    return isDisplay
        ? Column(
            children: [
              ContentsBox(
                padding: EdgeInsets.fromLTRB(20, 20, 20, isOpen ? 10 : 20),
                contentsWidget: Column(
                  children: [
                    TitleContainer(
                      isDivider: isOpen,
                      title: '사진',
                      icon: Icons.auto_awesome,
                      tags: [
                        TagClass(
                          text: '사진 ${[
                            recordInfo?.leftFile,
                            recordInfo?.rightFile,
                            recordInfo?.bottomFile
                          ].whereType<Uint8List>().length}장',
                          color: 'purple',
                          isHide: isOpen,
                          onTap: onTapOpen,
                        ),
                        TagClass(
                          text: '사진 앨범',
                          color: 'purple',
                          onTap: () => Navigator.pushNamed(
                              context, '/image-collections-page'),
                        ),
                        TagClass(
                          icon: isOpen
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_right_rounded,
                          color: 'purple',
                          onTap: onTapOpen,
                        )
                      ],
                      onTap: onTapOpen,
                    ),
                    isOpen
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  PictureContainer(
                                    file: fileInfo['left'],
                                    pos: 'left',
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                  SpaceWidth(width: 5),
                                  PictureContainer(
                                    file: fileInfo['right'],
                                    pos: 'right',
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                ],
                              ),
                              SpaceHeight(height: 7),
                              CommonText(
                                leftIcon: Icons.info_outline,
                                text: '추가한 사진은 앱 내에 저장되요.',
                                size: 10,
                                color: Colors.grey,
                              )
                            ],
                          )
                        : const EmptyArea(),
                  ],
                ),
              ),
              SpaceHeight(height: smallSpace),
            ],
          )
        : const EmptyArea();
  }
}

class PictureContainer extends StatelessWidget {
  PictureContainer({
    super.key,
    required this.file,
    required this.pos,
    required this.onTapPicture,
    required this.onTapRemove,
  });

  Uint8List? file;
  String pos;
  Function(String pos) onTapPicture, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return file != null
        ? Picture(
            pos: pos,
            isEdit: true,
            uint8List: file,
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

class Picture extends StatelessWidget {
  Picture({
    super.key,
    required this.pos,
    required this.isEdit,
    this.uint8List,
    this.onTapRemove,
    this.onTapPicture,
  });

  String pos;
  bool isEdit;
  Uint8List? uint8List;
  Function(String pos)? onTapPicture, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return uint8List != null
        ? Expanded(
            child: Stack(
              children: [
                InkWell(
                  onTap: () => onTapPicture != null ? onTapPicture!(pos) : null,
                  child: DefaultImage(unit8List: uint8List!, height: 150),
                ),
                CloseIcon(isEdit: isEdit, onTapRemove: onTapRemove, pos: pos)
              ],
            ),
          )
        : const EmptyArea();
  }
}

class CloseIcon extends StatelessWidget {
  const CloseIcon({
    super.key,
    required this.isEdit,
    required this.onTapRemove,
    required this.pos,
  });

  final bool isEdit;
  final Function(String pos)? onTapRemove;
  final String pos;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: isEdit == true
          ? CircularIcon(
              padding: 5,
              icon: Icons.close,
              iconColor: typeBackgroundColor,
              adjustSize: 3,
              size: 20,
              borderRadius: 5,
              backgroundColor: themeColor,
              backgroundColorOpacity: 0.5,
              onTap: (_) => onTapRemove != null ? onTapRemove!(pos) : null,
            )
          : const EmptyArea(),
    );
  }
}

// class HistoryPicture extends StatelessWidget {
//   HistoryPicture({
//     super.key,
//     required this.leftFile,
//     required this.rightFile,
//   });

//   Uint8List? leftFile, rightFile;

//   @override
//   Widget build(BuildContext context) {
//     List<Uint8List?> fileList = [leftFile, rightFile];

//     return Column(
//       children: [
//         SpaceHeight(height: smallSpace),
//         Row(
//           children: [
//             leftFile != null
//                 ? DefaultImage(data: leftFile!, height: 150)
//                 : EmptyArea(),
//             rightFile != null
//                 ? DefaultImage(data: rightFile!, height: 150)
//                 : EmptyArea()
//           ],
//         ),
//         Row(
//           children: fileList
//               .map((file) => file != null
//                   ? Expanded(child: DefaultImage(data: file, height: 150))
//                   : const EmptyArea())
//               .toList(),
//         ),
//         SpaceHeight(height: smallSpace),
//       ],
//     );
//   }
// }
// Column(
//             children: [
//               SpaceHeight(height: smallSpace),
//               Row(
//                 children: [
//                   Picture(
//                     pos: 'left',
//                     isEdit: false,
//                     uint8List: leftFile,
//                     onTapPicture: (_) =>
//                         onNavigatorImagePullSizePage(binaryData: leftFile!),
//                   ),
//                   SpaceWidth(width: tinySpace),
//                   Picture(
//                     pos: 'right',
//                     isEdit: false,
//                     uint8List: rightFile,
//                     onTapPicture: (_) =>
//                         onNavigatorImagePullSizePage(binaryData: rightFile!),
//                   ),
//                 ],
//               ),
//               SpaceHeight(height: smallSpace),
//             ],
//           );
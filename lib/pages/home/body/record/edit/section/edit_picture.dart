import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditPicture extends StatelessWidget {
  EditPicture({
    super.key,
    required this.setActiveCamera,
    required this.recordType,
  });

  RECORD recordType;
  Function(bool isActive) setActiveCamera;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    bool isEdit = recordType == RECORD.edit;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    Uint8List? mainFile = null; //recordInfo?.centerFile;
    Uint8List? leftFile = recordInfo?.leftFile;
    Uint8List? rightFile = recordInfo?.rightFile;
    Map<String, Uint8List?> fileInfo = {'left': leftFile, 'right': rightFile};

    convertUnit8List(XFile? xFile) async {
      return await File(xFile!.path).readAsBytes();
    }

    onNavigatorImageCollectionsPage() async {
      closeDialog(context);
      await Navigator.pushNamed(context, '/image-collections-page');
    }

    onNavigatorImagePullSizePage({required Uint8List binaryData}) async {
      isEdit && closeDialog(context);

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
            rightText: '사진 목록',
            leftIcon: Icons.image_outlined,
            rightIcon: Icons.apps_rounded,
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
      int year = importDateTime.year;
      int month = importDateTime.month;
      int day = importDateTime.day;
      DateTime now = DateTime.now();
      DateTime diaryDateTime = DateTime(year, month, day, now.hour, now.minute);

      if (recordInfo == null) {
        recordRepository.recordBox.put(
          recordKey,
          RecordBox(
            createDateTime: importDateTime,
            diaryDateTime: diaryDateTime,
            leftFile: pos == 'left' ? pickedImage : null,
            rightFile: pos == 'right' ? pickedImage : null,
          ),
        );
      } else {
        recordInfo.diaryDateTime = diaryDateTime;
        pos == 'left'
            ? recordInfo.leftFile = pickedImage
            : recordInfo.rightFile = pickedImage;
        recordInfo.save();
      }
    }

    onShowImagePicker(ImageSource source, String pos) async {
      closeDialog(context);

      XFile? xFileData = await setImagePicker(source: source, pos: pos);

      if (xFileData != null) {
        setPickedImage(pos: pos, xFile: xFileData);

        Uint8List unit8List = await convertUnit8List(xFileData);
        showDialogPopup(title: '사진 기록 완료!', binaryData: unit8List);
      }
    }

    onTapPicture(String pos) {
      bool isFilePath = fileInfo[pos] != null;

      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => DefaultBottomSheet(
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
                          child:
                              DefaultImage(data: fileInfo[pos]!, height: 280),
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
                    title: '사진 촬영',
                    onTap: () => onShowImagePicker(ImageSource.camera, pos),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonVerti(
                    mainColor: themeColor,
                    icon: Icons.collections,
                    title: '앨범 열기',
                    onTap: () => onShowImagePicker(ImageSource.gallery, pos),
                  ),
                  // SpaceWidth(width: tinySpace),
                  // ExpandedButtonVerti(
                  //   mainColor: themeColor,
                  //   icon: Icons.apps,
                  //   title: '사진 목록',
                  //   onTap: onNavigatorImageCollectionsPage,
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    onTapRemove(String pos) {
      pos == 'left'
          ? recordInfo?.leftFile = null
          : recordInfo?.rightFile = null;

      recordInfo?.save();
    }

    onTapCollapse() {
      //
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          TitleContainer(
            title: '사진',
            icon: Icons.auto_awesome,
            tags: [
              TagClass(
                text: '사진 목록',
                color: 'purple',
                onTap: () =>
                    Navigator.pushNamed(context, '/image-collections-page'),
              ),
              TagClass(
                icon: Icons.keyboard_arrow_down_rounded,
                color: 'purple',
                onTap: onTapCollapse,
              )
            ],
          ),
          Row(
            children: [
              PictureContainer(
                file: leftFile,
                pos: 'left',
                onTapPicture: onTapPicture,
                onTapRemove: onTapRemove,
              ),
              SpaceWidth(width: smallSpace),
              PictureContainer(
                file: rightFile,
                pos: 'right',
                onTapPicture: onTapPicture,
                onTapRemove: onTapRemove,
              ),
            ],
          ),
          // SpaceHeight(height: smallSpace),
          // Row(
          //   children: [
          //     PictureContainer(
          //       file: mainFile,
          //       pos: 'main',
          //       onTapPicture: onTapPicture,
          //       onTapRemove: onTapRemove,
          //     ),
          //   ],
          // )
        ],
      ),
    );
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
                  child: DefaultImage(data: uint8List!, height: 150),
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
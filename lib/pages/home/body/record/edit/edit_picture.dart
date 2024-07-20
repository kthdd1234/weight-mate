// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
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
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditPicture extends StatelessWidget {
  const EditPicture({super.key});

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
      'top': recordInfo?.topFile,
    };
    int pictureLength = [
      recordInfo?.leftFile,
      recordInfo?.rightFile,
      recordInfo?.bottomFile,
      recordInfo?.topFile
    ].whereType<Uint8List>().length;
    bool isPremium = context.watch<PremiumProvider>().isPremium;

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
        case 'top':
          recordInfo?.topFile = newValue;
          break;
        default:
      }

      recordInfo?.save();
    }

    // convertUnit8List(XFile? xFile) async {
    //   return await File(xFile!.path).readAsBytes();
    // }

    // onNavigatorImageCollectionsPage() async {
    //   closeDialog(context);
    //   await Navigator.pushNamed(context, '/image-collections-page');
    // }

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

    // showDialogPopup({required String title}) {
    //   onLeftClick() {
    //     Navigator.pushNamed(context, '/premium-page');
    //   }

    //   onRightClick() {
    //     closeDialog(context);
    //   }

    //   showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return NativeAdDialog(
    //         title: title,
    //         loadingText: '광고 불러오는 중...',
    //         leftText: '광고 제거',
    //         rightText: '광고 닫기',
    //         onLeftClick: onLeftClick,
    //         onRightClick: onRightClick,
    //       );
    //     },
    //   );
    // }

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
            bottomFile: pos == 'bottom' ? pickedImage : null,
            topFile: pos == 'top' ? pickedImage : null,
          ),
        );
      } else {
        setFile(pos: pos, newValue: pickedImage);
      }
    }

    onShowImagePicker(ImageSource source, String pos) async {
      closeDialog(context);

      XFile? xFileData = await setImagePicker(source: source, pos: pos);
      if (isPremium == false && pictureLength > 0) {
        showDialog(
          context: context,
          builder: (context) => CommonPopup(
            title: "사진 추가 제한",
            height: 166,
            buttonText: '프리미엄 구매 페이지로 이동',
            text1: '프리미엄 구매 시',
            text2: '사진을 4장까지 추가 할 수 있어요.',
            text3: '(미구매 시 1장까지만 추가 가능)',
            onTap: () => Navigator.pushNamed(context, '/premium-page'),
          ),
        );
        return;
      }

      if (xFileData != null) {
        setPickedImage(pos: pos, xFile: xFileData);
        return;
      }
    }

    onTapPicture(String pos) {
      bool isFilePath = fileInfo[pos] != null;

      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => CommonBottomSheet(
          title: '사진 ${isFilePath ? '편집' : '추가'}'.tr(),
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
                            unit8List: fileInfo[pos]!,
                            height: 280,
                          ),
                        ),
                        SpaceHeight(height: smallSpace)
                      ],
                    )
                  : const EmptyArea(),
              Row(
                children: [
                  ExpandedButtonVerti(
                    mainColor: textColor,
                    icon: Icons.add_a_photo,
                    title: '사진 촬영하기',
                    onTap: () => onShowImagePicker(ImageSource.camera, pos),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonVerti(
                    mainColor: textColor,
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
                          text: '사진 장',
                          nameArgs: {'length': '$pictureLength'},
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
                                  SpaceWidth(width: 7),
                                  PictureContainer(
                                    file: fileInfo['right'],
                                    pos: 'right',
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                ],
                              ),
                              SpaceHeight(height: 7),
                              Row(
                                children: [
                                  PictureContainer(
                                    file: fileInfo['bottom'],
                                    pos: 'bottom',
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                  SpaceWidth(width: 7),
                                  PictureContainer(
                                    file: fileInfo['top'],
                                    pos: 'top',
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                ],
                              ),
                              SpaceHeight(height: 7),
                              CommonText(
                                leftIcon: Icons.info_outline,
                                text: '사진은 앱 내 저장 공간에 저장돼요.',
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
              backgroundColor: textColor,
              backgroundColorOpacity: 0.5,
              onTap: (_) => onTapRemove != null ? onTapRemove!(pos) : null,
            )
          : const EmptyArea(),
    );
  }
}

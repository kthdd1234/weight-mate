// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/PictureContainer.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/picture/PictureModalBottomSheet.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditPicture extends StatelessWidget {
  const EditPicture({super.key});

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    bool? isDisplay = user.displayList?.contains(fPicture) == true;
    bool isOpen = user.filterList?.contains(fPicture) == true;

    bool isPremium = context.watch<PremiumProvider>().isPremium;
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

    Map<String, DateTime?> timeInfo = {
      'left': recordInfo?.leftFileTime,
      'right': recordInfo?.rightFileTime,
      'bottom': recordInfo?.bottomFileTime,
      'top': recordInfo?.topFileTime,
    };

    setFile({
      required Uint8List? file,
      required String pos,
      required DateTime? time,
    }) async {
      switch (pos) {
        case 'left':
          recordInfo?.leftFile = file;
          recordInfo?.leftFileTime = time;
          break;
        case 'right':
          recordInfo?.rightFile = file;
          recordInfo?.rightFileTime = time;
          break;
        case 'bottom':
          recordInfo?.bottomFile = file;
          recordInfo?.bottomFileTime = time;
          break;
        case 'top':
          recordInfo?.topFile = file;
          recordInfo?.topFileTime = time;
          break;
        default:
      }

      await recordInfo?.save();
    }

    onTapImage(Uint8List binaryData) async {
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

    setPickedImage({required String pos, required XFile? xFile}) async {
      if (xFile == null) return;

      Uint8List pickedImage = await File(xFile.path).readAsBytes();
      DateTime time = await xFile.lastModified();
      bool isPicture = (recordInfo?.leftFile ??
              recordInfo?.rightFile ??
              recordInfo?.bottomFile ??
              recordInfo?.topFile) ==
          null;

      log('lastModified: ${time.toString()}');

      if (recordInfo == null) {
        recordRepository.recordBox.put(
          recordKey,
          RecordBox(
            createDateTime: importDateTime,
            leftFile: pos == 'left' ? pickedImage : null,
            rightFile: pos == 'right' ? pickedImage : null,
            bottomFile: pos == 'bottom' ? pickedImage : null,
            topFile: pos == 'top' ? pickedImage : null,
            leftFileTime: pos == 'left' ? time : null,
            rightFileTime: pos == 'right' ? time : null,
            bottomFileTime: pos == 'bottom' ? time : null,
            topFileTime: pos == 'top' ? time : null,
          ),
        );
      } else if (isPicture) {
        setFile(pos: pos, file: pickedImage, time: time);
      } else {
        setFile(pos: pos, file: pickedImage, time: time);
      }

      onShowInterstitialAd(isPremium: isPremium, user: user);
    }

    onImagePicker(ImageSource source, String pos) async {
      bool isFilePath = fileInfo[pos] != null;
      closeDialog(context);

      XFile? xFileData = await setImagePicker(source: source, pos: pos);
      int len = getPictureLength(importDateTime);

      if (isPremium == false && len > 0 && isFilePath == false) {
        showDialog(
          context: context,
          builder: (context) => AlertPopup(
            height: 206,
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
        builder: (context) => PictureModalBottomSheet(
          isFilePath: isFilePath,
          pos: pos,
          fileInfo: fileInfo,
          timeInfo: timeInfo,
          onTapImage: onTapImage,
          onImagePicker: onImagePicker,
        ),
      );
    }

    onTapRemove(String pos) {
      setFile(pos: pos, file: null, time: null);
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
                          text: '장',
                          nameArgs: {
                            'length': '${getPictureLength(importDateTime)}'
                          },
                          color: 'purple',
                          isHide: isOpen,
                          onTap: onTapOpen,
                        ),
                        TagClass(
                          text: '사진 모아보기',
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
                                    pos: 'left',
                                    file: fileInfo['left'],
                                    time: timeInfo['left'],
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                  SpaceWidth(width: 7),
                                  PictureContainer(
                                    pos: 'right',
                                    file: fileInfo['right'],
                                    time: timeInfo['right'],
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                ],
                              ),
                              SpaceHeight(height: 7),
                              Row(
                                children: [
                                  PictureContainer(
                                    pos: 'bottom',
                                    file: fileInfo['bottom'],
                                    time: timeInfo['bottom'],
                                    onTapPicture: onTapPicture,
                                    onTapRemove: onTapRemove,
                                  ),
                                  SpaceWidth(width: 7),
                                  PictureContainer(
                                    pos: 'top',
                                    file: fileInfo['top'],
                                    time: timeInfo['top'],
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

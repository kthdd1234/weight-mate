import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_data_widget.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/services/file_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TodayDiaryWidget extends StatefulWidget {
  TodayDiaryWidget({
    super.key,
    required this.seletedRecordSubType,
    required this.setCameraActive,
  });

  RecordIconTypes seletedRecordSubType;
  Function(bool newValue) setCameraActive;

  @override
  State<TodayDiaryWidget> createState() => _TodayDiaryWidgetState();
}

class _TodayDiaryWidgetState extends State<TodayDiaryWidget> {
  late Box<RecordBox> recordBox;

  @override
  void initState() {
    recordBox = Hive.box<RecordBox>('recordBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    RecordBox? recordInfo = recordBox.get(getDateTimeToInt(importDateTime));
    String? leftEyeBodyFilePath = recordInfo?.leftEyeBodyFilePath;
    String? rightEyeBodyFilePath = recordInfo?.rightEyeBodyFilePath;
    Map<String, String?> filePathInfo = {
      'left': leftEyeBodyFilePath,
      'right': rightEyeBodyFilePath,
    };
    RecordIconTypeProvider provider = context.read<RecordIconTypeProvider>();

    List<RecordIconClass> iconClassList = [
      RecordIconClass(
        enumId: RecordIconTypes.editNote,
        icon: Icons.edit,
      ),
      RecordIconClass(
        enumId: RecordIconTypes.removeNote,
        icon: Icons.delete,
      )
    ];

    onPressedDelete() {
      recordInfo!.whiteText = null;
      recordInfo.save();
    }

    List<RecordContentsTitleIcon> icons = iconClassList
        .map(
          (element) => RecordContentsTitleIcon(
            id: element.enumId,
            icon: element.icon,
            onTap: (id) {
              switch (id) {
                case RecordIconTypes.editNote:
                  provider.setSeletedRecordIconType(RecordIconTypes.editNote);

                  break;
                case RecordIconTypes.removeNote:
                  if (recordInfo == null || recordInfo.whiteText == null) {
                    showSnackBar(
                      context: context,
                      text: '삭제할 일기 내용이 없어요.',
                      buttonName: '확인',
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        width: 230,
                        titleText: '일기 삭제',
                        contentIcon: Icons.delete_forever,
                        contentText1: '오늘의 일기 내용을',
                        contentText2: '삭제하시겠습니까?',
                        onPressedOk: onPressedDelete,
                      ),
                    );
                    provider.setSeletedRecordIconType(RecordIconTypes.none);
                  }

                  break;
                default:
              }
            },
          ),
        )
        .toList();

    setImagePicker({
      required ImageSource source,
      required String pos,
    }) {
      // 뺑글뺑글 시작
      closeDialog(context);
      widget.setCameraActive(true);

      ImagePicker().pickImage(source: source).then(
        (xFile) async {
          if (xFile == null) return;

          final pickedImage = File(xFile.path);
          final filePath = await saveImageToLocalDirectory(pickedImage);

          if (recordInfo == null) {
            recordBox.put(
              getDateTimeToInt(importDateTime),
              RecordBox(
                createDateTime: importDateTime,
                diaryDateTime: DateTime.now(),
                leftEyeBodyFilePath: pos == 'left' ? filePath : null,
                rightEyeBodyFilePath: pos == 'right' ? filePath : null,
              ),
            );
          } else {
            recordInfo.diaryDateTime = DateTime.now();
            pos == 'left'
                ? recordInfo.leftEyeBodyFilePath = filePath
                : recordInfo.rightEyeBodyFilePath = filePath;
            recordInfo.save();
          }
          // 뺑글뺑글 종료
        },
      ).catchError(
        (error) {
          print('error 확인 ==>> $error');
          showSnackBar(
            context: context,
            text: '땡땡 접근 권한이 없습니다.',
            buttonName: '설정으로 이동',
            onPressed: openAppSettings,
          );

          // 뺑글뺑글 종료
        },
      );
    }

    contentsItem({
      required ImageSource source,
      required IconData icon,
      required String title,
      required String pos,
    }) {
      return Expanded(
        child: InkWell(
          onTap: () => setImagePicker(source: source, pos: pos),
          child: EmptyTextVerticalArea(
            icon: icon,
            title: title,
            height: 100,
          ),
        ),
      );
    }

    onTapImage(String pos) {
      final isFilePath = filePathInfo[pos] != null;

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
                        ContentsBox(
                          backgroundColor: Colors.white,
                          contentsWidget: DefaultImage(
                            path: filePathInfo[pos]!,
                            height: 220,
                          ),
                        ),
                        SpaceHeight(height: smallSpace)
                      ],
                    )
                  : const EmptyArea(),
              Row(
                children: [
                  contentsItem(
                    source: ImageSource.camera,
                    icon: Icons.add_a_photo,
                    title: '사진 촬영',
                    pos: pos,
                  ),
                  SpaceWidth(width: tinySpace),
                  contentsItem(
                    source: ImageSource.gallery,
                    icon: Icons.collections,
                    title: '앨범 열기',
                    pos: pos,
                  ),
                ],
              ),
            ],
          ),
          isEnabled: null,
          submitText: '',
          onSubmit: () {},
        ),
      );
    }

    onReoveImage(String pos) {
      pos == 'left'
          ? recordInfo?.leftEyeBodyFilePath = null
          : recordInfo?.rightEyeBodyFilePath = null;

      recordInfo?.save();
    }

    setEmptyImageWidget(String pos) {
      return Expanded(
        child: InkWell(
          onTap: () => onTapImage(pos),
          child: DottedBorder(
            radius: const Radius.circular(30),
            color: Colors.transparent,
            strokeWidth: 1,
            child: EmptyTextVerticalArea(icon: Icons.add, title: '사진 추가'),
          ),
        ),
      );
    }

    Widget setEyeBodyImageWidget(String pos) {
      return Expanded(
        child: Stack(
          children: [
            InkWell(
              onTap: () => onTapImage(pos),
              child: DefaultImage(path: filePathInfo[pos]!, height: 150),
            ),
            Positioned(
              right: 0,
              child: CircularIcon(
                padding: 5,
                icon: Icons.close,
                iconColor: typeBackgroundColor,
                adjustSize: 3,
                size: 20,
                borderRadius: 5,
                backgroundColor: buttonBackgroundColor,
                backgroundColorOpacity: 0.5,
                onTap: (_) => onReoveImage(pos),
              ),
            )
          ],
        ),
      );
    }

    Widget setEyeBodyWidgets() {
      return Row(
        children: [
          leftEyeBodyFilePath != null
              ? setEyeBodyImageWidget('left')
              : setEmptyImageWidget('left'),
          SpaceWidth(width: tinySpace),
          rightEyeBodyFilePath != null
              ? setEyeBodyImageWidget('right')
              : setEmptyImageWidget('right')
        ],
      );
    }

    onPressedOk(String text) {
      if (recordInfo == null) {
        return recordBox.put(
          getDateTimeToInt(importDateTime),
          RecordBox(
            createDateTime: importDateTime,
            diaryDateTime: importDateTime,
            whiteText: text,
          ),
        );
      } else {
        recordInfo.whiteText = text;
        recordInfo.diaryDateTime = DateTime.now();
        recordInfo.save();
      }
    }

    Widget setDiaryWidget() {
      String? whiteText = recordInfo?.whiteText;

      if (RecordIconTypes.editNote == widget.seletedRecordSubType) {
        return TodayDiaryEditWidget(
          text: whiteText ?? '',
          onPressedOk: onPressedOk,
        );
      } else if (whiteText == null) {
        return EmptyTextArea(
          topHeight: largeSpace,
          downHeight: largeSpace,
          text: '오늘의 일기를 작성해보세요.',
          icon: Icons.add,
          onTap: () =>
              provider.setSeletedRecordIconType(RecordIconTypes.editNote),
        );
      }

      return TodayDiaryDataWidget(text: whiteText);
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '오늘의 일기',
            icon: Icons.menu_book,
            sub: icons,
          ),
          SpaceHeight(height: smallSpace + 5),
          setEyeBodyWidgets(),
          SpaceHeight(height: smallSpace),
          setDiaryWidget(),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
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
    required this.setActiveCamera,
    required this.importDateTime,
  });

  RecordIconTypes seletedRecordSubType;
  DateTime importDateTime;
  Function(bool isActive) setActiveCamera;

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
    RecordBox? recordInfo =
        recordBox.get(getDateTimeToInt(widget.importDateTime));
    Uint8List? leftFile = recordInfo?.leftFile;
    Uint8List? rightFile = recordInfo?.rightFile;
    Map<String, Uint8List?> fileInfo = {
      'left': leftFile,
      'right': rightFile,
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

      widget.setActiveCamera(true);

      ImagePicker().pickImage(source: source).then(
        (xFile) async {
          if (xFile == null) return;

          Uint8List pickedImage = await File(xFile.path).readAsBytes();
          int year = widget.importDateTime.year;
          int month = widget.importDateTime.month;
          int day = widget.importDateTime.day;
          DateTime now = DateTime.now();
          DateTime diaryDateTime =
              DateTime(year, month, day, now.hour, now.minute);

          if (recordInfo == null) {
            recordBox.put(
              getDateTimeToInt(widget.importDateTime),
              RecordBox(
                createDateTime: widget.importDateTime,
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

          // 뺑글뺑글 종료
        },
      ).catchError(
        (error) {
          print('error 확인 ==>> $error');

          final target = ImageSource.camera == source ? '카메라' : '사진';

          showSnackBar(
            context: context,
            text: '$target 접근 권한이 없습니다.',
            buttonName: '설정으로 이동',
            onPressed: openAppSettings,
          );

          // 뺑글뺑글 종료
        },
      );
    }

    onTapImage(String pos) {
      final isFilePath = fileInfo[pos] != null;

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
                        DefaultImage(data: fileInfo[pos]!, height: 280),
                        SpaceHeight(height: smallSpace)
                      ],
                    )
                  : const EmptyArea(),
              Row(
                children: [
                  ExpandedButtonVerti(
                    icon: Icons.add_a_photo,
                    title: '사진 촬영',
                    onTap: () =>
                        setImagePicker(source: ImageSource.camera, pos: pos),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonVerti(
                    icon: Icons.collections,
                    title: '앨범 열기',
                    onTap: () =>
                        setImagePicker(source: ImageSource.gallery, pos: pos),
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
          ? recordInfo?.leftFile = null
          : recordInfo?.rightFile = null;

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
            child: ContentsBox(
              padding: const EdgeInsets.all(10),
              contentsWidget: EmptyTextVerticalArea(
                icon: Icons.add,
                title: '사진 추가',
                backgroundColor: dialogBackgroundColor,
              ),
            ),
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
              child: DefaultImage(data: fileInfo[pos]!, height: 170),
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
          leftFile != null
              ? setEyeBodyImageWidget('left')
              : setEmptyImageWidget('left'),
          SpaceWidth(width: tinySpace),
          rightFile != null
              ? setEyeBodyImageWidget('right')
              : setEmptyImageWidget('right')
        ],
      );
    }

    onPressedOk(String text) {
      int year = widget.importDateTime.year;
      int month = widget.importDateTime.month;
      int day = widget.importDateTime.day;
      DateTime now = DateTime.now();

      if (text == '') {
        showSnackBar(
          context: context,
          text: '한 글자 이상 입력해주세요.',
          buttonName: '확인',
          width: 270,
        );
      } else {
        if (recordInfo == null) {
          return recordBox.put(
            getDateTimeToInt(widget.importDateTime),
            RecordBox(
              createDateTime: widget.importDateTime,
              diaryDateTime: widget.importDateTime,
              whiteText: text,
            ),
          );
        } else {
          recordInfo.whiteText = text;
          recordInfo.diaryDateTime = DateTime(
            year,
            month,
            day,
            now.hour,
            now.minute,
            now.second,
          );
          recordInfo.save();
        }
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
        return ContentsBox(
          padding: const EdgeInsets.all(10),
          contentsWidget: EmptyTextArea(
            backgroundColor: dialogBackgroundColor,
            topHeight: largeSpace,
            downHeight: largeSpace,
            text: '오늘의 일기를 작성해보세요.',
            icon: Icons.add,
            onTap: () =>
                provider.setSeletedRecordIconType(RecordIconTypes.editNote),
          ),
        );
      }

      return TodayDiaryDataWidget(text: whiteText);
    }

    return Column(
      children: [
        ContentsTitleText(
          text: '${dateTimeToTitle(widget.importDateTime)} 일기',
          icon: Icons.menu_book,
          sub: icons,
        ),
        SpaceHeight(height: smallSpace + 5),
        setEyeBodyWidgets(),
        SpaceHeight(height: tinySpace),
        setDiaryWidget(),
      ],
    );
  }
}

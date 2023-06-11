import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_data_widget.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
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
  });

  RecordIconTypes seletedRecordSubType;

  @override
  State<TodayDiaryWidget> createState() => _TodayDiaryWidgetState();
}

class _TodayDiaryWidgetState extends State<TodayDiaryWidget> {
  late Box<RecordBox> recordBox;
  // final List<File?> pickedImageList = [null, null];

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
    List<String?> pickedImageList = recordInfo?.diary['pickedImageList'];
    String? whiteText = recordInfo?.diary['whiteText'];

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

    List<RecordContentsTitleIcon> icons = iconClassList
        .map(
          (element) => RecordContentsTitleIcon(
            id: element.enumId,
            icon: element.icon,
            onTap: (id) {},
          ),
        )
        .toList();

    setImagePicker({
      required ImageSource source,
      required int index,
    }) {
      // 뺑글뺑글 시작
      closeDialog(context);
      ImagePicker()
          .pickImage(source: source)
          .then(
            (xFile) => setState(
              () {
                if (xFile == null) return;

                // print(File(xFile.path));
                print('start ${pickedImageList[index] = '2'}');
                // pickedImageList[index] = xFile;
                print('end');
                recordInfo?.save();

                // 뺑글뺑글 종료
              },
            ),
          )
          .catchError(
        (error) {
          // print(error);
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
      required int index,
    }) {
      return Expanded(
        child: InkWell(
          onTap: () => setImagePicker(source: source, index: index),
          child: EmptyTextVerticalArea(
            icon: icon,
            title: title,
            height: 100,
          ),
        ),
      );
    }

    onTapImage(int index) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: '사진 추가',
          height: 220,
          contents: Row(
            children: [
              contentsItem(
                source: ImageSource.camera,
                icon: Icons.add_a_photo,
                title: '사진 촬영',
                index: 0,
              ),
              SpaceWidth(width: tinySpace),
              contentsItem(
                source: ImageSource.gallery,
                icon: Icons.collections,
                title: '앨범 열기',
                index: 1,
              ),
            ],
          ),
          isEnabled: null,
          submitText: '',
          onSubmit: () {},
        ),
      );
    }

    onReoveImage(int index) {
      pickedImageList[index] = null;
    }

    setEmptyImageWidget(int index) {
      return Expanded(
        child: InkWell(
          onTap: () => onTapImage(index),
          child: DottedBorder(
            radius: const Radius.circular(30),
            color: Colors.transparent,
            strokeWidth: 1,
            child: EmptyTextVerticalArea(
              icon: Icons.add,
              title: '사진 추가',
            ),
          ),
        ),
      );
    }

    Widget setEyeBodyImageWidget(int index) {
      print('===> 요기??');
      print('===> ${pickedImageList[index]!}');
      return Expanded(
        child: Stack(
          children: [
            InkWell(
              onTap: () => onTapImage(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                  image: FileImage(File(pickedImageList[index]!)),
                ),
              ),
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
                onTap: (_) => onReoveImage(index),
              ),
            )
          ],
        ),
      );
    }

    Widget setEyeBodyWidgets() {
      print('안도나?');
      return Row(
        children: [
          pickedImageList[0] != null
              ? setEyeBodyImageWidget(0)
              : setEmptyImageWidget(0),
          SpaceWidth(width: tinySpace),
          pickedImageList[1] != null
              ? setEyeBodyImageWidget(1)
              : setEmptyImageWidget(1)
        ],
      );
    }

    onPressedOk(String text) {
      recordInfo?.diary['whiteText'] = text;
      recordInfo?.save();
    }

    Widget setDiaryWidget() {
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
          onTap: () => context
              .read<RecordIconTypeProvider>()
              .setSeletedRecordIconType(RecordIconTypes.editNote),
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
          SpaceHeight(height: smallSpace),
          setEyeBodyWidgets(),
          SpaceHeight(height: smallSpace),
          setDiaryWidget(),
        ],
      ),
    );
  }
}

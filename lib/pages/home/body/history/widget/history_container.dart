import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/route/fade_page_route.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HistoryContainer extends StatelessWidget {
  HistoryContainer({super.key, required this.recordInfo});

  RecordBox recordInfo;

  @override
  Widget build(BuildContext context) {
    bool isAd = recordInfo.createDateTime.year == 1000;

    return isAd
        ? NativeAdContainer()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HistoryHeader(
                recordInfo: recordInfo,
                createDateTime: recordInfo.createDateTime,
                weight: recordInfo.weight,
                emotion: recordInfo.emotion,
              ),
              HistoryPicture(
                leftFile: recordInfo.leftFile,
                rightFile: recordInfo.rightFile,
                bottomFile: recordInfo.bottomFile,
              ),
              HistoryTodo(
                actions: recordInfo.actions,
                createDateTime: recordInfo.createDateTime,
              ),
              HistoryDiary(
                whiteText: recordInfo.whiteText,
                diaryDateTime: recordInfo.diaryDateTime,
              ),
            ],
          );
  }
}

class HistoryHeader extends StatelessWidget {
  HistoryHeader({
    super.key,
    required this.recordInfo,
    required this.createDateTime,
    required this.weight,
    required this.emotion,
  });

  RecordBox? recordInfo;
  DateTime createDateTime;
  double? weight;
  String? emotion;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String formatDateTime = dateTimeFormatter(
      format: 'M월 d일 (E)',
      dateTime: createDateTime,
    );

    onTapEdit() {
      context.read<ImportDateTimeProvider>().setImportDateTime(createDateTime);
      context.read<TitleDateTimeProvider>().setTitleDateTime(createDateTime);
      context
          .read<BottomNavigationProvider>()
          .setBottomNavigation(enumId: BottomNavigationEnum.record);

      closeDialog(context);
    }

    onTapPartialDelete() {
      //
    }

    onTapRemove() {
      recordRepository.recordBox.delete(getDateTimeToInt(createDateTime));

      closeDialog(context);
    }

    onTapMore() {
      showModalBottomSheet(
        context: context,
        builder: (context) => CommonBottomSheet(
          title: formatDateTime,
          height: 200,
          contents: Row(
            children: [
              ExpandedButtonVerti(
                mainColor: themeColor,
                icon: Icons.edit,
                title: '기록 수정',
                onTap: onTapEdit,
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonVerti(
                mainColor: Colors.red,
                icon: Icons.delete_sweep,
                title: '부분 삭제',
                onTap: onTapPartialDelete,
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonVerti(
                mainColor: Colors.red,
                icon: Icons.delete_forever,
                title: '전체 삭제',
                onTap: onTapRemove,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            emotion != null
                ? Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svgs/$emotion.svg'),
                        SpaceWidth(width: smallSpace),
                      ],
                    ),
                  )
                : const EmptyArea(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonText(
                        text: formatDateTime,
                        size: 11,
                        isBold: true,
                      ),
                      Spacer(),
                      CommonIcon(
                        icon: Icons.more_vert_rounded,
                        size: 16,
                        onTap: onTapMore,
                      )
                    ],
                  ),
                  SpaceHeight(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonText(
                        text: '${weight ?? '-'}kg',
                        size: 17,
                      ),
                      Spacer(),
                      CommonText(
                        text: 'BMI ${bmi(tall: user.tall, weight: weight)}',
                        size: 9,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        SpaceHeight(height: 15),
      ],
    );
  }
}

class HistoryPicture extends StatelessWidget {
  HistoryPicture({
    super.key,
    required this.leftFile,
    required this.rightFile,
    required this.bottomFile,
  });

  Uint8List? leftFile, rightFile, bottomFile;

  @override
  Widget build(BuildContext context) {
    List<Uint8List?> uint8List = [leftFile, rightFile, bottomFile];
    List<Uint8List> fileList = [];

    for (var i = 0; i < uint8List.length; i++) {
      Uint8List? data = uint8List[i];

      if (data != null) {
        fileList.add(data);
      }
    }

    onTapPicture(Uint8List binaryData) {
      Navigator.push(
        context,
        FadePageRoute(
          page: ImagePullSizePage(binaryData: binaryData),
        ),
      );
    }

    image(Uint8List file, double height) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onTapPicture(file),
          child: DefaultImage(
            unit8List: file,
            height: height,
          ),
        ),
      );
    }

    imageList() {
      switch (fileList.length) {
        case 1:
          return Row(children: [image(fileList[0], 300)]);

        case 2:
          return Row(
            children: [
              image(fileList[0], 150),
              SpaceWidth(width: tinySpace),
              image(fileList[1], 150)
            ],
          );
        case 3:
          return Column(
            children: [
              Row(
                children: [
                  image(fileList[0], 150),
                  SpaceWidth(width: tinySpace),
                  image(fileList[1], 150)
                ],
              ),
              SpaceHeight(height: tinySpace),
              Row(children: [image(fileList[2], 150)])
            ],
          );
        default:
          return const EmptyArea();
      }
    }

    return fileList.isNotEmpty
        ? Column(children: [imageList(), SpaceHeight(height: 15)])
        : const EmptyArea();
  }
}

class HistoryTodo extends StatelessWidget {
  HistoryTodo({
    super.key,
    required this.actions,
    required this.createDateTime,
  });

  List<Map<String, dynamic>>? actions;
  DateTime createDateTime;

  @override
  Widget build(BuildContext context) {
    renderSvg(String path) => SvgPicture.asset('assets/svgs/$path.svg');

    Map<String, SvgPicture> planTypeSvgs = {
      PlanTypeEnum.diet.toString(): renderSvg('check-diet'),
      PlanTypeEnum.exercise.toString(): renderSvg('check-exercise'),
      PlanTypeEnum.lifestyle.toString(): renderSvg('check-life'),
    };

    onIcon(String type, bool? isRecord, String title) {
      if (isRecord == true) {
        return Icon(
          categoryIcons[title],
          color: categoryColors[type],
          size: 15,
        );
      }

      return planTypeSvgs[type];
    }

    final todoResultList = actions
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(createDateTime),
        )
        .toList();

    todoResultList?.sort((A, B) {
      int itemA = categoryOrders[A['title']] ?? 7;
      int itemB = categoryOrders[B['title']] ?? 7;

      return itemA.compareTo(itemB);
    });

    todoResultList?.sort(
        (a, b) => planOrder[a['type']]!.compareTo(planOrder[b['type']]!));

    final todoWidgetList = todoResultList
        ?.map((data) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: onIcon(data['type'], data['isRecord'],
                                data['title']) ??
                            const EmptyArea(),
                      ),
                    ),
                    SpaceWidth(width: smallSpace),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data['name'],
                        style: const TextStyle(fontSize: 14, color: themeColor),
                      ),
                    ),
                  ],
                ),
                SpaceHeight(height: 10),
              ],
            ))
        .toList();

    return Column(children: todoWidgetList ?? []);
  }
}

class HistoryDiary extends StatelessWidget {
  HistoryDiary({
    super.key,
    required this.whiteText,
    required this.diaryDateTime,
  });

  String? whiteText;
  DateTime? diaryDateTime;

  @override
  Widget build(BuildContext context) {
    return whiteText != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(whiteText!,
                  style: const TextStyle(
                    color: themeColor,
                    fontSize: 13,
                  )),
              SpaceHeight(height: tinySpace),
              Text(
                timeToString(diaryDateTime),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          )
        : const EmptyArea();
  }
}

class NativeAdContainer extends StatefulWidget {
  NativeAdContainer({super.key});

  @override
  State<NativeAdContainer> createState() => _NativeAdContainerState();
}

class _NativeAdContainerState extends State<NativeAdContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CommonText(text: '광고', size: 12, isBold: true),
            CommonText(
              text: '체중 메이트의 발전을 위해 광고가 노출됩니다.',
              size: 10,
              color: Colors.grey,
            ),
          ],
        ),
        SpaceHeight(height: smallSpace),
        NativeWidget(padding: 0, height: 340)
      ],
    );
  }
}

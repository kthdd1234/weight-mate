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
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HistoryContainer extends StatelessWidget {
  HistoryContainer({
    super.key,
    required this.recordInfo,
    required this.isRemoveMode,
  });

  RecordBox recordInfo;
  bool isRemoveMode;

  @override
  Widget build(BuildContext context) {
    bool isAd = recordInfo.createDateTime.year == 1000;
    int recordKey = getDateTimeToInt(recordInfo.createDateTime);
    String formatDateTime = dateTimeFormatter(
      format: 'M월 d일 (E)',
      dateTime: recordInfo.createDateTime,
    );

    onTapEdit() {
      context
          .read<ImportDateTimeProvider>()
          .setImportDateTime(recordInfo.createDateTime);
      context
          .read<TitleDateTimeProvider>()
          .setTitleDateTime(recordInfo.createDateTime);
      context
          .read<BottomNavigationProvider>()
          .setBottomNavigation(enumId: BottomNavigationEnum.record);

      closeDialog(context);
    }

    onTapRemove() async {
      recordRepository.recordBox.delete(recordKey);
      closeDialog(context);
    }

    onTapPartialDelete() {
      closeDialog(context);
      Navigator.pushNamed(
        context,
        '/partial-delete-page',
        arguments: recordKey,
      );
    }

    onTapMore() {
      if (isRemoveMode == false) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return CommonBottomSheet(
              title: formatDateTime,
              height: 200,
              contents: MoreButtonList(
                onTapEdit: onTapEdit,
                onTapPartialDelete: onTapPartialDelete,
                onTapRemove: onTapRemove,
              ),
            );
          },
        );
      }
    }

    return isAd
        ? NativeAdContainer()
        : GestureDetector(
            onTap: onTapMore,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoryHeader(
                  formatDateTime: formatDateTime,
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                  onTapMore: onTapMore,
                ),
                HistoryPicture(
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                ),
                HistoryTodo(
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                ),
                HistoryDiary(
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                ),
              ],
            ),
          );
  }
}

class HistoryHeader extends StatelessWidget {
  HistoryHeader({
    super.key,
    required this.formatDateTime,
    required this.recordInfo,
    required this.isRemoveMode,
    required this.onTapMore,
  });

  String formatDateTime;
  RecordBox? recordInfo;
  bool isRemoveMode;
  Function() onTapMore;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;

    bmiValue() {
      return 'BMI ${bmi(tall: user.tall, weight: recordInfo?.weight)}';
    }

    onRemoveEmotion() {
      recordInfo?.emotion = null;
      recordInfo?.save();
    }

    onTapRemoveWegiht() {
      recordInfo?.weight = null;
      recordInfo?.weightDateTime = null;
      recordInfo?.save();
    }

    return Column(
      children: [
        Row(
          children: [
            recordInfo?.emotion != null
                ? Expanded(
                    flex: 0,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                'assets/svgs/${recordInfo?.emotion}.svg'),
                            SpaceWidth(width: smallSpace)
                          ],
                        ),
                        isRemoveMode
                            ? RemoveIcon(onTap: onRemoveEmotion)
                            : const EmptyArea()
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
                      CommonText(text: formatDateTime, size: 11, isBold: true),
                      const Spacer(),
                      isRemoveMode
                          ? const EmptyArea()
                          : InkWell(
                              onTap: onTapMore,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: CommonIcon(
                                  icon: Icons.more_vert_rounded,
                                  size: 16,
                                  onTap: onTapMore,
                                ),
                              ),
                            )
                    ],
                  ),
                  SpaceHeight(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CommonText(
                              text: '${recordInfo?.weight ?? '-'}kg', size: 17),
                          isRemoveMode && recordInfo?.weight != null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: RemoveIcon(onTap: onTapRemoveWegiht))
                              : const EmptyArea()
                        ],
                      ),
                      CommonText(text: bmiValue(), size: 9),
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

class RemoveIcon extends StatelessWidget {
  RemoveIcon({
    super.key,
    required this.onTap,
  });

  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CommonIcon(
      icon: Icons.remove_circle,
      size: 15,
      color: Colors.red,
      onTap: onTap,
    );
  }
}

class MoreButtonList extends StatelessWidget {
  MoreButtonList({
    super.key,
    required this.onTapEdit,
    required this.onTapPartialDelete,
    required this.onTapRemove,
  });

  Function() onTapEdit, onTapPartialDelete, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          title: '모두 삭제',
          onTap: onTapRemove,
        ),
      ],
    );
  }
}

class HistoryPicture extends StatelessWidget {
  HistoryPicture({
    super.key,
    required this.recordInfo,
    required this.isRemoveMode,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  @override
  Widget build(BuildContext context) {
    List<historyImageClass> uint8List = [
      historyImageClass(pos: 'left', unit8List: recordInfo?.leftFile),
      historyImageClass(pos: 'right', unit8List: recordInfo?.rightFile),
      historyImageClass(pos: 'bottom', unit8List: recordInfo?.bottomFile),
    ];
    List<historyImageClass> fileList = [];

    for (var i = 0; i < uint8List.length; i++) {
      historyImageClass data = uint8List[i];

      if (data.unit8List != null) {
        fileList.add(data);
      }
    }

    onTapPicture(Uint8List binaryData) {
      if (isRemoveMode == false) {
        Navigator.push(
          context,
          FadePageRoute(page: ImagePullSizePage(binaryData: binaryData)),
        );
      }
    }

    image(historyImageClass data, double height) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onTapPicture(data.unit8List!),
          child: Stack(
            children: [
              DefaultImage(
                unit8List: data.unit8List!,
                height: height,
              ),
              isRemoveMode
                  ? Positioned(
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: RemoveIcon(
                          onTap: () {
                            if (data.pos == 'left') {
                              recordInfo?.leftFile = null;
                            } else if (data.pos == 'right') {
                              recordInfo?.rightFile = null;
                            } else if (data.pos == 'bottom') {
                              recordInfo?.bottomFile = null;
                            }

                            recordInfo?.save();
                          },
                        ),
                      ),
                    )
                  : const EmptyArea()
            ],
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
    required this.isRemoveMode,
    required this.recordInfo,
  });

  bool isRemoveMode;
  RecordBox recordInfo;

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

    final todoResultList = recordInfo.actions
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(recordInfo.createDateTime),
        )
        .toList();

    todoResultList?.sort((A, B) {
      int itemA = categoryOrders[A['title']] ?? 7;
      int itemB = categoryOrders[B['title']] ?? 7;

      return itemA.compareTo(itemB);
    });

    todoResultList?.sort(
      (a, b) => planOrder[a['type']]!.compareTo(planOrder[b['type']]!),
    );

    onTapRemoveAction(String targetId) {
      int? index = recordInfo.actions?.indexWhere(
        (action) => action['id'] == targetId,
      );

      if (index != null) {
        recordInfo.actions?.removeAt(index);
        recordInfo.save();
      }
    }

    final todoWidgetList = todoResultList
        ?.map((data) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isRemoveMode
                        ? Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2, right: 7),
                              child: RemoveIcon(
                                  onTap: () => onTapRemoveAction(data['id'])),
                            ),
                          )
                        : const EmptyArea(),
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
    required this.isRemoveMode,
    required this.recordInfo,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  @override
  Widget build(BuildContext context) {
    onTapRemoveDiary() {
      recordInfo?.diaryDateTime = null;
      recordInfo?.whiteText = null;

      recordInfo?.save();
    }

    return recordInfo?.whiteText != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      recordInfo!.whiteText!,
                      style: const TextStyle(
                        color: themeColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  isRemoveMode
                      ? Padding(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: RemoveIcon(onTap: onTapRemoveDiary),
                        )
                      : const EmptyArea(),
                ],
              ),
              SpaceHeight(height: tinySpace),
              Text(
                timeToString(recordInfo?.diaryDateTime),
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
  NativeAd? nativeAd;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    final adsState = Provider.of<AdsProvider>(context).adsState;

    onLoaded() {
      setState(() => isLoaded = true);
    }

    onAdFailedToLoad() {
      setState(() {
        isLoaded = true;
        nativeAd = null;
      });
    }

    nativeAd = loadNativeAd(
      adUnitId: adsState.nativeAdUnitId,
      onAdLoaded: onLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
    super.didChangeDependencies();
  }

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
        isLoaded
            ? NativeWidget(padding: 0, height: 340, nativeAd: nativeAd)
            : SizedBox(
                height: 340,
                child: NativeAdLoading(
                  text: '',
                  color: Colors.transparent,
                ),
              )
      ],
    );
  }
}

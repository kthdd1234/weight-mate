import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
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

String fPicture = FILITER.picture.toString();
String fDiet = FILITER.diet.toString();
String fExercise = FILITER.exercise.toString();
String fLife = FILITER.lifeStyle.toString();
String fDiary = FILITER.diary.toString();
String fDiet_2 = FILITER.diet_2.toString();
String fExercise_2 = FILITER.exercise_2.toString();

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
    String locale = context.locale.toString();
    DateTime createDateTime = recordInfo.createDateTime;
    bool isAd = createDateTime.year == 1000;
    int recordKey = getDateTimeToInt(createDateTime);
    String formatDateTime = mde(locale: locale, dateTime: createDateTime);

    /** 필터 */
    UserBox user = userRepository.user;
    List<String> historyDisplayList = user.historyDisplayList ?? [];
    bool isPicture = historyDisplayList.contains(fPicture);
    bool isDiary = historyDisplayList.contains(fDiary);

    onTapEdit() {
      context.read<ImportDateTimeProvider>().setImportDateTime(createDateTime);
      context.read<TitleDateTimeProvider>().setTitleDateTime(createDateTime);
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
                  locale: locale,
                  createDateTime: createDateTime,
                  formatDateTime: formatDateTime,
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                  onTapMore: onTapMore,
                ),
                isPicture
                    ? HistoryPicture(
                        isRemoveMode: isRemoveMode,
                        recordInfo: recordInfo,
                      )
                    : const EmptyArea(),
                HistoryTodo(
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                ),
                isDiary
                    ? HistoryDiary(
                        isRemoveMode: isRemoveMode,
                        recordInfo: recordInfo,
                      )
                    : const EmptyArea(),
              ],
            ),
          );
  }
}

class HistoryHeader extends StatelessWidget {
  HistoryHeader({
    super.key,
    required this.locale,
    required this.createDateTime,
    required this.formatDateTime,
    required this.recordInfo,
    required this.isRemoveMode,
    required this.onTapMore,
  });

  String locale;
  DateTime createDateTime;
  String formatDateTime;
  RecordBox? recordInfo;
  bool isRemoveMode;
  Function() onTapMore;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String> historyDisplayList = user.historyDisplayList ?? [];
    bool isWeight = historyDisplayList.contains(fWeight);
    bool isDiary = historyDisplayList.contains(fDiary);

    bmiValue() {
      return 'BMI ${bmi(
        tall: user.tall,
        weight: recordInfo?.weight,
        tallUnit: user.tallUnit,
        weightUnit: user.weightUnit,
      )}';
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

    return Row(
      children: [
        recordInfo?.emotion != null && isDiary
            ? Expanded(
                flex: 0,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/svgs/${recordInfo?.emotion}.svg',
                      ),
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
                  CommonText(
                    text: isWeight
                        ? formatDateTime
                        : md(locale: locale, dateTime: createDateTime),
                    size: 11,
                    isBold: true,
                    isNotTr: true,
                  ),
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
                        isNotTr: true,
                        text: isWeight
                            ? '${recordInfo?.weight ?? '-'}${user.weightUnit}'
                            : e(locale: locale, dateTime: createDateTime),
                        size: isWeight ? 17 : 12,
                      ),
                      isRemoveMode && recordInfo?.weight != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: RemoveIcon(onTap: onTapRemoveWegiht))
                          : const EmptyArea()
                    ],
                  ),
                  CommonText(
                      text: isWeight ? bmiValue() : '', size: 9, isNotTr: true),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class RemoveIcon extends StatelessWidget {
  RemoveIcon({super.key, required this.onTap});

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
      historyImageClass(pos: 'top', unit8List: recordInfo?.topFile),
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
                            } else if (data.pos == 'top') {
                              recordInfo?.topFile = null;
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
              SpaceWidth(width: 7),
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
        case 4:
          return Column(
            children: [
              Row(children: [
                image(fileList[0], 150),
                SpaceWidth(width: tinySpace),
                image(fileList[1], 150)
              ]),
              SpaceHeight(height: tinySpace),
              Row(children: [
                image(fileList[2], 150),
                SpaceWidth(width: tinySpace),
                image(fileList[3], 150),
              ])
            ],
          );
        default:
          return const EmptyArea();
      }
    }

    return fileList.isNotEmpty
        ? Column(children: [SpaceHeight(height: 10), imageList()])
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
    UserBox user = userRepository.user;
    List<String> historyDisplayList = user.historyDisplayList ?? [];

    bool isContainDietRecord = historyDisplayList.contains(fDiet);
    bool isContainExerciseRecord = historyDisplayList.contains(fExercise);
    bool isContainDietGoal = historyDisplayList.contains(fDiet_2);
    bool isContainExerciseGoal = historyDisplayList.contains(fExercise_2);
    bool isContainLife = historyDisplayList.contains(fLife);

    onIcon(String type, bool? isRecord, String title) {
      MaterialColor color = categoryColors[type]!;

      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: CommonIcon(
          icon: isRecord == true ? categoryIcons[title]! : Icons.check_rounded,
          size: 11,
          color: color.shade300,
          bgColor: color.shade50,
        ),
      );
    }

    final todoDisplayList = recordInfo.actions?.where((action) {
      String planType = action['type'];

      bool isTypeDietRecord = planType == eDiet && action['isRecord'] == true;
      bool isTypeExerciseRecord =
          planType == eExercise && action['isRecord'] == true;
      bool isTypeDietGoal = planType == eDiet && action['isRecord'] == null;
      bool isTypeExerciseGoal =
          planType == eExercise && action['isRecord'] == null;
      bool isTypeLife = planType == eLife;

      if (isTypeDietRecord && isContainDietRecord) {
        return true;
      } else if (isTypeExerciseRecord && isContainExerciseRecord) {
        return true;
      } else if (isTypeDietGoal && isContainDietGoal) {
        return true;
      } else if (isTypeExerciseGoal && isContainExerciseGoal) {
        return true;
      } else if (isTypeLife && isContainLife) {
        return true;
      }

      return false;
    });

    final todoResultList = todoDisplayList
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(recordInfo.createDateTime),
        )
        .toList();

    todoResultList?.sort((a, b) {
      DateTime dateTime1 =
          a['dietExerciseRecordDateTime'] ?? DateTime(3000, 1, 1);
      DateTime dateTime2 =
          b['dietExerciseRecordDateTime'] ?? DateTime(3000, 1, 2);

      return dateTime1.compareTo(dateTime2);
    });

    todoResultList?.sort(
      (A, B) {
        int itemA = A['isRecord'] == true ? 0 : 1;
        int itemB = B['isRecord'] == true ? 0 : 1;

        return itemA.compareTo(itemB);
      },
    );

    todoResultList?.sort((A, B) {
      int order1 = planOrder[A['type']]!;
      int order2 = planOrder[B['type']]!;

      return order1.compareTo(order2);
    });

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
                SpaceHeight(height: 10),
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
                      child:
                          onIcon(data['type'], data['isRecord'], data['title']),
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
              ],
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(children: todoWidgetList ?? []),
    );
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
              SpaceHeight(height: 10),
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
                hm(
                  locale: context.locale.toString(),
                  dateTime: recordInfo?.diaryDateTime ?? DateTime.now(),
                ),
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
  bool isNotAdShow = false;

  @override
  void didChangeDependencies() {
    final adsState = Provider.of<AdsProvider>(context).adsState;

    checkHideAd() async {
      bool isHide = await isHideAd();

      if (isHide == true) {
        setState(() => isNotAdShow = isHide);
      } else if (isHide == false) {
        nativeAd = loadNativeAd(
          adUnitId: adsState.nativeAdUnitId,
          onAdLoaded: () {
            setState(() => isLoaded = true);
          },
          onAdFailedToLoad: () {
            setState(() {
              isLoaded = false;
              nativeAd = null;
            });
          },
        );
      }
    }

    checkHideAd();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isNotAdShow) {
      return const Row(children: []);
    }

    return Column(
      children: [
        CommonText(text: '광고', size: 12, isBold: true),
        SpaceHeight(height: smallSpace),
        isLoaded
            ? NativeWidget(padding: 0, height: 340, nativeAd: nativeAd)
            : SizedBox(
                height: 340,
                child: LoadingDialog(text: '', color: Colors.transparent),
              )
      ],
    );
  }
}

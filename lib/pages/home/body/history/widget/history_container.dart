import 'dart:developer';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/popup/LoadingPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_diary.dart';
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
    String locale = context.locale.toString();
    DateTime createDateTime = recordInfo.createDateTime;
    bool isAd = createDateTime.year == 1000;
    int recordKey = getDateTimeToInt(createDateTime);
    String formatDateTime = mde(locale: locale, dateTime: createDateTime);

    /** 필터 */
    UserBox user = userRepository.user;
    List<String> historyDisplayList = user.historyDisplayList ?? [];
    bool isWeight = historyDisplayList.contains(fWeight);
    bool isPicture = historyDisplayList.contains(fPicture);
    bool isDiaryText = historyDisplayList.contains(fDiary);
    bool isDiaryHashTag = historyDisplayList.contains(fDiary_2);
    bool isDietRecord = historyDisplayList.contains(fDiet);
    bool isExerciseRecord = historyDisplayList.contains(fExercise);
    bool isDietGoal = historyDisplayList.contains(fDiet_2);
    bool isExerciseGoal = historyDisplayList.contains(fExercise_2);
    bool isLife = historyDisplayList.contains(fLife);

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
                  recordInfo: recordInfo,
                  isRemoveMode: isRemoveMode,
                  isWeight: isWeight,
                  isDiary: isDiaryText,
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
                  isDietRecord: isDietRecord,
                  isDietGoal: isDietGoal,
                  isExerciseRecord: isExerciseRecord,
                  isExerciseGoal: isExerciseGoal,
                  isLife: isLife,
                ),
                isDiaryText
                    ? HistoryDiaryText(
                        isRemoveMode: isRemoveMode,
                        recordInfo: recordInfo,
                      )
                    : const EmptyArea(),
                isDiaryHashTag
                    ? HistoryHashTag(
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
    required this.recordInfo,
    required this.isRemoveMode,
    required this.isWeight,
    required this.isDiary,
    this.onTapMore,
  });

  RecordBox? recordInfo;
  bool isRemoveMode, isWeight, isDiary;
  Function()? onTapMore;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    UserBox user = userRepository.user;
    DateTime createDateTime = recordInfo?.createDateTime ?? DateTime.now();
    String mdeDt = onTapMore != null
        ? mde(locale: locale, dateTime: createDateTime)
        : ymd(locale: locale, dateTime: createDateTime);
    String mdDt = onTapMore != null
        ? md(locale: locale, dateTime: createDateTime)
        : ymd(locale: locale, dateTime: createDateTime);

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
                    text: isWeight ? mdeDt : mdDt,
                    size: 11,
                    isBold: true,
                    isNotTr: true,
                    color: themeColor,
                  ),
                  const Spacer(),
                  isRemoveMode
                      ? const EmptyArea()
                      : onTapMore != null
                          ? InkWell(
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
                          : const EmptyArea()
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
                    text: isWeight ? bmiValue() : '',
                    size: 9,
                    isNotTr: true,
                  ),
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
          mainColor: textColor,
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
    required this.isDietRecord,
    required this.isExerciseRecord,
    required this.isDietGoal,
    required this.isExerciseGoal,
    required this.isLife,
  });

  RecordBox recordInfo;
  bool isRemoveMode,
      isDietRecord,
      isExerciseRecord,
      isDietGoal,
      isExerciseGoal,
      isLife;

  @override
  Widget build(BuildContext context) {
    List<String>? dietRecordOrderList = recordInfo.dietRecordOrderList;
    List<String>? exerciseRecordOrderList = recordInfo.exerciseRecordOrderList;

    onIcon(String type, bool? isRecord, String title) {
      MaterialColor color = categoryColors[type]!;

      return CommonIcon(
        icon: isRecord == true ? categoryIcons[title]! : Icons.check_rounded,
        size: 11,
        color: color.shade300,
        bgColor: color.shade50,
      );
    }

    onTapRemoveAction(Map<String, dynamic> selectedAction) async {
      String actionId = selectedAction['id'];
      bool isRecord = selectedAction['isRecord'] == true;
      int? index = recordInfo.actions?.indexWhere(
        (action) => action['id'] == actionId,
      );

      if (index != null) {
        recordInfo.actions?.removeAt(index);
      }

      if (selectedAction['type'] == eDiet && isRecord) {
        dietRecordOrderList?.remove(actionId);
      } else if (selectedAction['type'] == eExercise && isRecord) {
        exerciseRecordOrderList?.remove(actionId);
      }

      await recordInfo.save();
    }

    Iterable<Map<String, dynamic>>? todoDisplayList =
        recordInfo.actions?.where((action) {
      String planType = action['type'];

      bool isTypeDietRecord = planType == eDiet && action['isRecord'] == true;
      bool isTypeExerciseRecord =
          planType == eExercise && action['isRecord'] == true;
      bool isTypeDietGoal = planType == eDiet && action['isRecord'] == null;
      bool isTypeExerciseGoal =
          planType == eExercise && action['isRecord'] == null;
      bool isTypeLife = planType == eLife;

      if (isTypeDietRecord && isDietRecord) {
        return true;
      } else if (isTypeExerciseRecord && isExerciseRecord) {
        return true;
      } else if (isTypeDietGoal && isDietGoal) {
        return true;
      } else if (isTypeExerciseGoal && isExerciseGoal) {
        return true;
      } else if (isTypeLife && isLife) {
        return true;
      }

      return false;
    });

    // 1
    List<Map<String, dynamic>>? todoResultList = todoDisplayList
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(recordInfo.createDateTime),
        )
        .toList();

    // 2
    List<Map<String, dynamic>> tempDietRecordOrderList = [];
    List<Map<String, dynamic>> tempExerciseRecordOrderList = [];

    todoResultList = todoResultList?.where((action) {
      bool isTypeDietRecord =
          action['type'] == eDiet && action['isRecord'] == true;
      bool isTypeExerciseRecord =
          action['type'] == eExercise && action['isRecord'] == true;

      if (isTypeDietRecord) {
        tempDietRecordOrderList.add(action);
        return false;
      } else if (isTypeExerciseRecord) {
        tempExerciseRecordOrderList.add(action);
        return false;
      }

      return true;
    }).toList();

    tempDietRecordOrderList = onOrderList(
          actions: tempDietRecordOrderList,
          type: eDiet,
          dietRecordOrderList: dietRecordOrderList,
        ) ??
        [];
    tempExerciseRecordOrderList = onOrderList(
          actions: tempExerciseRecordOrderList,
          type: eExercise,
          exerciseRecordOrderList: exerciseRecordOrderList,
        ) ??
        [];

    List<Map<String, dynamic>> combineRecordOrderList = [
      ...tempDietRecordOrderList,
      ...tempExerciseRecordOrderList
    ];
    todoResultList = [...combineRecordOrderList, ...todoResultList ?? []];

    // 3
    todoResultList.sort((A, B) {
      int order1 = planOrder[A['type']]!;
      int order2 = planOrder[B['type']]!;

      return order1.compareTo(order2);
    });

    return todoResultList.isNotEmpty
        ? Column(
            children: todoResultList
                .map(
                  (todo) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        isRemoveMode
                            ? Expanded(
                                flex: 0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, right: 7),
                                  child: RemoveIcon(
                                      onTap: () => onTapRemoveAction(todo)),
                                ),
                              )
                            : const EmptyArea(),
                        Expanded(
                          flex: 0,
                          child: onIcon(
                              todo['type'], todo['isRecord'], todo['title']),
                        ),
                        SpaceWidth(width: smallSpace),
                        Expanded(
                          flex: 1,
                          child: Text(
                            todo['name'],
                            style:
                                const TextStyle(fontSize: 14, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        : const EmptyArea();
  }
}

class HistoryDiaryText extends StatelessWidget {
  HistoryDiaryText({
    super.key,
    required this.isRemoveMode,
    required this.recordInfo,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  onTapRemoveDiary() async {
    recordInfo?.diaryDateTime = null;
    recordInfo?.whiteText = null;

    await recordInfo?.save();
  }

  @override
  Widget build(BuildContext context) {
    return recordInfo?.whiteText != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        recordInfo!.whiteText!,
                        style: const TextStyle(
                          color: textColor,
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
              ),
              SpaceHeight(height: tinySpace),
              Text(
                hm(
                  locale: context.locale.toString(),
                  dateTime: recordInfo?.diaryDateTime ?? DateTime.now(),
                ),
                style: TextStyle(color: grey.original, fontSize: 11),
              ),
            ],
          )
        : const EmptyArea();
  }
}

class HistoryHashTag extends StatelessWidget {
  HistoryHashTag({
    super.key,
    required this.isRemoveMode,
    required this.recordInfo,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  onTapRemoveHashTag() async {
    recordInfo?.recordHashTagList = [];
    await recordInfo?.save();
  }

  @override
  Widget build(BuildContext context) {
    List<HashTagClass> hashTagClassList =
        getHashTagClassList(recordInfo?.recordHashTagList);
    bool isShow = hashTagClassList.isNotEmpty;

    return isShow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiaryHashTag(
                hashTagClassList: hashTagClassList,
                paddingTop: 10,
              ),
              isRemoveMode
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RemoveIcon(onTap: onTapRemoveHashTag),
                    )
                  : const EmptyArea(),
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
                child: LoadingPopup(text: '', color: Colors.transparent),
              )
      ],
    );
  }
}

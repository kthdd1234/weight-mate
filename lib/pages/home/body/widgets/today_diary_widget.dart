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
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/icon_text.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_data_widget.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_app_weight_management/components/route/fade_page_route.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:provider/provider.dart';

import '../../../../provider/ads_provider.dart';

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

  RewardedInterstitialAd? rewardedInterstitialAd;
  bool rewardedInterstitialAdIsLoaded = false;

  @override
  void initState() {
    recordBox = Hive.box<RecordBox>('recordBox');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createRewardedInterstitialAd();
  }

  void createRewardedInterstitialAd() async {
    AdsService adsState =
        Provider.of<AdsProvider>(context, listen: false).adsState;

    await adsState.initialization.then(
      (value) {
        RewardedInterstitialAd.load(
          adUnitId: adsState.rewardedInterstitialAdUnitId,
          request: const AdRequest(),
          rewardedInterstitialAdLoadCallback:
              RewardedInterstitialAdLoadCallback(
            onAdLoaded: (RewardedInterstitialAd ad) => setState(() {
              rewardedInterstitialAd = ad;
              rewardedInterstitialAdIsLoaded = true;
            }),
            onAdFailedToLoad: (LoadAdError error) {
              log('LoadAdError $error');

              setState(() {
                rewardedInterstitialAd = null;
                rewardedInterstitialAdIsLoaded = false;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    RecordBox? recordInfo =
        recordBox.get(getDateTimeToInt(widget.importDateTime));
    Uint8List? leftFile = recordInfo?.leftFile;
    Uint8List? rightFile = recordInfo?.rightFile;
    Map<String, Uint8List?> fileInfo = {'left': leftFile, 'right': rightFile};
    RecordIconTypeProvider provider = context.read<RecordIconTypeProvider>();

    List<RecordIconClass> iconClassList = [
      RecordIconClass(
        enumId: RecordIconTypes.eyeBodyCollections,
        icon: Icons.apps_rounded,
      ),
    ];

    List<RecordContentsTitleIcon> icons = iconClassList
        .map(
          (element) => RecordContentsTitleIcon(
            id: element.enumId,
            icon: element.icon,
            onTap: (id) {
              switch (id) {
                case RecordIconTypes.eyeBodyCollections:
                  Navigator.pushNamed(context, '/image-collections-page');

                  break;
                case RecordIconTypes.eyeBodySlideshow:
                  break;
                default:
              }
            },
          ),
        )
        .toList();

    setPickedImage({required String pos, required XFile? xFile}) async {
      if (xFile == null) return;

      Uint8List pickedImage = await File(xFile.path).readAsBytes();
      int year = widget.importDateTime.year;
      int month = widget.importDateTime.month;
      int day = widget.importDateTime.day;
      DateTime now = DateTime.now();
      DateTime diaryDateTime = DateTime(year, month, day, now.hour, now.minute);

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
    }

    _showRewardedInterstitialAd({
      required String pos,
      required XFile xFileData,
    }) async {
      if (rewardedInterstitialAdIsLoaded) {
        rewardedInterstitialAd!.fullScreenContentCallback =
            FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            log('onAdDismissed!');

            ad.dispose();
            createRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            log("onAdFailed => $error");

            ad.dispose();
            createRewardedInterstitialAd();
          },
        );

        await rewardedInterstitialAd!.show(
          onUserEarnedReward: (ad, reward) {
            log('Done!');
          },
        );
      }

      setPickedImage(pos: pos, xFile: xFileData);
    }

    setImagePicker({
      required ImageSource source,
      required String pos,
    }) async {
      XFile? xFileData;

      closeDialog(context);
      widget.setActiveCamera(true);

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

    onTapImage(String pos) {
      final isFilePath = fileInfo[pos] != null;

      onShowImagePicker(ImageSource source) async {
        XFile? xFileData = await setImagePicker(
          source: source,
          pos: pos,
        );

        if (xFileData != null) {
          await Future.delayed(const Duration(milliseconds: 500));
          await _showRewardedInterstitialAd(pos: pos, xFileData: xFileData);
        }
      }

      onNavigatorPage() async {
        closeDialog(context);
        await Navigator.pushNamed(context, '/image-collections-page');
      }

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
                          onTap: () => Navigator.push(
                            context,
                            FadePageRoute(
                              page: ImagePullSizePage(
                                binaryData: fileInfo[pos]!,
                              ),
                            ),
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
                    icon: Icons.add_a_photo,
                    title: '사진 촬영',
                    onTap: () => onShowImagePicker(ImageSource.camera),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonVerti(
                    icon: Icons.collections,
                    title: '앨범 열기',
                    onTap: () => onShowImagePicker(ImageSource.gallery),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonVerti(
                    icon: Icons.apps_rounded,
                    title: '사진 보기',
                    onTap: onNavigatorPage,
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
            child: EmptyTextVerticalArea(
              icon: Icons.add,
              title: '사진 추가',
              backgroundColor: dialogBackgroundColor,
              height: 170,
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
        return EmptyTextArea(
          backgroundColor: dialogBackgroundColor,
          topHeight: largeSpace,
          downHeight: largeSpace,
          text: '메모를 작성해보세요.',
          icon: Icons.add,
          onTap: () =>
              provider.setSeletedRecordIconType(RecordIconTypes.editNote),
        );
      }

      return TodayDiaryDataWidget(
        provider: provider,
        text: whiteText,
        recordInfo: recordInfo,
      );
    }

    return Column(
      children: [
        ContentsTitleText(
          text: '${dateTimeToTitle(widget.importDateTime)} 눈바디',
          icon: Icons.portrait,
          sub: icons,
        ),
        SpaceHeight(height: smallSpace),
        ContentsBox(
          padding: const EdgeInsets.all(10),
          contentsWidget: Column(
            children: [
              setEyeBodyWidgets(),
              SpaceHeight(height: tinySpace),
              setDiaryWidget(),
              SpaceHeight(height: smallSpace),
              IconText(
                icon: Icons.error_outline,
                iconColor: Colors.grey.shade400,
                iconSize: 14,
                text: '추가한 사진은 앱 내에 저장되요.',
                textColor: Colors.grey.shade400,
                textSize: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

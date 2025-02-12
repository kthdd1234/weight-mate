// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/graph_category_provider.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/InterstitialAdService.dart';
import 'package:flutter_app_weight_management/services/app_open_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:privacy_screen/privacy_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

InterstitialAdService interstitialAdService = InterstitialAdService();

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.locale, required this.appStartIndex});

  String locale;
  int appStartIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late AppLifecycleReactor _appLifecycleReactor;

  requestInAppReview() async {
    List<RecordBox> recordList = recordRepository.recordList;
    InAppReview inAppReview = InAppReview.instance;
    bool isAvailable = await inAppReview.isAvailable();
    bool isLength = recordList.length == 10 ||
        recordList.length == 25 ||
        recordList.length == 50;

    if (isAvailable && isLength && !kDebugMode) {
      inAppReview.requestReview();
    }
  }

  onWindowManager() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  void initState() {
    super.initState();

    onWindowManager();
    WidgetsBinding.instance.addObserver(this);

    GdprDialog.instance
        .showDialog(isForTest: false, testDeviceId: '')
        .then((value) {});

    /** */
    PrivacyScreen.instance.enable(
      iosOptions: const PrivacyIosOptions(
        enablePrivacy: true,
        privacyImageName: "LaunchImage",
        autoLockAfterSeconds: 5,
        lockTrigger: IosLockTrigger.didEnterBackground,
      ),
      androidOptions: const PrivacyAndroidOptions(
        enableSecure: true,
        autoLockAfterSeconds: 5,
      ),
      backgroundColor: Colors.white.withOpacity(0),
      blurEffect: PrivacyBlurEffect.extraLight,
    );

    /** */
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;
    List<String>? displayList = user.displayList;
    String? calendarMaker = user.calendarMaker;
    String? calendarFormat = user.calendarFormat;
    List<String>? dietOrderList = user.dietOrderList;
    List<String>? exerciseOrderList = user.exerciseOrderList;
    List<String>? lifeOrderList = user.lifeOrderList;
    String? language = user.language;
    String? weightUnit = user.weightUnit;
    String? tallUnit = user.tallUnit;
    bool? isShowPreviousGraph = user.isShowPreviousGraph;
    String? historyForamt = user.historyForamt;
    List<String>? historyDisplayList = user.historyDisplayList;
    List<String>? searchDisplayList = user.searchDisplayList;
    List<String>? trackerDisplayList = user.trackerDisplayList;
    String? historyCalendarForamt = user.historyCalendarFormat;
    bool? isDietExerciseRecordDateTime = user.isDietExerciseRecordDateTime;
    String? fontFamily = user.fontFamily;
    Map<String, dynamic>? googleDriveInfo = user.googleDriveInfo;
    bool? isDietExerciseRecordDateTime2 = user.isDietExerciseRecordDateTime2;
    String? graphType = user.graphType;
    List<Map<String, dynamic>>? hashTagList = user.hashTagList;
    int? appStartIndex = user.appStartIndex;
    String? theme = user.theme;

    if (filterList == null) {
      userRepository.user.filterList = initOpenList;
    }

    if (displayList == null) {
      userRepository.user.displayList = initDisplayList;
    }

    if (calendarMaker == null) {
      userRepository.user.calendarMaker = CalendarMaker.sticker.toString();
    }

    if (calendarFormat == null) {
      userRepository.user.calendarFormat = CalendarFormat.week.toString();
    }

    if (dietOrderList == null) {
      List<PlanBox> planList = planRepository.planBox.values.toList();
      List<Map<String, Object?>> allOrderList = [
        {
          'type': PlanTypeEnum.diet.toString(),
          'list': dietOrderList,
        },
        {
          'type': PlanTypeEnum.exercise.toString(),
          'list': exerciseOrderList,
        },
        {
          'type': PlanTypeEnum.lifestyle.toString(),
          'list': lifeOrderList,
        },
      ];

      allOrderList.forEach(
        (orderInfo) {
          if (orderInfo['list'] == null) {
            List<String> list = [];

            planList.forEach(
              (planItem) {
                if (planItem.type == orderInfo['type']) {
                  list.add(planItem.id);
                }
              },
            );

            if (orderInfo['type'] == PlanTypeEnum.diet.toString()) {
              user.dietOrderList = list;
            } else if (orderInfo['type'] == PlanTypeEnum.exercise.toString()) {
              user.exerciseOrderList = list;
            } else if (orderInfo['type'] == PlanTypeEnum.lifestyle.toString()) {
              user.lifeOrderList = list;
            }
          }
        },
      );
    }

    if (language == null) {
      String localeName =
          localeNames.contains(widget.locale) ? widget.locale : 'ko';

      user.language = localeName;
    }

    if (tallUnit == null) {
      user.tallUnit = 'cm';
    }

    if (weightUnit == null) {
      user.weightUnit = 'kg';
    }

    if (isShowPreviousGraph == null) {
      user.isShowPreviousGraph = false;
    }

    if (historyForamt == null) {
      user.historyForamt = HistoryFormat.calendar.toString();
    }

    if (historyDisplayList == null) {
      user.historyDisplayList = initHistoryDisplayList;
    }

    if (searchDisplayList == null) {
      user.searchDisplayList = initSearchDisplayClassList;
    }

    if (trackerDisplayList == null) {
      user.trackerDisplayList = initTrackerDisplayClassList;
    }

    if (historyCalendarForamt == null) {
      user.historyCalendarFormat = CalendarFormat.week.toString();
    }

    if (isDietExerciseRecordDateTime == null) {
      user.isDietExerciseRecordDateTime = false;
    }

    if (isDietExerciseRecordDateTime2 == null) {
      user.isDietExerciseRecordDateTime2 = false;
    }

    if (fontFamily == null) {
      user.fontFamily = initFontFamily;
    }

    if (googleDriveInfo == null) {
      user.googleDriveInfo = {
        "isLogin": false,
        "backupDateTime": null,
        "email": null
      };
    }

    if (graphType == null) {
      user.graphType = eGraphDefault;
    }

    if (hashTagList == null) {
      user.hashTagList = getHashTagMapList(initHashTagList);
    }

    if (appStartIndex == null) {
      user.appStartIndex = 0;
    }

    if (theme == null) {
      user.theme = '1';
    }

    userRepository.user.save();

    /** */
    onNotifications.stream.listen(
      (String? payload) => WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          context
              .read<BottomNavigationProvider>()
              .setBottomNavigation(enumId: BottomNavigationEnum.record);
        },
      ),
    );

    interstitialAdService.loadAd(user: user);

    _appLifecycleReactor = AppLifecycleReactor(context: context);
    _appLifecycleReactor.listenToAppStateChanges(user: user);

    requestInAppReview();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DateTime now = DateTime.now();

      context.read<BottomNavigationProvider>().setBottomNavigation(
            enumId: indexToBn[widget.appStartIndex]!,
          );
      context.read<ImportDateTimeProvider>().setImportDateTime(now);
      context.read<TitleDateTimeProvider>().setTitleDateTime(now);
      context
          .read<HistoryImportDateTimeProvider>()
          .setHistoryImportDateTime(now);
      context.read<HistoryTitleDateTimeProvider>().setHistoryTitleDateTime(now);

      pp() async {
        bool isPremium = await isPurchasePremium();
        List<String> premiumEmailList = [
          'kthdd1234@gmail.com',
          'moonjh818@gmail.com'
        ];

        if (googleDriveInfo != null) {
          String? email = googleDriveInfo['email'];

          int index = premiumEmailList
              .indexWhere((premiumEmail) => premiumEmail == email);

          if (index != -1) isPremium = true;
        }

        context.read<PremiumProvider>().setPremiumValue(isPremium);
      }

      pp();
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationEnum bottomNavitionId =
        context.watch<BottomNavigationProvider>().selectedEnumId;

    onBottomNavigation(int index) {
      DateTime now = DateTime.now();
      List<BottomNavigationEnum> indexList =
          BottomNavigationEnum.values.toList();

      if (index == 0) {
        context.read<ImportDateTimeProvider>().setImportDateTime(now);
        context.read<TitleDateTimeProvider>().setTitleDateTime(now);
      } else if (index == 1) {
        context
            .read<HistoryImportDateTimeProvider>()
            .setHistoryImportDateTime(now);
        context
            .read<HistoryTitleDateTimeProvider>()
            .setHistoryTitleDateTime(now);
      }

      if (index != 2) {
        context.read<GraphCategoryProvider>().setGraphCategory(cGraphWeight);
      }

      context
          .read<BottomNavigationProvider>()
          .setBottomNavigation(enumId: indexList[index]);
    }

    floatingActionButton() {
      bool isRecord = BottomNavigationEnum.record == bottomNavitionId;
      bool isHistory = BottomNavigationEnum.history == bottomNavitionId;

      DateTime titleDateTime =
          context.watch<ImportDateTimeProvider>().getImportDateTime();
      DateTime histroyTitleDateTime = context
          .watch<HistoryImportDateTimeProvider>()
          .getHistoryImportDateTime();
      bool isToday = isCheckToday(
        isRecord ? titleDateTime : histroyTitleDateTime,
      );

      return (isRecord || isHistory) && !isToday
          ? FloatingActionButton.extended(
              extendedPadding: const EdgeInsets.all(10),
              backgroundColor: themeColor,
              onPressed: () {
                DateTime now = DateTime.now();

                if (isRecord) {
                  context.read<TitleDateTimeProvider>().setTitleDateTime(now);
                  context.read<ImportDateTimeProvider>().setImportDateTime(now);
                } else if (isHistory) {
                  context
                      .read<HistoryImportDateTimeProvider>()
                      .setHistoryImportDateTime(now);
                  context
                      .read<HistoryTitleDateTimeProvider>()
                      .setHistoryTitleDateTime(now);
                }
              },
              label: CommonText(
                text: '오늘로 이동',
                size: 13,
                color: Colors.white,
                isBold: true,
              ),
            )
          : null;
    }

    return CommonBackground(
      child: CommonScaffold(
        padding: const EdgeInsets.all(0),
        body: bodyList[bottomNavitionId.index],
        bottomNavigationBar: BottomNavigationBar(
          items: getBnbList(bottomNavitionId.index),
          elevation: 0,
          currentIndex: bottomNavitionId.index,
          selectedItemColor: themeColor,
          unselectedItemColor: themeColor,
          onTap: onBottomNavigation,
        ),
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}

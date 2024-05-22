// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/graph_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/history_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/setting/setting_body.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:privacy_screen/privacy_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

List<BottomNavigationEnum> bottomIdList = [
  BottomNavigationEnum.record,
  BottomNavigationEnum.history,
  BottomNavigationEnum.graph,
  BottomNavigationEnum.setting
];

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.locale});

  String locale;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
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
    String? historyCalendarForamt = user.historyCalendarFormat;
    bool? isDietExerciseRecordDateTime = user.isDietExerciseRecordDateTime;
    String? fontFamily = user.fontFamily;
    Map<String, dynamic>? googleDriveInfo = user.googleDriveInfo;
    bool? isDietExerciseRecordDateTime2 = user.isDietExerciseRecordDateTime2;
    String? graphType = user.graphType;

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
      user.googleDriveInfo = {"isLogin": false, "backupDateTime": null};
    }

    if (graphType == null) {
      user.graphType = eGraphDefault;
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

    requestInAppReview() async {
      List<RecordBox> recordList = recordRepository.recordList;
      InAppReview inAppReview = InAppReview.instance;
      bool isAvailable = await inAppReview.isAvailable();
      bool isNotNewUser = recordList.length > 2;
      bool isDay27 = DateTime.now().day == 27;

      if (isAvailable && isNotNewUser && isDay27) {
        inAppReview.requestReview();
      }
    }

    requestInAppReview();

    AppLifecycleReactor(context: context).listenToAppStateChanges();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DateTime now = DateTime.now();

      context.read<ImportDateTimeProvider>().setImportDateTime(now);
      context.read<TitleDateTimeProvider>().setTitleDateTime(now);
      context
          .read<HistoryImportDateTimeProvider>()
          .setHistoryImportDateTime(now);
      context.read<HistoryTitleDateTimeProvider>().setHistoryTitleDateTime(now);

      pp() async {
        bool isPremium = await isPurchasePremium();
        context.read<PremiumProvider>().setPremiumValue(isPremium);
      }

      pp();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.edit_rounded),
        label: '기록'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.menu_book_rounded),
        label: '히스토리'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Icon(FontAwesomeIcons.chartLine, size: 17),
        ),
        label: '그래프'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings_rounded),
        label: '설정'.tr(),
      ),
    ];

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

      context
          .read<BottomNavigationProvider>()
          .setBottomNavigation(enumId: indexList[index]);
    }

    List<Widget> bodyList = const [
      RecordBody(),
      HistoryBody(),
      GraphBody(),
      SettingBody()
    ];

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

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: bodyList[bottomNavitionId.index]),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: items,
            elevation: 0,
            currentIndex: bottomNavitionId.index,
            selectedItemColor: themeColor,
            unselectedItemColor: themeColor,
            onTap: onBottomNavigation,
          ),
        ),
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}

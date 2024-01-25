// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/graph_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/history_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/setting/setting_body.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/history_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/app_open_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

List<BottomNavigationEnum> bottomIdList = [
  BottomNavigationEnum.record,
  BottomNavigationEnum.history,
  BottomNavigationEnum.graph,
  BottomNavigationEnum.setting
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late AppLifecycleReactor _appLifecycleReactor;

  bool isActiveCamera = false;
  bool isShowMateScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    GdprDialog.instance
        .showDialog(isForTest: false, testDeviceId: '')
        .then((value) {});

    /** */
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: appOpenAdManager,
    );

    _appLifecycleReactor.listenToAppStateChanges();

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

    List<PlanBox> planList = planRepository.planBox.values.toList();

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
      final allOrderList = [
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
      String localeName = localeNames.contains(Platform.localeName)
          ? Platform.localeName
          : 'en_US';

      user.language = localeName;
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {});

    RecordBox? recordInfo =
        recordRepository.recordBox.get(getDateTimeToInt(DateTime.now()));
    bool isShowScreen = [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.paused
    ].contains(state);

    if (isShowScreen) {
      if (isActiveCamera == false) {
        setState(() => isShowMateScreen = true);
      }
    } else if (state == AppLifecycleState.resumed) {
      if (isActiveCamera == false) {
        if (userRepository.user.screenLockPasswords != null) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EnterScreenLockPage(),
              fullscreenDialog: true,
            ),
          );
        } else {
          if (recordInfo?.weight == null) {
            DateTime now = DateTime.now();

            context.read<ImportDateTimeProvider>().setImportDateTime(now);
            context.read<TitleDateTimeProvider>().setTitleDateTime(now);
            context.read<HistoryDateTimeProvider>().setHistoryDateTime(now);
          }
        }
      }

      setState(() => isShowMateScreen = false);
      setState(() => isActiveCamera = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = const [
      BottomNavigationBarItem(icon: Icon(Icons.edit), label: '기록'),
      BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded), label: '히스토리'),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Icon(FontAwesomeIcons.chartLine, size: 17),
        ),
        label: '그래프',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: '설정'),
    ];

    BottomNavigationEnum bottomNavitionId =
        context.watch<BottomNavigationProvider>().selectedEnumId;

    onBottomNavigation(int index) {
      List<BottomNavigationEnum> indexList =
          BottomNavigationEnum.values.toList();

      context
          .read<BottomNavigationProvider>()
          .setBottomNavigation(enumId: indexList[index]);
    }

    setActiveCamera(bool newValue) {
      setState(() => isActiveCamera = newValue);
    }

    List<Widget> bodyList = [
      RecordBody(setActiveCamera: setActiveCamera),
      const HistoryBody(),
      const GraphBody(),
      const SettingBody()
    ];

    return isShowMateScreen
        ? AddContainer(
            body: Center(
              child: Image.asset('assets/images/MATE.png', width: 150),
            ),
            isNotBack: true,
            isCenter: true,
            buttonEnabled: false,
            bottomSubmitButtonText: '',
          )
        : AppFramework(
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
                  unselectedItemColor: const Color(0xFF151515),
                  backgroundColor: Colors.red,
                  onTap: onBottomNavigation,
                ),
              ),
            ),
          );
  }
}

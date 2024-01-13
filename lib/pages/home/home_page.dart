// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/graph_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/history_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/setting/setting_body.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

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
  bool isActiveCamera = false;
  bool isShowMateScreen = false;

  String status = 'none';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // GdprDialog.instance.resetDecision();
    GdprDialog.instance
        .showDialog(isForTest: false, testDeviceId: '')
        .then((value) {
      status = 'dialog result == $value';
    });

    /** */
    List<String>? filterList = userRepository.user.filterList;

    if (filterList == null) {
      userRepository.user.filterList = initFilterList;
      userRepository.user.save();
    }

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AdsProvider>().setNativeAd();
    });
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

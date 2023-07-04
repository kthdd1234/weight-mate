import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/calendar_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/analyze_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/more_see_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/record_body.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/home_app_bar_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

List<eBottomNavigationBarItem> bottomIdList = [
  eBottomNavigationBarItem.record,
  eBottomNavigationBarItem.calendar,
  eBottomNavigationBarItem.analyze,
  eBottomNavigationBarItem.setting
];

class HomeContainer extends StatefulWidget {
  HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer>
    with WidgetsBindingObserver {
  late Box<RecordBox> recordBox;
  late Box<UserBox> userBox;

  bool isActiveCamera = false;

  eBottomNavigationBarItem selectedId = eBottomNavigationBarItem.record;

  setOnNotifications() {
    onNotifications.stream.listen((String? payload) async {
      selectedId = bottomIdList[0];
      // Scrollable.ensureVisible(planKey.currentContext!); // todo: 자동 스크롤링 필요!
    });
  }

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');
    selectedId = eBottomNavigationBarItem.record;

    setOnNotifications();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    UserBox? userProfile = userBox.get('userProfile');

    setGenerate() {
      RecordBox? recordInfo = recordBox.get(getDateTimeToInt(DateTime.now()));

      if (recordInfo == null || recordInfo.weight == null) {
        context
            .read<RecordIconTypeProvider>()
            .setSeletedRecordIconType(RecordIconTypes.addWeight);
      }

      context.read<ImportDateTimeProvider>().setImportDateTime(DateTime.now());
    }

    if (state == AppLifecycleState.resumed) {
      if (isActiveCamera == false) {
        if (userProfile != null && userProfile.screenLockPasswords != null) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EnterScreenLockPage(),
              fullscreenDialog: true,
            ),
          );
        }
      }

      setGenerate();
      setState(() => isActiveCamera = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    setActiveCamera(bool newValue) {
      setState(() => isActiveCamera = newValue);
    }

    onBottomNavigation(int index) {
      setState(() => selectedId = bottomIdList[index]);
    }

    List<BottomNavigationBarItem> items = const [
      BottomNavigationBarItem(icon: Icon(Icons.edit), label: '기록'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '달력'),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Icon(FontAwesomeIcons.chartLine, size: 17),
        ),
        label: '분석',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
    ];

    List<Widget> bodyList = [
      RecordBody(setActiveCamera: setActiveCamera),
      CalendarBody(onBottomNavigation: onBottomNavigation),
      const AnalyzeBody(),
      const MoreSeeBody()
    ];

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HomeAppBarWidget(appBar: AppBar(), id: selectedId),
        body: Padding(
          padding: pagePadding,
          child: SafeArea(child: bodyList[selectedId.index]),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: BottomNavigationBar(
            items: items,
            elevation: 0,
            currentIndex: selectedId.index,
            selectedItemColor: buttonBackgroundColor,
            unselectedItemColor: const Color(0xFF151515),
            backgroundColor: Colors.red,
            onTap: onBottomNavigation,
          ),
        ),
      ),
    );
  }
}

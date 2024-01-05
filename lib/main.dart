import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_plan_setting.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_start_screen.dart';
import 'package:flutter_app_weight_management/etc/common_alarm_page.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/common/image_collections_page.dart';
import 'package:flutter_app_weight_management/pages/common/record_history_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/edit_weight.dart';
import 'package:flutter_app_weight_management/pages/home/home_page.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/repositories/plan_repository.dart';
import 'package:flutter_app_weight_management/repositories/record_repository.dart';
import 'package:flutter_app_weight_management/repositories/user_repository.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/themes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/add/pages/add_body_info.dart';
import 'pages/common/screen_lock_page.dart';

UserRepository userRepository = UserRepository();
RecordRepository recordRepository = RecordRepository();
PlanRepository planRepository = PlanRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initMobileAds = MobileAds.instance.initialize();
  final adsState = AdsService(initialization: initMobileAds);

  await dotenv.load(fileName: ".env");
  await NotificationService().initNotification();
  await NotificationService().initializeTimeZone();
  await MateHive().initializeHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DietInfoProvider>(
          create: (_) => DietInfoProvider(),
        ),
        ChangeNotifierProvider<RecordIconTypeProvider>(
          create: (_) => RecordIconTypeProvider(),
        ),
        ChangeNotifierProvider<ImportDateTimeProvider>(
          create: (_) => ImportDateTimeProvider(),
        ),
        ChangeNotifierProvider<AdsProvider>(
          create: (_) => AdsProvider(adsState: adsState),
        ),
        ChangeNotifierProvider<BottomNavigationProvider>(
          create: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider<EnabledProvider>(
          create: (_) => EnabledProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<UserBox> userBox;

  @override
  void initState() {
    userBox = Hive.box('userBox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox? userProfile = userBox.get('userProfile');
    String initialRoute = userProfile?.userId == null
        ? '/add-start-screen'
        : userProfile?.screenLockPasswords == null
            ? '/home-page'
            : '/enter-screen-lock';

    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', 'KR'),
      ],
      theme: AppThemes.lightTheme,
      initialRoute: initialRoute, // initialRoute
      routes: {
        '/add-start-screen': (context) => const AddStartScreen(),
        '/add-body-info': (context) => const AddBodyInfo(),
        '/add-plan-setting': (context) => const AddPlanSetting(),
        '/home-page': (context) => const HomePage(),
        '/screen-lock': (context) => const ScreenLockPage(),
        '/common-alarm': (context) => const CommonAlarmPage(),
        '/enter-screen-lock': (context) => const EnterScreenLockPage(),
        '/image-collections-page': (context) => const ImageCollectionsPage(),
        '/record-history-page': (context) => const RecordHistoryPage(),
      },
    );
  }
}

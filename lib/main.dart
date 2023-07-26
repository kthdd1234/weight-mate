import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_plan_item.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_plan_setting.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_plan_type.dart';
import 'package:flutter_app_weight_management/pages/common/common_alarm_page.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/common/image_collections_page.dart';
import 'package:flutter_app_weight_management/pages/common/record_info_page.dart';
import 'package:flutter_app_weight_management/pages/home/home_container.dart';
import 'package:flutter_app_weight_management/pages/splash/splash.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/themes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/add/pages/add_body_info.dart';
import 'pages/common/screen_lock_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final initMobileAds = MobileAds.instance.initialize();
  final adsState = AdsService(initialization: initMobileAds);

  await dotenv.load(fileName: ".env");

  NotificationService().initNotification();
  NotificationService().initializeTimeZone();

  await _initHive();

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
      ],
      child: const MyApp(),
    ),
  );
}

_initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserBoxAdapter());
  Hive.registerAdapter(RecordBoxAdapter());
  Hive.registerAdapter(PlanBoxAdapter());

  await Hive.openBox<UserBox>('userBox');
  await Hive.openBox<RecordBox>('recordBox');
  await Hive.openBox<PlanBox>('planBox');
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
    PlanInfoClass planInfo = context.watch<DietInfoProvider>().getPlanInfo();

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
      initialRoute:
          userProfile?.userId != null ? '/home-container' : '/splash-screen',
      routes: {
        '/splash-screen': (context) => const SplashScreen(),
        '/add-body-info': (context) => const AddBodyInfo(),
        '/add-plan-type': (context) => AddPlanType(planInfo: planInfo),
        '/add-plan-item': (context) => AddPlanItem(planInfo: planInfo),
        '/add-plan-setting': (context) => const AddPlanSetting(),
        '/home-container': (context) => const HomeContainer(),
        '/screen-lock': (context) => const ScreenLockPage(),
        '/common-alarm': (context) => const CommonAlarmPage(),
        '/record-info-page': (context) => const RecordInfoPage(),
        '/enter-screen-lock': (context) => const EnterScreenLockPage(),
        '/image-collections-page': (context) => const ImageCollectionsPage()
      },
    );
  }
}

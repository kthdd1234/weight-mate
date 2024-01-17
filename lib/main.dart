import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_alarm_permission.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_plan_list.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_start_screen.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/common/image_collections_page.dart';
import 'package:flutter_app_weight_management/pages/home/home_page.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/provider/history_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/repositories/plan_repository.dart';
import 'package:flutter_app_weight_management/repositories/record_repository.dart';
import 'package:flutter_app_weight_management/repositories/user_repository.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
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
        ChangeNotifierProvider(create: (_) => DietInfoProvider()),
        ChangeNotifierProvider(create: (_) => ImportDateTimeProvider()),
        ChangeNotifierProvider(create: (_) => AdsProvider(adsState: adsState)),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => EnabledProvider()),
        ChangeNotifierProvider(create: (_) => TitleDateTimeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryFilterProvider()),
        ChangeNotifierProvider(create: (_) => HistoryDateTimeProvider()),
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
  String _authStatus = 'Unknown';
  late Box<UserBox> userBox;

  @override
  void initState() {
    userBox = Hive.box('userBox');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initAppTrackingPlugin();
    });
    super.initState();
  }

  Future<void> initAppTrackingPlugin() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      setState(() => _authStatus = '$status');

      if (status == TrackingStatus.notDetermined) {
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
      }
    } on PlatformException {
      setState(() => _authStatus = 'error');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
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
        '/add-plan-list': (context) => const AddPlanList(),
        '/add-alarm-permission': (context) => const AddAlarmPermission(),
        '/home-page': (context) => const HomePage(),
        '/screen-lock': (context) => const ScreenLockPage(),
        '/enter-screen-lock': (context) => const EnterScreenLockPage(),
        '/image-collections-page': (context) => const ImageCollectionsPage(),
      },
    );
  }
}

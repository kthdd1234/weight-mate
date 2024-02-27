import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/body_info_page.dart';
import 'package:flutter_app_weight_management/pages/common/body_unit_page.dart';
import 'package:flutter_app_weight_management/pages/common/font_change_page.dart';
import 'package:flutter_app_weight_management/pages/common/goal_chart_page.dart';
import 'package:flutter_app_weight_management/pages/common/todo_chart_page.dart';
import 'package:flutter_app_weight_management/pages/common/weight_chart_page.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_alarm_permission.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_body_tall.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_body_weight.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_plan_list.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_start_screen.dart';
import 'package:flutter_app_weight_management/pages/common/diary_write_page.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/pages/common/image_collections_page.dart';
import 'package:flutter_app_weight_management/pages/common/partial_delete_page.dart';
import 'package:flutter_app_weight_management/pages/home/home_page.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/provider/history_import_date_time.dart';
import 'package:flutter_app_weight_management/provider/history_title_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/history_filter_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/reload_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/repositories/plan_repository.dart';
import 'package:flutter_app_weight_management/repositories/record_repository.dart';
import 'package:flutter_app_weight_management/repositories/user_repository.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/colors.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'etc/add_body_info.dart';
import 'pages/common/screen_lock_page.dart';

const supportedLocales = [
  Locale('ko'),
  Locale('en'),
  Locale('ja'),
  // Locale('de', 'DE'),
  // Locale('es', 'ES'),
  // Locale('fr', 'FR'),
];

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
  await EasyLocalization.ensureInitialized();

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
        ChangeNotifierProvider(create: (_) => HistoryTitleDateTimeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryImportDateTimeProvider()),
        ChangeNotifierProvider(create: (_) => ReloadProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: supportedLocales,
        fallbackLocale: const Locale('en'),
        path: 'assets/translations',
        child: const MyApp(),
      ),
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
  Box<UserBox>? userBox;

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

    await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ReloadProvider>().isReload;

    String locale = context.locale.toString();
    UserBox? user = userBox?.get('userProfile');

    String initialRoute = user?.userId == null
        ? '/add-start-screen'
        : user?.screenLockPasswords == null
            ? '/home-page'
            : '/enter-screen-lock';
    String initLocale = context.locale != const Locale('ja')
        ? 'cafe24Ohsquareair'
        : 'cafe24SsurroundAir';
    String fontFamily =
        user?.fontFamily == null ? initLocale : user!.fontFamily!;

    ThemeData theme = ThemeData(
      primarySwatch: AppColors.primaryMaterialSwatchDark,
      fontFamily: fontFamily,
      textTheme: textTheme,
      splashColor: Colors.white,
      brightness: Brightness.light,
    );

    print('locale => $locale');

    return MaterialApp(
      title: 'weight-mate',
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      initialRoute: initialRoute, // initialRoute
      routes: {
        '/add-start-screen': (context) => const AddStartScreen(),
        '/add-body-weight': (context) => const AddBodyWeight(),
        '/add-body-tall': (context) => const AddBodyTall(),
        '/add-plan-list': (context) => const AddPlanList(),
        '/add-alarm-permission': (context) => const AddAlarmPermission(),
        '/home-page': (context) => HomePage(locale: locale),
        '/screen-lock': (context) => const ScreenLockPage(),
        '/enter-screen-lock': (context) => EnterScreenLockPage(),
        '/image-collections-page': (context) => const ImageCollectionsPage(),
        '/partial-delete-page': (context) => const PatialDeletePage(),
        '/diary-write-page': (context) => const DiaryWritePage(),
        '/body-unit-page': (context) => const BodyUnitPage(),
        '/body-info-page': (context) => const BodyInfoPage(),
        '/todo-chart-page': (context) => const TodoChartPage(),
        '/weight-chart-page': (context) => const WeightChartPage(),
        '/goal-chart-page': (context) => const GoalChartPage(),
        '/font-change-page': (context) => const FontChangePage(),
      },
    );
  }
}

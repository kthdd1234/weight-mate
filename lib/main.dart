import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/model/act_box/act_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_act_names.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_act_setting.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_act_type.dart';
import 'package:flutter_app_weight_management/pages/common/common_alarm_page.dart';
import 'package:flutter_app_weight_management/pages/home/home_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/add/pages/add_body_info.dart';
import 'pages/common/screen_lock_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        )
      ],
      child: const MyApp(),
    ),
  );
}

_initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserBoxAdapter());
  Hive.registerAdapter(RecordBoxAdapter());
  Hive.registerAdapter(ActBoxAdapter());

  await Hive.openBox<UserBox>('userBox');
  await Hive.openBox<RecordBox>('recordBox');
  await Hive.openBox<ActBox>('actBox');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final actInfo = context.watch<DietInfoProvider>().getActInfo();

    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      theme: AppThemes.lightTheme,
      routes: {
        '/add-body-info': (context) => const AddBodyInfo(),
        '/add-act-type': (context) => AddActType(actInfo: actInfo),
        '/add-act-names': (context) => AddActNames(actInfo: actInfo),
        '/add-act-setting': (context) => AddActSetting(actInfo: actInfo),
        '/home-container': (context) => const HomeContainer(),
        '/screen-lock': (context) => const ScreenLockPage(),
        '/common-alarm': (context) => const CommonAlarmPage()
      },
      home: AppFramework(widget: const AddBodyInfo()),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/pages/common/alarm_setting_page.dart';
import 'package:flutter_app_weight_management/pages/home/home_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/add/pages/add_body_info.dart';
import 'pages/add/pages/add_goal_weight.dart';
import 'pages/add/pages/add_todo_list.dart';
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
        ChangeNotifierProvider<RecordSubTypeProvider>(
          create: (_) => RecordSubTypeProvider(),
        ),
        ChangeNotifierProvider<RecordSelectedDateTimeProvider>(
          create: (_) => RecordSelectedDateTimeProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

_initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserInfoBoxAdapter());
  await Hive.openBox<UserInfoBox>('userInfoBox');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        '/add-body-info': (context) => AddBodyInfo(),
        '/add-goal-weight': (context) => AddGoalWeight(),
        '/add-todo-list': (context) => AddTodoList(),
        '/home-container': (context) => HomeContainer(),
        '/screen-lock': (context) => ScreenLockPage(),
        '/alarm-setting': (context) => AlarmSettingPage(),
      },
      home: AppFramework(widget: const AddBodyInfo()),
    );
  }
}

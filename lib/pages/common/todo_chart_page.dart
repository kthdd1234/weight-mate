import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import '../../utils/constants.dart';

class TodoChartPage extends StatelessWidget {
  const TodoChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String type = args['type']!;
    String title = args['title']!;

    return AppFramework(
      widget: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        appBar: AppBar(
          title: Text(
            '$title 기록 모아보기'.tr(),
            style: const TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

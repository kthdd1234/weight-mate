import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/data/google_drive.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class AppDataPage extends StatelessWidget {
  const AppDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '데이터 백업/복원'),
        body: const Column(children: [GoogleDriveContainer()]),
      ),
    );
  }
}

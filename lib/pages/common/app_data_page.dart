import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/data/google_drive.dart';
import 'package:flutter_app_weight_management/components/data/i_cloud.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';

class AppDataPage extends StatelessWidget {
  const AppDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('데이터 백업/복원'.tr(), style: const TextStyle(fontSize: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                GoogleDriveContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

                // const ICloudContainer(),

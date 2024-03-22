import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_analyze_page.dart';

class GoogleDriveContainer extends StatelessWidget {
  const GoogleDriveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitle(title: '구글 드라이브 데이터 백업', svg: "cloud-data"),
        ],
      ),
    );
  }
}

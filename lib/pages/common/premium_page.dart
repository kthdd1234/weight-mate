import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '프리미엄'.tr(),
            style: const TextStyle(fontSize: 20, color: themeColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ContentsBox(
              contentsWidget: Column(
                children: [Row(children: [])],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 한번 결제로 평생 이용
// 가격은? 5000원
// 광고 제거
// By 연필의 정석 폰트 사용
// 데이터 백업 / 복구
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class WeightAnalyzePage extends StatelessWidget {
  const WeightAnalyzePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '체중 분석표'.tr(),
            style: const TextStyle(fontSize: 20, color: themeColor),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          elevation: 0.0,
          actions: [],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ContentsBox(
              contentsWidget: Column(
                children: [
                  Row(children: []),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/** 진행 상황
 * 처음 기록한 체중                         2023.7.15 (수)
 * 61.8kg
 * ---------------------------------------------------
 * 가장 최근에 기록한 체중                         2024.3.16 (토)
 * 59.1kg
 * ---------------------------------------------------
 * 처음 기록한 체중과 최근 기록한 체중의 비교
 * ▾2.7kg
 * */

 /** 평균, 최저, 최고
 * 3월 평균 체중                                    3월 ▿
 * 58.2kg
 * */

 /**
  * 
  */

 /** 
 * 목표 체중까지 -kg 남았어요!
 * 
 * */

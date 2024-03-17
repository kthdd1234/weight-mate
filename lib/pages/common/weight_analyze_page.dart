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

/** 처음과 비교
 * 처음 기록한 체중                         2023.7.15 (수)
 * 61.8kg
 * ---------------------------------------------------
 * 가장 최근에 기록한 체중                    2024.3.16 (토)
 * 59.1kg
 * ---------------------------------------------------
 * (가장 최근에 기록한 체중) - (처음 기록한 체중)
 * -2.7kg
 * */

/** 목표와 비교                              
 * 목표 체중                               2023.7.15 (수)
 * 55.2kg                                
 * ---------------------------------------------------
 * 가장 최근에 기록한 체중                    2024.3.16 (토)
 * 59.1kg
 * ---------------------------------------------------
 * (목표 체중) - (가장 최근에 기록한 체중)
 * -4.1kg
 * */

/** 3월 분석                                       3월 ▿
 * 평균 체중                                    
 * 58.2kg
 * ---------------------------------------------------
 * 최고 체중
 * 57.2kg
 * ---------------------------------------------------
 * 최저 체중
 * 62.1kg
 * */

/** 2024년 분석                                 2024년 ▿
 * 평균 체중                                    
 * 58.2kg
 * ---------------------------------------------------
 * 최고 체중
 * 57.2kg
 * ---------------------------------------------------
 * 최저 체중
 * 62.1kg
 * */



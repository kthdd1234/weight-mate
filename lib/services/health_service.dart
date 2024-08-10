// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/components/popup/LoadingPopup.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:health/health.dart';

class HealthService {
  Health health = Health();

  List<HealthDataType> types = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
  ];

  List<HealthDataAccess> permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ
  ];

  void initConfiguration() {
    Health().configure(useHealthConnectIfAvailable: true);
  }

  Future<bool> get isPermission async {
    bool? hasPermissions = await health.hasPermissions(
      types,
      permissions: permissions,
    );

    return hasPermissions == true;
  }

  Future<void> requestAuthorization() async {
    await health.requestAuthorization(
      types,
      permissions: permissions,
    );
  }

  Future<double?> getHealthWeight({
    required BuildContext ctx,
    required DateTime dateTime,
  }) async {
    String locale = ctx.locale.toString();

    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

    DateTime startTime = DateTime(year, month, day, 0, 0);
    DateTime endTime = DateTime(year, month, day, 23, 59);

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      types: [HealthDataType.WEIGHT],
      startTime: startTime,
      endTime: endTime,
    );

    if (healthData.isEmpty) {
      showDialog(
        context: ctx,
        builder: (context) => AlertPopup(
          title: '건강 앱에서 가져오기',
          height: 335,
          text1: '에 가져올 수 있는',
          text2: '데이터가 없어요.',
          nameArgs: {
            'dateTime': ymd(locale: locale, dateTime: dateTime),
            'type': '체중'.tr()
          },
          buttonText: '확인',
          onTap: () => closeDialog(context),
          containerChild: containerChild('체중'.tr()),
          buttonChild: buttonChild(context),
        ),
      );

      return null;
    }

    Map<String, dynamic> json = healthData[0].value.toJson();
    double weight = json['numeric_value'];

    return weight;
  }

  Future<List<HealthDataPoint>> getHealthSteps({
    required BuildContext ctx,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) async {
    showDialog(
      context: ctx,
      builder: (context) => LoadingPopup(
        isLoadingIcon: false,
        text: '걸음 수 데이터 가져오는 중...',
        color: Colors.white,
      ),
    );

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: startDateTime,
      endTime: endDateTime,
    );

    closeDialog(ctx);

    if (healthData.isEmpty) {
      showDialog(
        context: ctx,
        builder: (context) => AlertPopup(
          title: '건강 앱에서 가져오기',
          height: 335,
          text1: '건강 앱에서 가져올 수 있는',
          text2: '데이터가 없어요.',
          nameArgs: {'type': '걸음 수'.tr()},
          buttonText: '확인',
          containerChild: containerChild('걸음 수'.tr()),
          buttonChild: buttonChild(context),
          onTap: () => closeDialog(context),
        ),
      );
    }

    return healthData;
  }

  containerChild(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CommonName(
            text: '건강 앱에 데이터가 있을 경우',
            nameArgs: {'type': name},
            color: grey.original,
            fontSize: 12,
          ),
          CommonName(
            text: '휴대폰 설정에서 건강 앱 접근 권한을',
            color: grey.original,
            fontSize: 12,
          ),
          CommonName(
            text: '활성화 시켜주세요.',
            color: grey.original,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  buttonChild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ExpandedButtonHori(
            padding: const EdgeInsets.symmetric(vertical: 15),
            text: '접근 권한 활성화 방법',
            imgUrl: 'assets/images/t-3.png',
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertPopup(
                height: 215,
                title: '접근 권한 활성화 방법',
                text1: '휴대폰 설정 > 건강 > 데이터 및 접근 기기',
                text2: '체중 메이트 > 모두 켜기',
                buttonText: '닫기',
                onTap: () => closeDialog(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}

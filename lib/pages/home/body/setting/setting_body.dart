// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
// import 'package:fitness/fitness.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/ImageTimeBottomSheet.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/AppStartBottomSheet.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/popup/PermissionPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/alarm_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/services/device_info_service.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingBody extends StatefulWidget {
  const SettingBody({super.key});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  Map<String, dynamic>? deviceInfo, appInfo;

  @override
  void initState() {
    getInfo() async {
      deviceInfo = await getDeviceInfo();
      appInfo = await getAppInfo();

      setState(() {});
    }

    getInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    bool isPremium = context.watch<PremiumProvider>().isPremium;
    BottomNavigationEnum bodyId =
        context.watch<BottomNavigationProvider>().selectedEnumId;

    UserBox user = userRepository.user;
    bool isLock = user.screenLockPasswords != null;
    String? language = user.language;
    String fontFamily = user.fontFamily ?? initFontFamily;
    String validFontFamily = getFontFamily(fontFamily);
    String fontName = getFontName(validFontFamily);
    String theme = user.theme ?? '1';
    int appStartIndex = user.appStartIndex ?? 0;

    onNavigator({required String type, required String title}) async {
      await Navigator.pushNamed(context, '/body-info-page', arguments: {
        'type': type,
        'title': title,
      });

      setState(() {});
    }

    onTapTall(id) {
      onNavigator(type: 'tall', title: '키');
    }

    onTapGoalWeight(id) {
      onNavigator(type: 'goalWeight', title: '목표 체중');
    }

    onTapAlarm(id) async {
      bool isPermission = await NotificationService().permissionNotification;

      if (isPermission == false) {
        return showDialog(
          context: context,
          builder: (context) => const PermissionPopup(),
        );
      }

      await showModalBottomSheet(
        context: context,
        builder: (context) {
          bool isEnabled = user.isAlarm;
          DateTime alarmTime = user.alarmTime ?? DateTime.now();

          return StatefulBuilder(
            builder: (context, setModalState) {
              onChanged(bool newValue) {
                if (newValue == false) {
                  if (user.alarmId != null) {
                    NotificationService().deleteAlarm(user.alarmId!);
                  }

                  user.isAlarm = false;
                  user.alarmId = null;
                  user.alarmTime = null;
                  user.save();
                }

                setModalState(() => isEnabled = newValue);
              }

              onCompleted() {
                if (isEnabled) {
                  int alarmId = user.alarmId ?? UniqueKey().hashCode;
                  String title = weightNotifyTitle();
                  String body = weightNotifyBody();

                  NotificationService().addNotification(
                    id: alarmId,
                    dateTime: DateTime.now(),
                    alarmTime: alarmTime,
                    title: title.tr(),
                    body: body.tr(),
                    payload: 'weight',
                  );

                  user.isAlarm = true;
                  user.alarmId = alarmId;
                  user.alarmTime = alarmTime;
                }

                user.save();
                closeDialog(context);
              }

              onDateTimeChanged(DateTime dateTime) {
                setModalState(() => alarmTime = dateTime);
              }

              return CommonBottomSheet(
                title: '알림 설정'.tr(),
                height: 650,
                contents: AlarmContainer(
                  icon: Icons.edit,
                  title: '체중 기록 알림',
                  desc: '매일 체중 기록 알림을 드려요.',
                  isEnabled: isEnabled,
                  alarmTime: alarmTime,
                  onChanged: onChanged,
                  onCompleted: onCompleted,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              );
            },
          );
        },
      );

      setState(() {});
    }

    onTapLock(id) {
      showDialog(
        context: context,
        builder: (context) => AlertPopup(
          height: 185,
          text1: isLock ? '화면 잠금을 해제할까요?' : '암호를 분실했을 경우',
          text2: isLock ? '확인 버튼을 누르면 바로 해제 됩니다.' : '앱 삭제 후 재설치 해야 합니다.',
          buttonText: '확인',
          onTap: () async {
            if (isLock) {
              user.screenLockPasswords = null;
              await user.save();
            } else {
              await Navigator.pushNamed(context, '/screen-lock');
            }

            closeDialog(context);
            setState(() {});
          },
        ),
      );
    }

    onTapReset(id) {
      showDialog(
        context: context,
        builder: (context) => AlertPopup(
          text1: '앱 내의 모든 데이터를',
          text2: '처음 상태로 되돌릴까요?',
          height: 185,
          buttonText: '확인',
          isCancel: true,
          onTap: () async {
            await userRepository.userBox.clear();
            await recordRepository.recordBox.clear();
            await planRepository.planBox.clear();
            await NotificationService().deleteAllAlarm();
            await Navigator.pushNamedAndRemoveUntil(
              context,
              '/add-start-screen',
              (_) => false,
            );
          },
        ),
      );
    }

    onTapReview(id) {
      InAppReview inAppReview = InAppReview.instance;
      String? appleId = dotenv.env['APPLE_ID'];
      String? androidId = dotenv.env['ANDROID_ID'];

      inAppReview.openStoreListing(
        appStoreId: appleId,
        microsoftStoreId: androidId,
      );
    }

    onTapShare(id) {
      String? appStoreLink = dotenv.env['APP_STORE_LINK'];
      String? playStoreLink = dotenv.env['PLAY_STORE_LINK'];

      Platform.isIOS
          ? Share.share(appStoreLink!, subject: '체중 메이트')
          : Share.share(playStoreLink!, subject: '체중 메이트');
    }

    onTapDeveloper(id) {
      String body = '';

      if (appInfo != null && deviceInfo != null) {
        body += "==============\n";
        body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다. \n";

        appInfo!.forEach((key, value) {
          body += "$key: $value\n";
        });

        deviceInfo!.forEach((key, value) {
          body += "$key: $value\n";
        });
      }

      body += "==============\n";

      FlutterEmailSender.send(Email(
        body: body,
        subject: '[개발자 문의]',
        recipients: ['kthdd1234@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false,
      ))
          .then(
        (value) => showSnackBar(
          context: context,
          text: '문의 해주셔서 감사합니다.',
          buttonName: '확인',
          width: 280,
        ),
      )
          .catchError(
        (error) {
          String message =
              "기본 메일 앱을 사용할 수 없기 때문에 앱에서\n바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면\n친절하게 답변해드릴게요 :)\n\nkthdd1234@gmail.com"
                  .tr();

          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("확인").tr(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        },
      );
    }

    onTapPrivacy(id) async {
      Uri url = Uri(
        scheme: 'https',
        host: 'nettle-dill-e85.notion.site',
        path: '3eb8ce7ef1df4ec487e0a27ad31d798b',
        queryParameters: {'pvs': '4'},
      );

      await canLaunchUrl(url) ? await launchUrl(url) : throw 'launchUrl error';
    }

    onTapLangItem(String languageCode) async {
      await context.setLocale(Locale(languageCode));
      user.language = languageCode;
      user.save();

      closeDialog(context);
    }

    onTapLanguage(id) {
      showModalBottomSheet(
        context: context,
        builder: (context) => CommonBottomSheet(
          title: '언어 변경'.tr(),
          height: 300,
          contents: ContentsBox(
            contentsWidget: ListView(
              shrinkWrap: true,
              children: languageItemList.map((item) {
                bool isLanguage = language == item.languageCode;

                return InkWell(
                  onTap: () => onTapLangItem(item.languageCode),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontWeight: isLanguage
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isLanguage ? themeColor : grey.original,
                          ),
                        ),
                        isLanguage
                            ? CommonIcon(icon: Icons.task_alt, size: 20)
                            : const EmptyArea()
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    onTapFont(id) async {
      await Navigator.pushNamed(context, '/font-change-page');
      setState(() {});
    }

    onTapUnit(id) async {
      await Navigator.pushNamed(context, '/body-unit-page');
      setState(() {});
    }

    onTapPremium(id) async {
      await Navigator.pushNamed(context, '/premium-page');
      setState(() {});
    }

    onTapData(id) async {
      await Navigator.pushNamed(context, '/app-data-page');
      setState(() {});
    }

    onTapStart(id) async {
      if (isPremium == false) {
        return showDialog(
          context: context,
          builder: (context) => AlertPopup(
            height: 185,
            buttonText: "프리미엄 구매 페이지로 이동",
            text1: '프리미엄 구매 시',
            text2: '화면 설정 기능을 이용할 수 있어요',
            onTap: () => Navigator.pushNamed(context, '/premium-page'),
          ),
        );
      }

      await showModalBottomSheet(
        context: context,
        builder: (context) => const AppStartBottomSheet(),
      );
      setState(() {});
    }

    onTapTheme(id) async {
      await Navigator.pushNamed(context, '/theme-change-page');
      setState(() {});
    }

    onTapRecommend(id) async {
      Uri url = Uri(
        scheme: 'https',
        host: 'apps.apple.com',
        path: 'app/weight-calendar-diet-health/id6670779581',
      );

      await canLaunchUrl(url) ? await launchUrl(url) : throw 'launchUrl error';
    }

    List<MoreSeeItemClass> settingItemList = [
      MoreSeeItemClass(
        id: MoreSeeItem.premium,
        icon: 'crown',
        title: '프리미엄',
        value: 'premium',
        color: themeColor,
        onTap: onTapPremium,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.tall,
        icon: 'tall',
        title: '키',
        value: '${user.tall}${user.tallUnit}',
        color: themeColor,
        onTap: onTapTall,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.goalWeight,
        icon: 'goal',
        title: '목표 체중',
        value: '${user.goalWeight}${user.weightUnit}',
        color: themeColor,
        onTap: onTapGoalWeight,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appTheme,
        icon: 'theme',
        title: '테마 변경',
        value: themeClassList
            .expand((list) => list)
            .toList()
            .firstWhere((item) => item.path == theme)
            .name,
        color: themeColor,
        onTap: onTapTheme,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appFont,
        icon: 'font',
        title: '글꼴 변경',
        value: fontName.tr(),
        color: themeColor,
        onTap: onTapFont,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appLang,
        icon: 'language',
        title: '언어 변경',
        value: localeDisplayNames[user.language] ?? 'English',
        color: themeColor,
        onTap: onTapLanguage,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appUnit,
        icon: 'ruler',
        title: '단위 변경',
        value: '${user.tallUnit}/${user.weightUnit}',
        color: themeColor,
        onTap: onTapUnit,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appAlarm,
        icon: 'alarm',
        title: '기록 알림',
        value: '${user.isAlarm ? hm(
            locale: locale,
            dateTime: user.alarmTime!,
          ) : '알림 없음'.tr()}',
        color: user.isAlarm ? themeColor : Colors.grey,
        onTap: onTapAlarm,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appLock,
        icon: 'lock',
        title: '화면 잠금',
        value: isLock ? '화면 잠금 중'.tr() : '잠금 없음'.tr(),
        color: isLock ? themeColor : Colors.grey,
        onTap: onTapLock,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appStart,
        icon: 'app-start',
        title: '앱 시작 화면',
        value: '${indexToName[appStartIndex]}'.tr(),
        color: themeColor,
        onTap: onTapStart,
      ),
      // MoreSeeItemClass(
      //   id: MoreSeeItem.imageTime,
      //   icon: 'imageTime',
      //   title: '사진 시간 표시',
      //   value: '표시',
      //   color: themeColor,
      //   onTap: onImageTime,
      // ),
      MoreSeeItemClass(
        id: MoreSeeItem.appData,
        icon: 'cloud-data',
        title: '데이터 백업/복원',
        value: '',
        color: Colors.transparent,
        onTap: onTapData,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appReset,
        icon: 'reset',
        title: '데이터 초기화',
        value: '',
        color: Colors.transparent,
        onTap: onTapReset,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appEval,
        icon: 'review',
        title: '앱 리뷰 작성',
        value: '',
        color: Colors.transparent,
        onTap: onTapReview,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appShare,
        icon: 'share',
        title: '앱 공유',
        value: '',
        color: Colors.transparent,
        onTap: onTapShare,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.developerInp,
        icon: 'developer',
        title: '개발자 문의',
        value: '',
        color: Colors.transparent,
        onTap: onTapDeveloper,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.developerInp,
        icon: 'recommend',
        title: '개발자 추천 앱',
        value: '몸무게 달력'.tr(),
        color: themeColor,
        onTap: onTapRecommend,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.privacyPolicy,
        icon: 'private',
        title: '개인정보처리방침',
        value: '',
        color: Colors.transparent,
        onTap: onTapPrivacy,
      ),
      MoreSeeItemClass(
        id: MoreSeeItem.appVersion,
        icon: 'version',
        title: '앱 버전',
        value: appInfo != null
            ? '${appInfo!['앱 버전']} (${appInfo!['앱 빌드 번호']})'
            : '',
        color: themeColor,
        onTap: (_) {},
      ),
    ];

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        List<MoreSeeItemWidget> children = settingItemList
            .map(
              (item) => MoreSeeItemWidget(
                id: item.id,
                icon: item.icon,
                title: item.title,
                value: item.value,
                color: item.color,
                isPremium: isPremium,
                onTap: item.onTap,
              ),
            )
            .toList();

        return Column(
          children: [
            CommonAppBar(),
            Expanded(child: ListView(children: children))
          ],
        );
      },
    );
  }
}

class MoreSeeItemWidget extends StatelessWidget {
  MoreSeeItemWidget({
    super.key,
    required this.id,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.isPremium,
    required this.onTap,
  });

  MoreSeeItem id;
  String title, value, icon;
  Color color;
  bool isPremium;
  Function(MoreSeeItem id) onTap;

  @override
  Widget build(BuildContext context) {
    wValue() {
      if (value == 'premium') {
        return Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/t-4.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            child: CommonText(
              text: isPremium ? '구매 완료' : '업그레이드',
              color: Colors.white,
              size: 11,
              isCenter: true,
              isBold: true,
            ));
      }

      return value != ''
          ? CommonText(
              isNotTr: true,
              text: value,
              size: 13,
              color: color,
            )
          : const EmptyArea();
    }

    return InkWell(
      onTap: () => onTap(id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: whiteBgBtnColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset('assets/svgs/$icon.svg', height: 17),
            ),
            SpaceWidth(width: regularSapce),
            Expanded(
                child: CommonText(
              text: title,
              size: 14,
              isBold: true,
              color: themeColor,
            )),
            wValue(),
          ],
        ),
      ),
    );
  }
}

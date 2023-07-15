import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/services/device_info_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreEtcInfoWidget extends StatefulWidget {
  const MoreEtcInfoWidget({super.key});

  @override
  State<MoreEtcInfoWidget> createState() => _MoreEtcInfoWidgetState();
}

class _MoreEtcInfoWidgetState extends State<MoreEtcInfoWidget> {
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
    onTapArrow(MoreSeeItem id) async {
      switch (id) {
        case MoreSeeItem.appEval:
          InAppReview inAppReview = InAppReview.instance;
          String? appleId = dotenv.env['APPLE_ID'];
          String? androidId = dotenv.env['ANDROID_ID'];

          if (Platform.isIOS) {
            inAppReview.openStoreListing(appStoreId: appleId);
          } else {
            showSnackBar(
              context: context,
              text: '해당 기능은 준비 중입니다 :)',
              buttonName: '확인',
              width: 300,
            );
          }

          break;

        case MoreSeeItem.appShare:
          String? appStoreLink = dotenv.env['APP_STORE_LINK'];

          if (Platform.isIOS) {
            Share.share(appStoreLink!, subject: '체중 메이트');
          } else {
            showSnackBar(
              context: context,
              text: '해당 기능은 준비 중입니다 :)',
              buttonName: '확인',
              width: 300,
            );
          }
          break;

        case MoreSeeItem.developerInp:
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
                  "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nkthdd1234@gmail.com";

              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  content: Text(message),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text("확인"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            },
          );

          break;

        case MoreSeeItem.privacyPolicy:
          // https://nettle-dill-e85.notion.site/3eb8ce7ef1df4ec487e0a27ad31d798b?pvs=4
          Uri url = Uri(
            scheme: 'https',
            host: 'nettle-dill-e85.notion.site',
            path: '3eb8ce7ef1df4ec487e0a27ad31d798b',
            queryParameters: {'pvs': '4'},
          );
          await canLaunchUrl(url)
              ? await launchUrl(url)
              : throw 'launchUrl error';

          break;

        default:
      }
    }

    setAppVersion() {
      if (appInfo == null) return '';
      return '${appInfo!['앱 버전']} (${appInfo!['앱 빌드 번호']})';
    }

    List<MoreSeeItemClass> moreSeeEtcItems = [
      MoreSeeItemClass(
        // todo: store 배포 완료 후 기능 구현 할 것.
        index: 0,
        id: MoreSeeItem.appEval,
        icon: Icons.rate_review_outlined,
        title: '앱 리뷰 작성',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        // todo: store 배포 완료 후 기능 구현 할 것.
        index: 1,
        id: MoreSeeItem.appShare,
        icon: Icons.share,
        title: '앱 공유',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 2,
        id: MoreSeeItem.developerInp,
        icon: Icons.drafts_outlined,
        title: '개발자 문의',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 3,
        id: MoreSeeItem.privacyPolicy,
        icon: Icons.verified_user_outlined,
        title: '개인정보처리방침',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 4,
        id: MoreSeeItem.appVersion,
        icon: Icons.error_outline,
        title: '앱 버전',
        value: setAppVersion(),
        widgetType: MoreSeeWidgetTypes.none,
      ),
    ];

    List<MoreSeeItemWidget> widgetList = moreSeeEtcItems
        .map((item) => MoreSeeItemWidget(
              index: item.index,
              id: item.id,
              icon: item.icon,
              title: item.title,
              value: item.value,
              widgetType: item.widgetType,
              onTapArrow: item.onTapArrow,
            ))
        .toList();

    return Column(
      children: [
        ContentsTitleText(text: '기타'),
        SpaceHeight(height: regularSapce),
        Column(children: widgetList),
      ],
    );
  }
}

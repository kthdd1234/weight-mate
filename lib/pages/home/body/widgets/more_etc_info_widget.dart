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
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share_plus/share_plus.dart';

class MoreEtcInfoWidget extends StatelessWidget {
  const MoreEtcInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    onTapArrow(MoreSeeItem id) async {
      switch (id) {
        case MoreSeeItem.appShare:
          Share.share('https://www.naver.com', subject: '앱 이름');
          break;

        case MoreSeeItem.developerInp:
          Map<String, dynamic> deviceInfo = await getDeviceInfo();
          Map<String, dynamic> appInfo = await getAppInfo();
          String body = '';

          body += "==============\n";
          body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다. \n";

          appInfo.forEach((key, value) {
            body += "$key: $value\n";
          });

          deviceInfo.forEach((key, value) {
            body += "$key: $value\n";
          });

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
        default:
      }
    }

    List<MoreSeeItemClass> moreSeeEtcItems = [
      MoreSeeItemClass(
        index: 0,
        id: MoreSeeItem.appEval,
        icon: Icons.rate_review_outlined,
        title: '앱 리뷰',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
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
        id: MoreSeeItem.appVersion,
        icon: Icons.error_outline,
        title: '앱 버전',
        value: '1.1',
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

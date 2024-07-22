// ignore_for_file: use_build_context_synchronously, prefer_is_empty
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class EmotionBottomSheet extends StatelessWidget {
  EmotionBottomSheet({super.key, required this.emotion, required this.onTap});

  String emotion;
  Function(String selectedEmotion) onTap;

  @override
  Widget build(BuildContext context) {
    onTapStreamline() async {
      await launchUrl(Uri(scheme: 'https', host: 'home.streamlinehq.com'));
    }

    onTapCCBY() async {
      await launchUrl(
        Uri(
          scheme: 'https',
          host: 'creativecommons.org',
          path: 'licenses/by/4.0/',
        ),
      );
    }

    return CommonBottomSheet(
      title: '감정'.tr(),
      height: 560,
      contents: Expanded(
        child: ContentsBox(
          contentsWidget: GridView.builder(
            itemCount: emotionList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              SvgClass data = emotionList[index];
              String svgPath = 'assets/svgs/${data.emotion}.svg';

              return InkWell(
                onTap: () => onTap(data.emotion),
                child: Column(
                  children: [
                    SvgPicture.asset(svgPath, height: 40),
                    SpaceHeight(height: tinySpace),
                    data.emotion == emotion
                        ? CommonTag(color: 'peach', text: data.name)
                        : CommonText(text: data.name, size: 12, isCenter: true),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      subContents: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonText(
            text: '출처: ',
            size: 11,
            color: grey.original,
          ),
          CommonText(
            isNotTr: true,
            text: 'streamline',
            color: grey.original,
            size: 11,
            decoration: 'underLine',
            decoColor: grey.original,
            onTap: onTapStreamline,
          ),
          CommonText(
            isNotTr: true,
            text: ' / ',
            size: 11,
            color: grey.original,
          ),
          CommonText(
            isNotTr: true,
            text: 'CC BY',
            decoration: 'underLine',
            size: 11,
            decoColor: grey.original,
            color: grey.original,
            onTap: onTapCCBY,
          ),
        ],
      ),
    );
  }
}

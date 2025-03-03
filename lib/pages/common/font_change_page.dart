import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/reload_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class FontChangePage extends StatefulWidget {
  const FontChangePage({super.key});

  @override
  State<FontChangePage> createState() => _FontChangePageState();
}

class _FontChangePageState extends State<FontChangePage> {
  @override
  Widget build(BuildContext context) {
    bool isReload = context.watch<ReloadProvider>().isReload;

    UserBox? user = userRepository.user;
    String? fontFamily = getFontFamily(user.fontFamily ?? initFontFamily);
    String fontName = getFontName(fontFamily);

    List<String> fontPreviewList = [
      "글꼴 미리보기입니다.".tr(namedArgs: {'fontName': fontName.tr()}),
      "가나다라마바사아자차카타파하",
      "체중, 사진, 식단, 운동, 습관, 일기".tr(),
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
      "abcdefghijklnmopqrstuvwxyz",
      "0123456789!@#%^&*()",
    ];

    onTap(String selectedFontFamily) async {
      user.fontFamily = selectedFontFamily;

      await user.save();

      setState(() {});
      context.read<ReloadProvider>().setReload(!isReload);
    }

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '글꼴 변경'),
        body: Column(
          children: [
            ContentsBox(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              contentsWidget: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fontPreviewList
                        .map((text) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: fontFamily,
                                  color: textColor,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            SpaceHeight(height: 10),
            Expanded(
              child: ContentsBox(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                contentsWidget: ListView(
                  children: fontFamilyList
                      .map((item) => InkWell(
                            onTap: () => onTap(item['fontFamily']!),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['name']!.tr(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              fontFamily == item['fontFamily']!
                                                  ? textColor
                                                  : Colors.grey,
                                          fontFamily: item['fontFamily']!,
                                          fontWeight:
                                              fontFamily == item['fontFamily']!
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                      fontFamily == item['fontFamily']!
                                          ? CommonIcon(
                                              icon: Icons.task_alt_rounded,
                                              size: 16,
                                            )
                                          : const EmptyArea(),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 0.1,
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

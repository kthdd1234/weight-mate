// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_collections_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/reload_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class ThemeChangePage extends StatefulWidget {
  const ThemeChangePage({super.key});

  @override
  State<ThemeChangePage> createState() => _ThemeChangePageState();
}

class _ThemeChangePageState extends State<ThemeChangePage> {
  UserBox user = userRepository.user;

  // themes({
  //   required String path,
  //   required String name,
  //   required String theme,
  // }) {
  //   return

  // }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: valueListenables,
        builder: (context, values, child) {
          return CommonBackground(
            child: CommonScaffold(
              appBarInfo: AppBarInfoClass(title: '테마 변경'),
              body: ContentsBox(
                width: double.infinity,
                contentsWidget: SingleChildScrollView(
                  child: Column(
                    children: themeClassList
                        .map(
                          (themeList) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(children: [
                              ThemeItem(
                                path: themeList[0].path,
                                name: themeList[0].name,
                              ),
                              SpaceWidth(width: 20),
                              ThemeItem(
                                path: themeList[1].path,
                                name: themeList[1].name,
                              )
                            ]),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class ThemeItem extends StatefulWidget {
  ThemeItem({
    super.key,
    required this.path,
    required this.name,
  });

  String path, name;

  @override
  State<ThemeItem> createState() => _ThemeItemState();
}

class _ThemeItemState extends State<ThemeItem> {
  UserBox user = userRepository.user;

  @override
  Widget build(BuildContext context) {
    String theme = user.theme ?? '1';
    bool isPremium = context.watch<PremiumProvider>().isPremium;
    bool isReload = context.watch<ReloadProvider>().isReload;

    onTheme(String path) async {
      if (isPremium) {
        user.theme = path;
        await user.save();

        context.read<ReloadProvider>().setReload(!isReload);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertPopup(
            height: 185,
            text1: '프리미엄 구매 시',
            text2: '테마를 변경 할 수 있어요.',
            buttonText: '프리미엄 구매 페이지로 이동',
            onTap: () => Navigator.pushNamed(context, '/premium-page'),
          ),
        );
      }
    }

    return Expanded(
      child: InkWell(
        onTap: () => onTheme(widget.path),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/b-${widget.path}.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                widget.path == theme
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          MaskLabel(height: 200, opacity: 0.2),
                          Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 30,
                                  weight: 1,
                                ),
                                SpaceHeight(height: 5),
                                CommonName(
                                  text: '적용 중',
                                  color: Colors.white,
                                  isBold: true,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : const EmptyArea()
              ],
            ),
            SpaceHeight(height: 5),
            CommonName(
              text: widget.name,
              fontSize: 12,
              color: themeColor,
              isNotTr: true,
            )
          ],
        ),
      ),
    );
    ;
  }
}

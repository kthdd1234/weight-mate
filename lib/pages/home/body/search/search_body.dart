import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/search/widget/SearchInputBar.dart';
import 'package:flutter_app_weight_management/pages/home/body/search/widget/SearchItemContainer.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  TextEditingController searchKeywordController = TextEditingController();
  int initialScrollIndex = 0;

  onShowPurchasePremium() {
    showDialog(
      context: context,
      builder: (context) => AlertPopup(
        height: 185,
        buttonText: "프리미엄 구매 페이지로 이동",
        text1: '프리미엄 구매 시',
        text2: '검색 기능을 이용할 수 있어요',
        onTap: () => Navigator.pushNamed(context, '/premium-page'),
      ),
    );
  }

  onEditingComplete(bool isPremium) {
    FocusScope.of(context).unfocus();

    if (isPremium == false) {
      searchKeywordController.text = '';
      return onShowPurchasePremium();
    }

    if (searchKeywordController.text == '') {
      initialScrollIndex = 0;
    }

    setState(() {});
  }

  onHashTag(bool isPremium, String keyword) {
    if (isPremium == false) {
      return onShowPurchasePremium();
    }

    searchKeywordController.text = keyword;
    if (keyword == '') {
      initialScrollIndex = 0;
    } else if (keyword != '' && initialScrollIndex == 0) {
      UserBox user = userRepository.user;
      List<HashTagClass> userHashTagClassList =
          getHashTagClassList(user.hashTagList ?? []);

      initialScrollIndex = userHashTagClassList.indexWhere(
        (hashTag) => hashTag.text == keyword,
      );
    }

    setState(() {});
  }

  onSuffixIcon() {
    if (searchKeywordController.text != '') {
      searchKeywordController.text = '';
      initialScrollIndex = 0;
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertPopup(
          text1: '식단(기록/목표), 운동(기록/목표),',
          text2: '습관, 일기(글, 해시태그)',
          text3: '기준으로 검색돼요.',
          height: 206,
          buttonText: '확인',
          onTap: () => closeDialog(context),
        ),
      );
    }
  }

  onFocusOut() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;
    bool isPremium = context.watch<PremiumProvider>().isPremium;

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) => Column(
        children: [
          CommonAppBar(id: id),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            child: SearchInputBar(
              controller: searchKeywordController,
              onEditingComplete: () => onEditingComplete(isPremium),
              onSuffixIcon: onSuffixIcon,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchItemContainer(
                controller: searchKeywordController,
                initialScrollIndex: initialScrollIndex,
                onHashTag: (hashTag) => onHashTag(isPremium, hashTag),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

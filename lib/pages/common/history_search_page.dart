import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonTag.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/components/popup/DisplayPopup.dart';
import 'package:flutter_app_weight_management/components/search/SearchInputBar.dart';
import 'package:flutter_app_weight_management/components/search/SearchItemContainer.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/search_filter_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class HistorySearchPage extends StatefulWidget {
  const HistorySearchPage({super.key});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage> {
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
    bool isPremium = context.watch<PremiumProvider>().isPremium;

    return CommonBackground(
      child: CommonScaffold(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 15,
          right: 15,
          left: 15,
        ),
        appBarInfo: AppBarInfoClass(
          title: '히스토리 검색',
          isCenter: false,
          actions: [SearchHeaderBar()],
        ),
        body: MultiValueListenableBuilder(
          valueListenables: valueListenables,
          builder: (context, values, child) => Column(
            children: [
              SearchInputBar(
                controller: searchKeywordController,
                onEditingComplete: () => onEditingComplete(isPremium),
                onSuffixIcon: onSuffixIcon,
              ),
              Expanded(
                child: SearchItemContainer(
                  controller: searchKeywordController,
                  initialScrollIndex: initialScrollIndex,
                  onHashTag: (hashTag) => onHashTag(isPremium, hashTag),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchHeaderBar extends StatefulWidget {
  const SearchHeaderBar({super.key});

  @override
  State<SearchHeaderBar> createState() => _SearchHeaderBarState();
}

class _SearchHeaderBarState extends State<SearchHeaderBar> {
  UserBox user = userRepository.user;

  @override
  Widget build(BuildContext context) {
    List<String>? searchDisplayList = user.searchDisplayList;
    SearchFilter searchFilter =
        context.watch<SearchFilterProvider>().searchFilter;

    onTapSearchFilter() async {
      await showDialog(
        context: context,
        builder: (context) => DisplayPopup(
          height: 475,
          isRequiredWeight: false,
          bottomText: '표시하고 싶지 않은 카테고리는 체크 해제 하세요 :D'.tr(),
          classList: searchDisplayClassList,
          onChecked: (String filterId) {
            return user.searchDisplayList != null
                ? user.searchDisplayList!.contains(filterId)
                : false;
          },
          onTap: ({required dynamic id, required bool newValue}) {
            bool isSearchDisplayList = user.searchDisplayList != null;

            if (isSearchDisplayList) {
              newValue
                  ? user.searchDisplayList!.add(id)
                  : user.searchDisplayList!.remove(id);

              user.save();
              setState(() {});
            }
          },
        ),
      );
    }

    onTapSearchOrder() {
      context.read<SearchFilterProvider>().setSearchFilter(
            nextSearchFilter[searchFilter]!,
          );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        children: [
          CommonTag(
            text: searchFilterFormats[searchFilter],
            color: 'whiteIndigo',
            onTap: onTapSearchOrder,
          ),
          SpaceWidth(width: 5),
          CommonTag(
            text: '표시',
            color: 'whiteIndigo',
            nameArgs: {'length': '${searchDisplayList?.length ?? 0}'},
            onTap: onTapSearchFilter,
          ),
        ],
      ),
    );
  }
}

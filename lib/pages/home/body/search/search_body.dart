import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/pages/home/body/search/widget/SearchItemBar.dart';
import 'package:flutter_app_weight_management/pages/home/body/search/widget/SearchItemList.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  TextEditingController searchKeywordController = TextEditingController();

  onChanged(_) {
    setState(() {});
  }

  onEditingComplete() {
    // context.read<KeywordProvider>().changeKeyword(textEditingController.text);
    FocusScope.of(context).unfocus();
  }

  onSuffixIcon() {
    if (searchKeywordController.text != '') {
      searchKeywordController.text = '';

      setState(() {});
    } else {
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertPopup(
      //     desc:
      //         '${ymdFullFormatter(locale: context.locale.toString(), dateTime: DateTime.now())}\n 이전 내역만 검색돼요.',
      //     buttonText: '확인',
      //     height: 175,
      //     onTap: () => navigatorPop(context),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;

    return Column(
      children: [
        CommonAppBar(id: id),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              SearchItemBar(
                controller: searchKeywordController,
                onChanged: onChanged,
                onEditingComplete: onEditingComplete,
                onSuffixIcon: onSuffixIcon,
              ),
              SearchItemList(controller: searchKeywordController),
            ],
          ),
        ),
      ],
    );
  }
}

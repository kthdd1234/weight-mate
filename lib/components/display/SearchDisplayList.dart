import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/display/DisplayListContents.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SearchDisplayList extends StatefulWidget {
  const SearchDisplayList({super.key});

  @override
  State<SearchDisplayList> createState() => _SearchDisplayListState();
}

class _SearchDisplayListState extends State<SearchDisplayList> {
  UserBox user = userRepository.user;

  onTap({required dynamic id, required bool newValue}) {
    bool isSearchDisplayList = user.searchDisplayList != null;

    if (isSearchDisplayList) {
      newValue
          ? user.searchDisplayList!.add(id)
          : user.searchDisplayList!.remove(id);

      user.save();
      setState(() {});
    }
  }

  bool onChecked(String filterId) {
    return user.searchDisplayList != null
        ? user.searchDisplayList!.contains(filterId)
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return DisplayListContents(
      isRequiredWeight: false,
      bottomText: '표시하고 싶지 않은 카테고리는 체크 해제 하세요 :D'.tr(),
      classList: searchDisplayClassList,
      onChecked: onChecked,
      onTap: onTap,
    );
  }
}

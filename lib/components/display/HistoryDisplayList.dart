import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/display/DisplayListContents.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistoryDisplayList extends StatefulWidget {
  const HistoryDisplayList({super.key});

  @override
  State<HistoryDisplayList> createState() => _HistoryDisplayListState();
}

class _HistoryDisplayListState extends State<HistoryDisplayList> {
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? historyDisplayList = user.historyDisplayList;

    onTap({required dynamic id, required bool newValue}) {
      bool ishistoryDisplayList = user.historyDisplayList != null;

      if (ishistoryDisplayList) {
        newValue
            ? user.historyDisplayList!.add(id)
            : user.historyDisplayList!.remove(id);

        user.save();
        setState(() {});
      }
    }

    onChecked(String filterId) {
      return historyDisplayList != null
          ? historyDisplayList.contains(filterId)
          : false;
    }

    return DisplayListContents(
      isRequiredWeight: false,
      bottomText: '표시하고 싶지 않은 카테고리는 체크 해제 하세요 :D'.tr(),
      classList: historyDisplayClassList,
      onChecked: onChecked,
      onTap: onTap,
    );
  }
}

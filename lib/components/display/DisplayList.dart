import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/display/DisplayListContents.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DisplayList extends StatefulWidget {
  const DisplayList({super.key});

  @override
  State<DisplayList> createState() => _DisplayListState();
}

class _DisplayListState extends State<DisplayList> {
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? displayList = user.displayList;

    onTap({required dynamic id, required bool newValue}) {
      bool isNotWeight = displayClassList.first.id != id;
      bool isdisplayList = user.displayList != null;

      if (isNotWeight && isdisplayList) {
        newValue ? user.displayList!.add(id) : user.displayList!.remove(id);
        user.save();

        setState(() {});
      }
    }

    onChecked(String filterId) {
      if (displayClassList.first.id == filterId) {
        return true;
      }

      return displayList != null ? displayList.contains(filterId) : false;
    }

    return DisplayListContents(
      isRequiredWeight: true,
      bottomText: '사용하지 않는 카테고리는 체크 해제 하세요 :D'.tr(),
      classList: displayClassList,
      onChecked: onChecked,
      onTap: onTap,
    );
  }
}

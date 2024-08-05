import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class AppStartBottomSheet extends StatefulWidget {
  const AppStartBottomSheet({super.key});

  @override
  State<AppStartBottomSheet> createState() => _AppStartBottomSheetState();
}

class _AppStartBottomSheetState extends State<AppStartBottomSheet> {
  onTap(int index) async {
    UserBox? user = userRepository.user;
    user.appStartIndex = index;

    await user.save();
    closeDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    UserBox? user = userRepository.user;
    int appStartIndex = user.appStartIndex ?? 0;

    return CommonBottomSheet(
      title: '앱 시작 화면',
      height: 200,
      contents: Row(
        children: bnList
            .map(
              (bn) => bn.index != 4
                  ? ExpandedButtonVerti(
                      outterPadding: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 90,
                      icon: bn.icon,
                      title: bn.name,
                      isBold: appStartIndex == bn.index,
                      mainColor: appStartIndex == bn.index
                          ? Colors.white
                          : grey.original,
                      backgroundColor:
                          appStartIndex == bn.index ? themeColor : Colors.white,
                      onTap: () => onTap(bn.index),
                    )
                  : const EmptyArea(),
            )
            .toList(),
      ),
    );
  }
}

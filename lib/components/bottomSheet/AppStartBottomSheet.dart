import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/ModalButton.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
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
        children: getBnClassList(appStartIndex)
            .map(
              (bn) => bn.index != 4
                  ? ModalButton(
                      innerPadding: const EdgeInsets.only(right: 5),
                      svgName: bn.svgName,
                      actionText: bn.name,
                      isBold: bn.index == appStartIndex,
                      color: bn.index == appStartIndex
                          ? Colors.white
                          : grey.original,
                      bgColor:
                          bn.index == appStartIndex ? themeColor : Colors.white,
                      onTap: () => onTap(bn.index),
                    )
                  : const EmptyArea(),
            )
            .toList(),
      ),
    );
  }
}

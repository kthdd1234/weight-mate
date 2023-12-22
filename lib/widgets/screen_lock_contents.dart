import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ScreenLockContents extends StatelessWidget {
  ScreenLockContents(
      {super.key,
      required this.passwords,
      required this.passwordMsg,
      required this.passwordErrMsg,
      required this.onTap,
      this.isExit});

  List<String> passwords;
  String passwordMsg, passwordErrMsg;
  bool? isExit;
  Function(String button, int index) onTap;

  @override
  Widget build(BuildContext context) {
    List<String> buttonList = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '취소',
      '0',
      '지우기'
    ];

    passwordWidgets() {
      widget(int index) {
        final color = passwords[index] == '' ? typeBackgroundColor : themeColor;

        return Row(
          children: [
            Icon(Icons.lens, color: color, size: 30),
            SpaceWidth(width: smallSpace)
          ],
        );
      }

      return [widget(0), widget(1), widget(2), widget(3)];
    }

    gridViewWideget() {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemCount: buttonList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onTap(buttonList[index], index),
          child: TextIcon(
            backgroundColor: typeBackgroundColor,
            text: buttonList[index],
            borderRadius: 100,
            textColor: isExit == false
                ? index == 9
                    ? Colors.transparent
                    : themeColor
                : themeColor,
            fontSize: index == 9 || index == 11 ? 14 : 20,
            onTap: () => onTap(buttonList[index], index),
          ),
        ),
      );
    }

    return Padding(
      padding: pagePadding,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpaceHeight(height: largeSpace + largeSpace),
            Text(
              passwordMsg,
              style: const TextStyle(
                color: themeColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SpaceHeight(height: regularSapce),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: passwordWidgets(),
            ),
            Column(
              children: [
                SpaceHeight(height: regularSapce),
                Text(
                  passwordErrMsg,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            SpaceHeight(height: regularSapce),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: gridViewWideget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

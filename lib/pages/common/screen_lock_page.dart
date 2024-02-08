import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenLockPage extends StatefulWidget {
  const ScreenLockPage({super.key});

  @override
  State<ScreenLockPage> createState() => _ScreenLockPageState();
}

class _ScreenLockPageState extends State<ScreenLockPage> {
  List<String> newPasswords = ['', '', '', ''];
  List<String> confirmPasswords = ['', '', '', ''];
  bool isConfirmPassword = false;
  bool isErrorPassword = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    UserBox? user = userRepository.user;
    List<String> passwords =
        isConfirmPassword ? confirmPasswords : newPasswords;

    onTap(int index) {
      log('$index');
      switch (index) {
        case 10:
          Navigator.pop(context);
          break;

        case 12:
          setState(() {
            if (count > 0) {
              count -= 1;
            }

            passwords[count] = '';
          });

          break;

        default:
          setState(() {
            if (count < 5) {
              passwords[count] = index.toString();
              count += 1;

              if (count == 4) {
                if (isConfirmPassword) {
                  final newPasswordStr = newPasswords.join();
                  final confirmPasswordStr = confirmPasswords.join();

                  if (newPasswordStr == confirmPasswordStr) {
                    user.screenLockPasswords = confirmPasswordStr;
                    user.save();

                    Navigator.pop(context);
                  }

                  isErrorPassword = true;
                  confirmPasswords = ['', '', '', ''];
                }

                isConfirmPassword = true;
                count = 0;
              }
            }
          });

          break;
      }
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
          elevation: 0.0,
          title: const Text('화면 잠금').tr(),
        ),
        body: ScreenLockContents(
          passwords: passwords,
          passwordMsg: isConfirmPassword ? confirmPasswordMsg : newPasswordMsg,
          passwordErrMsg: isErrorPassword ? passwrodErrorMsg1 : '',
          onTap: onTap,
        ),
      ),
    );
  }
}

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
  Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    List<List<int>> lists = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [10, 0, 12]
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

    text(int index) {
      if (isExit == false && index == 10) {
        return '';
      }

      return index == 10
          ? '취소'
          : index == 12
              ? '지우기'
              : index.toString();
    }

    wRow(List<int> list) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list
            .map((index) => GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: typeBackgroundColor,
                      child: CommonText(
                        text: text(index),
                        isNotTr: !(index == 10 || index == 12),
                        size: index == 10 || index == 12 ? 12 : 14,
                        isBold: true,
                        isCenter: true,
                      ),
                    ),
                  ),
                ))
            .toList(),
      );
    }

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                text: passwordMsg,
                size: 15,
                isBold: true,
                isCenter: true,
              ),
              SpaceHeight(height: regularSapce),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: passwordWidgets(),
              ),
              SpaceHeight(height: regularSapce),
              CommonText(
                text: passwordErrMsg,
                size: 14,
                color: Colors.red,
                isCenter: true,
              ),
              SpaceHeight(height: 60),
              Column(children: [
                wRow(lists[0]),
                wRow(lists[1]),
                wRow(lists[2]),
                wRow(lists[3])
              ])
            ],
          ),
        ),
      ),
    );
  }
}

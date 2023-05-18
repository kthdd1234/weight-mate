import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

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

  final newPasswordMsg = '새 비밀번호 입력해주세요.';
  final confirmPasswordMsg = '비밀번호를 한번 더 입력해주세요.';
  final passwrodErrorMsg1 = '비밀번호가 일치하지 않습니다.';
  final passwrodErrorMsg2 = '처음부터 다시 시도해주세요.';

  @override
  Widget build(BuildContext context) {
    final passwords = isConfirmPassword ? confirmPasswords : newPasswords;

    passwordWidgets() {
      widget(int index) {
        final color = passwords[index] == ''
            ? typeBackgroundColor
            : buttonBackgroundColor;

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

      onTap(String button, int index) {
        switch (index) {
          case 9:
            Navigator.pop(context);
            break;

          case 11:
            setState(() {
              if (count > 0) count -= 1;
              passwords[count] = '';
            });

            break;

          default:
            setState(() {
              if (count < 5) {
                passwords[count] = button;
                count += 1;

                if (count == 4) {
                  if (isConfirmPassword) {
                    final newPasswordStr = newPasswords.join();
                    final confirmPasswordStr = confirmPasswords.join();

                    newPasswordStr == confirmPasswordStr
                        ? Navigator.pop(context)
                        : isErrorPassword = true;

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

      return GridView.builder(
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
            textColor: buttonBackgroundColor,
            fontSize: index == 9 || index == 11 ? 14 : 20,
          ),
        ),
      );
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: buttonBackgroundColor,
          elevation: 0.0,
          title: const Text('화면 잠금'),
        ),
        body: Padding(
          padding: pagePadding,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpaceHeight(height: largeSpace + largeSpace),
                Text(
                  isConfirmPassword ? confirmPasswordMsg : newPasswordMsg,
                  style: const TextStyle(
                    color: buttonBackgroundColor,
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
                      isErrorPassword ? passwrodErrorMsg1 : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                    SpaceHeight(height: tinySpace),
                    Text(
                      isErrorPassword ? passwrodErrorMsg2 : '',
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
        ),
      ),
    );
  }
}

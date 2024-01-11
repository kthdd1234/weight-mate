import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenLockPage extends StatefulWidget {
  const ScreenLockPage({super.key});

  @override
  State<ScreenLockPage> createState() => _ScreenLockPageState();
}

class _ScreenLockPageState extends State<ScreenLockPage> {
  late Box<UserBox> userBox;

  List<String> newPasswords = ['', '', '', ''];
  List<String> confirmPasswords = ['', '', '', ''];
  bool isConfirmPassword = false;
  bool isErrorPassword = false;
  int count = 0;

  String newPasswordMsg = '새 비밀번호를 입력해주세요.';
  String confirmPasswordMsg = '비밀번호를 한번 더 입력해주세요.';
  String passwrodErrorMsg1 = '비밀번호가 일치하지 않습니다.';

  @override
  void initState() {
    userBox = Hive.box('userBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox? userProfile = userBox.get('userProfile');
    List<String> passwords =
        isConfirmPassword ? confirmPasswords : newPasswords;

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

                  if (newPasswordStr == confirmPasswordStr) {
                    userProfile?.screenLockPasswords = confirmPasswordStr;
                    userProfile?.save();

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
          title: const Text('화면 잠금'),
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

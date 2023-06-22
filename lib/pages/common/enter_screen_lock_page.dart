import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/screen_lock_contents.dart';
import 'package:hive/hive.dart';

class EnterScreenLockPage extends StatefulWidget {
  const EnterScreenLockPage({super.key});

  @override
  State<EnterScreenLockPage> createState() => _EnterScreenLockPageState();
}

class _EnterScreenLockPageState extends State<EnterScreenLockPage> {
  late Box<UserBox> userBox;

  bool isError = false;
  List<String> passwords = ['', '', '', ''];
  int count = 0;

  @override
  void initState() {
    userBox = Hive.box('userBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBox? userProfile = userBox.get('userProfile');

    onTap(String button, int index) {
      switch (index) {
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
                if (userProfile == null) return;

                String screenLockPasswords = userProfile.screenLockPasswords!;
                String inputPasswordStr = passwords.join();

                if (screenLockPasswords == inputPasswordStr) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }

                isError = true;
                passwords = ['', '', '', ''];
                count = 0;
              }
            }
          });
      }
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: buttonBackgroundColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: ScreenLockContents(
          passwords: passwords,
          passwordMsg: '비밀번호를 입력해주세요.',
          passwordErrMsg: isError ? '비밀번호가 일치하지 않습니다.' : '',
          isExit: false,
          onTap: onTap,
        ),
      ),
    );
  }
}

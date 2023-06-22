import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/screen_lock_contents.dart';
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
          foregroundColor: buttonBackgroundColor,
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

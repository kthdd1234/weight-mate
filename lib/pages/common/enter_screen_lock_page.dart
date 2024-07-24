import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/common/screen_lock_page.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';
import '../../model/user_box/user_box.dart';

class EnterScreenLockPage extends StatefulWidget {
  EnterScreenLockPage({super.key, this.isPop});

  bool? isPop;

  @override
  State<EnterScreenLockPage> createState() => _EnterScreenLockPageState();
}

class _EnterScreenLockPageState extends State<EnterScreenLockPage> {
  List<String> inputPasswords = ['', '', '', ''];
  List<String> userPasswords = ['', '', '', ''];
  RecordBox? recordInfo;
  bool isError = false;
  int count = 0;

  @override
  void initState() {
    Box<UserBox> userBox = Hive.box('userBox');
    Box<RecordBox> recordBox = Hive.box('recordBox');
    UserBox? userProfile = userBox.get('userProfile');
    DateTime now = DateTime.now();
    int recordKey = getDateTimeToInt(now);
    recordInfo = recordBox.get(recordKey);

    if (userProfile == null) return;
    userPasswords = userProfile.screenLockPasswords!.split('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTap(int index) {
      switch (index) {
        case 12:
          setState(() {
            if (count > 0) count -= 1;
            inputPasswords[count] = '';
          });
          break;

        default:
          setState(() {
            if (count < 5) {
              inputPasswords[count] = index.toString();
              count += 1;

              if (count == 4) {
                if (userPasswords.join() == inputPasswords.join()) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home-page',
                    (route) => false,
                  );
                } else {
                  isError = true;
                  inputPasswords = ['', '', '', ''];
                  count = 0;
                }
              }
            }
          });
      }
    }

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(
          title: '',
          automaticallyImplyLeading: false,
        ),
        body: ScreenLockContents(
          passwords: inputPasswords,
          passwordMsg: '비밀번호를 입력해주세요.',
          passwordErrMsg: isError ? '비밀번호가 일치하지 않습니다.' : '',
          isExit: false,
          onTap: onTap,
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/screen_lock_contents.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../model/user_box/user_box.dart';

class EnterScreenLockPage extends StatefulWidget {
  const EnterScreenLockPage({super.key});

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
    recordInfo = recordBox.get(getDateTimeToInt(DateTime.now()));

    if (userProfile == null) return;
    userPasswords = userProfile.screenLockPasswords!.split('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTap(String button, int index) {
      switch (index) {
        case 11:
          setState(() {
            if (count > 0) count -= 1;
            inputPasswords[count] = '';
          });
          break;

        default:
          setState(() {
            if (count < 5) {
              inputPasswords[count] = button;
              count += 1;

              if (count == 4) {
                if (userPasswords.join() == inputPasswords.join()) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home-container',
                    (route) => false,
                  );

                  if (recordInfo == null || recordInfo!.weight == null) {
                    context
                        .read<ImportDateTimeProvider>()
                        .setImportDateTime(DateTime.now());
                    // context
                    //     .read<RecordIconTypeProvider>()
                    //     .setSeletedRecordIconType(RecordIconTypes.addWeight);
                  }
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

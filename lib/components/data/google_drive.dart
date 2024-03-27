// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_analyze_page.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/services/google_drive_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hive/hive.dart';

class GoogleDriveContainer extends StatefulWidget {
  const GoogleDriveContainer({super.key});

  @override
  State<GoogleDriveContainer> createState() => _GoogleDriveContainerState();
}

class _GoogleDriveContainerState extends State<GoogleDriveContainer> {
  final GoogleDriveAppData _googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? _googleUser;
  drive.DriveApi? _driveApi;

  Future<DateTime?> backupDateTime() async {
    final driveFile = await _googleDriveAppData.getDriveFile(
      _driveApi!,
      'userbox.hive',
    );

    return driveFile?.modifiedTime?.toLocal();
  }

  Future<void> googleDriveLogin() async {
    String locale = context.locale.toString();
    UserBox user = userRepository.user;

    _googleUser = await _googleDriveAppData.signInGoogle();

    if (_googleUser != null) {
      _driveApi = await _googleDriveAppData.getDriveApi(_googleUser!);

      if (user.googleDriveInfo == null) {
        user.googleDriveInfo = {
          "backupDateTime": ymdeHm(
            locale: locale,
            dateTime: await backupDateTime(),
          ),
          MateHiveBox.userBox: null,
          MateHiveBox.recordBox: null,
          MateHiveBox.planBox: null,
        };
      } else {
        user.googleDriveInfo!['backupDateTime'] = ymdeHm(
          locale: locale,
          dateTime: await backupDateTime(),
        );
      }

      await user.save();
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    await googleDriveLogin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    UserBox user = userRepository.user;
    Map<String, dynamic>? googleDriveInfo = user.googleDriveInfo;
    String introText =
        '구글 드라이브에 앱의 데이터를 주기적으로 백업하면 핸드폰을 바꾸거나 앱 삭제 후 다시 설치 했을 때도 기존의 데이터를 복구 할 수 있어요.';
    String loginText = 'Google 로그인 후 데이터 백업 또는 복원을 해주세요.';

    onLogin() async {
      await googleDriveLogin();
    }

    onLogout() async {
      await _googleDriveAppData.signOut();

      _googleUser = null;
      _driveApi = null;

      setState(() {});
    }

    onBackup() async {
      Box<UserBox> userBox = await Hive.openBox<UserBox>(MateHiveBox.userBox);
      Box<RecordBox> recordBox =
          await Hive.openBox<RecordBox>(MateHiveBox.recordBox);
      Box<PlanBox> planBox = await Hive.openBox<PlanBox>(MateHiveBox.planBox);

      File userFile = File(userBox.path!);
      File recordFile = File(recordBox.path!);
      File planFile = File(planBox.path!);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingDialog(
          text: '구글 드라이브에 백업 중..\n(앱에 데이터가 많을 경우 시간이 오래 걸려요)',
          color: Colors.white,
        ),
      );

      try {
        if (_driveApi != null) {
          DriveFileClass dUser = await _googleDriveAppData.uploadDriveFile(
            driveApi: _driveApi!,
            file: userFile,
            driveFileId: googleDriveInfo![MateHiveBox.userBox],
          );
          DriveFileClass dRecord = await _googleDriveAppData.uploadDriveFile(
            driveApi: _driveApi!,
            file: recordFile,
            driveFileId: googleDriveInfo[MateHiveBox.recordBox],
          );
          DriveFileClass dPlan = await _googleDriveAppData.uploadDriveFile(
            driveApi: _driveApi!,
            file: planFile,
            driveFileId: googleDriveInfo[MateHiveBox.planBox],
          );

          if (dUser.errorCode == 401) {
            log('401 에러 발생! => $dUser');

            await onLogout();
            await onLogin();
            await onBackup();

            return;
          }

          if (googleDriveInfo[MateHiveBox.userBox] == null) {
            googleDriveInfo[MateHiveBox.userBox] = dUser.driveFile?.id;
          }

          if (googleDriveInfo[MateHiveBox.recordBox] == null) {
            googleDriveInfo[MateHiveBox.recordBox] = dRecord.driveFile?.id;
          }

          if (googleDriveInfo[MateHiveBox.planBox] == null) {
            googleDriveInfo[MateHiveBox.planBox] = dPlan.driveFile?.id;
          }

          googleDriveInfo['backupDateTime'] = ymdeHm(
            locale: locale,
            dateTime: await backupDateTime(),
          );

          await user.save();

          setState(() {});
        }
      } finally {
        closeDialog(context);
      }
    }

    onRestore() {
      //
    }

    log('googleDriveInfo => ${user.googleDriveInfo}');

    return ContentsBox(
      contentsWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentsTitle(title: 'Google Drive 백업/복원', svg: "google-drive"),
          TextData(text: introText),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 0.5, color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(7),
              ),
              child: _googleUser == null
                  ? Center(child: TextData(text: loginText))
                  : GoogleDriveInfo(
                      email: _googleUser!.email,
                      backupDateTime:
                          googleDriveInfo?['backupDateTime'] ?? '없음',
                    ),
            ),
          ),
          _googleUser == null
              ? GoogleDriveLogin(onLogin: onLogin)
              : GoogleDriveService(
                  onBackup: onBackup,
                  onRestore: onRestore,
                  onLogout: onLogout,
                )
        ],
      ),
    );
  }
}

class TextData extends StatelessWidget {
  TextData({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }
}

class GoogleDriveLogin extends StatelessWidget {
  GoogleDriveLogin({super.key, required this.onLogin});

  Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExpandedButtonHori(
          borderRadius: 7,
          padding: const EdgeInsets.symmetric(vertical: 15),
          imgUrl: 'assets/images/t-23.png',
          text: 'Google 로그인',
          onTap: onLogin,
        )
      ],
    );
  }
}

class GoogleDriveService extends StatelessWidget {
  GoogleDriveService({
    super.key,
    required this.onBackup,
    required this.onRestore,
    required this.onLogout,
  });

  Function() onBackup;
  Function() onRestore;
  Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onLogout,
          child: Center(
            child: Text(
              '연동 해제'.tr(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: Colors.grey,
              ),
            ),
          ),
        ),
        SpaceHeight(height: 15),
        Row(
          children: [
            ExpandedButtonHori(
              borderRadius: 7,
              padding: const EdgeInsets.symmetric(vertical: 15),
              imgUrl: 'assets/images/t-22.png',
              text: '데이터 백업',
              onTap: onBackup,
            ),
            SpaceWidth(width: 5),
            ExpandedButtonHori(
              borderRadius: 7,
              padding: const EdgeInsets.symmetric(vertical: 15),
              imgUrl: 'assets/images/t-23.png',
              text: '데이터 복원',
              onTap: onRestore,
            ),
          ],
        ),
      ],
    );
  }
}

class GoogleDriveInfo extends StatelessWidget {
  GoogleDriveInfo({
    super.key,
    required this.email,
    required this.backupDateTime,
  });

  String email;
  String backupDateTime;

  @override
  Widget build(BuildContext context) {
    rowInfo({required String title, required String text}) {
      return Row(
        children: [
          CommonText(text: title, size: 13, color: Colors.grey),
          SpaceWidth(width: 10),
          CommonText(text: text, size: 13, color: themeColor, isNotTr: true)
        ],
      );
    }

    return Column(
      children: [
        rowInfo(title: '구글 계정', text: email),
        SpaceHeight(height: 5),
        rowInfo(title: '백업 내역', text: backupDateTime),
      ],
    );
  }
}

// showSnackBar(String text) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
// }

// try {
//   final GoogleSignIn googleSignIn = GoogleSignIn(
//     clientId: iosClientId,
//     scopes: [ga.DriveApi.driveFileScope],
//   );

//   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//   if (googleUser != null) {
//     final auth.AuthClient? cleint =
//         await googleSignIn.authenticatedClient();
//     final drive = ga.DriveApi(cleint!);

//     final fileData = await backupHiveBox(MateHiveBox.userBox);

//     if (fileData != null) {
//       await drive.files.create(
//         fileData.fileToUpload,
//         uploadMedia: ga.Media(
//           fileData.file.openRead(),
//           fileData.file.lengthSync(),
//         ),
//       );

//       if (fileData.file.existsSync()) {
//         fileData.file.deleteSync();
//       }
//     }
//   } else {
//     if (context.mounted) {
//       showSnackBar('Failed to sign in');
//     }
//   }
// } catch (e) {
//   if (context.mounted) {
//     showSnackBar(e.toString());
//   }
// }

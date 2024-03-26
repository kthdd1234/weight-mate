import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_analyze_page.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/services/google_drive_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
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
  Map<String, String?> _fileInfo = {"id": null, "name": null};

  @override
  Widget build(BuildContext context) {
    const introText =
        '구글 드라이브에 앱의 데이터를 주기적으로 백업하면 핸드폰을 바꾸거나 앱 삭제 후 다시 설치 했을 때도 기존의 데이터를 복구 할 수 있어요.';
    const loginText = 'Google 로그인 후 데이터 백업 또는 복원을 해주세요.';

    onLogin() async {
      _googleUser = await _googleDriveAppData.signInGoogle();

      if (_googleUser != null) {
        _driveApi = await _googleDriveAppData.getDriveApi(_googleUser!);
      }

      setState(() {});
    }

    onLogout() async {
      await _googleDriveAppData.signOut();

      _googleUser = null;
      _driveApi = null;
      _fileInfo = {"id": null, "name": null};

      setState(() {});
    }

    onBackup() async {
      Box<UserBox> userBox = await Hive.openBox<UserBox>(MateHiveBox.userBox);
      File userFile = File(userBox.path!);

      if (_driveApi != null) {
        final uploadfile = await _googleDriveAppData.uploadDriveFile(
          driveApi: _driveApi!,
          file: userFile,
          driveFileId: _fileInfo['id'],
        );

        _fileInfo = {"id": uploadfile?.id, "name": uploadfile?.name};

        log('uploadfile => ${uploadfile?.id}');

        setState(() {});
      }
    }

    onRestore() {
      //
    }

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
                      backupDateTime: '2024.3.19 오후 11:15',
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

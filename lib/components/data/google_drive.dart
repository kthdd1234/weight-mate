import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/common/weight_analyze_page.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class GoogleDriveContainer extends StatefulWidget {
  const GoogleDriveContainer({super.key});

  @override
  State<GoogleDriveContainer> createState() => _GoogleDriveContainerState();
}

class _GoogleDriveContainerState extends State<GoogleDriveContainer> {
  @override
  Widget build(BuildContext context) {
    accountInfo({required String title, required String text}) {
      return Row(
        children: [
          CommonText(text: title, size: 13, color: Colors.grey),
          SpaceWidth(width: 10),
          CommonText(text: text, size: 13, color: themeColor)
        ],
      );
    }

    onTapBackup() {
      //
    }

    onTapRestore() {
      //
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitle(title: 'Google Drive 백업/복원', svg: "google-drive"),
          const Text(
            '구글 드라이브에 앱의 데이터를 주기적으로 백업하면 핸드폰을 바꾸거나 앱 삭제 후 다시 설치 했을 때도 기존의 데이터를 복구 할 수 있어요.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 0.5, color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(children: [
                accountInfo(title: '계정', text: 'kthdd1234@gmail.com'),
                SpaceHeight(height: 5),
                accountInfo(title: '백업', text: '2024.3.19 오후 11:15'),
              ]),
            ),
          ),
          Text(
            '연동 해제',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
            ),
          ),
          SpaceHeight(height: 15),
          Row(
            children: [
              ExpandedButtonHori(
                  borderRadius: 7,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  imgUrl: 'assets/images/t-22.png',
                  text: '데이터 백업',
                  onTap: onTapBackup),
              SpaceWidth(width: 5),
              ExpandedButtonHori(
                  borderRadius: 7,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  imgUrl: 'assets/images/t-23.png',
                  text: '데이터 복원',
                  onTap: onTapRestore),
            ],
          )
        ],
      ),
    );
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  uploadToGoogleDrive() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        scopes: [ga.DriveApi.driveFileScope],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final auth.AuthClient? cleint =
            await googleSignIn.authenticatedClient();
        final drive = ga.DriveApi(cleint!);
        final fileData = await backupHiveBox(MateHiveBox.userBox);

        if (fileData != null) {
          await drive.files.create(
            fileData.fileToUpload,
            uploadMedia:
                ga.Media(fileData.file.openRead(), fileData.file.lengthSync()),
          );

          if (fileData.file.existsSync()) {
            fileData.file.deleteSync();
          }
        }
      } else {
        if (context.mounted) {
          showSnackBar('Failed to sign in');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(e.toString());
      }
    }
  }
}

// class AccountLinkContainer extends StatelessWidget {
//   const AccountLinkContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: ContentsBox(
//         contentsWidget: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ContentsTitle(title: 'Google Drive 연동 상태', svg: "google-drive"),
//             wText('구글 드라이브에 연동 되지 않은 상태에요.'),
//             SpaceHeight(height: 2),
//             wText('데이터 백업 또는 복원을 통해 구글 드라이브를 연동해보세요.'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BackUpContainer extends StatelessWidget {
//   const BackUpContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: ContentsBox(
//         contentsWidget: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ContentsTitle(title: '데이터 백업', svg: "cloud-backup"),
//             wText('Google Drive 에 앱의 데이터를 수동으로 백업할 수 있어요.')
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RestoreContainer extends StatelessWidget {
//   const RestoreContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ContentsBox(
//       contentsWidget: Column(
//         children: [
//           ContentsTitle(title: '데이터 복원', svg: "cloud-restore"),
//         ],
//       ),
//     );
//   }
// }

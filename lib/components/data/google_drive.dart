import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
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
    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitle(title: '데이터 백업', svg: "cloud-data"),
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
        final fileToUpload = await backupHiveBox(MateHiveBox.userBox);

        if (fileToUpload != null) {
          await drive.files.create(fileToUpload);
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

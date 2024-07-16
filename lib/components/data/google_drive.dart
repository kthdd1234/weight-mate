// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_analyze_page.dart';
import 'package:flutter_app_weight_management/provider/reload_provider.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:flutter_app_weight_management/services/google_drive_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class GoogleDriveContainer extends StatefulWidget {
  const GoogleDriveContainer({super.key});

  @override
  State<GoogleDriveContainer> createState() => _GoogleDriveContainerState();
}

class _GoogleDriveContainerState extends State<GoogleDriveContainer> {
  final GoogleDriveAppData _googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? _googleUser;
  drive.DriveApi? _driveApi;

  Future<DriveFileIdsClass> getDriveFileIds(drive.DriveApi driveApi) async {
    final userFileId =
        await _googleDriveAppData.getDriveFile(driveApi, 'userbox.hive');
    final recordFileId =
        await _googleDriveAppData.getDriveFile(driveApi, 'recordbox.hive');
    final planFileId =
        await _googleDriveAppData.getDriveFile(driveApi, 'planbox.hive');

    return DriveFileIdsClass(
      userFileId: userFileId?.id,
      recordFileId: recordFileId?.id,
      planFileId: planFileId?.id,
    );
  }

  Future<HiveBoxPathsClass> getHiveBoxPaths() async {
    Box<UserBox> userBox = await Hive.openBox<UserBox>(MateHiveBox.userBox);
    Box<RecordBox> recordBox =
        await Hive.openBox<RecordBox>(MateHiveBox.recordBox);
    Box<PlanBox> planBox = await Hive.openBox<PlanBox>(MateHiveBox.planBox);

    return HiveBoxPathsClass(
      userBoxPath: userBox.path!,
      recordBoxPath: recordBox.path!,
      planBoxPath: planBox.path!,
    );
  }

  Future<DateTime?> backupDateTime() async {
    final driveFile = await _googleDriveAppData.getDriveFile(
      _driveApi!,
      'userbox.hive',
    );

    return driveFile?.modifiedTime?.toLocal();
  }

  Future<void> googleDriveLogin() async {
    UserBox user = userRepository.user;

    _googleUser = await _googleDriveAppData.signInGoogle();

    log('googleDriveLogin googleDriveInfo => ${user.googleDriveInfo}');

    if (_googleUser != null) {
      _driveApi = await _googleDriveAppData.getDriveApi(_googleUser!);

      user.googleDriveInfo!['isLogin'] = true;
      user.googleDriveInfo!['backupDateTime'] = await backupDateTime();
    }

    await user.save();
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    UserBox user = userRepository.user;

    if (user.googleDriveInfo?['isLogin'] == true) {
      await googleDriveLogin();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    UserBox user = userRepository.user;
    Map<String, dynamic>? googleDriveInfo = user.googleDriveInfo;
    String introText =
        '구글 드라이브에 데이터를 백업하면 핸드폰을 바꾸거나 앱 삭제 후 다시 설치 했을 때도 기존의 데이터를 복구 할 수 있어요.';
    String loginText = 'Google 로그인 후 데이터 백업 또는 복원을 해주세요.';

    onLogin() async {
      await googleDriveLogin();
    }

    onLogout() async {
      await _googleDriveAppData.signOut();

      _googleUser = null;
      _driveApi = null;

      user.googleDriveInfo?['isLogin'] = false;
      await user.save();

      setState(() {});
    }

    onBackup() async {
      HiveBoxPathsClass hiveBoxPaths = await getHiveBoxPaths();

      File userFile = File(hiveBoxPaths.userBoxPath);
      File recordFile = File(hiveBoxPaths.recordBoxPath);
      File planFile = File(hiveBoxPaths.planBoxPath);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingDialog(
          text: '구글 드라이브에 백업 중..',
          subText: '(앱에 데이터가 많을 경우 시간이 오래 걸려요)',
          color: Colors.white,
        ),
      );

      try {
        if (_driveApi != null) {
          DriveFileIdsClass driveFileIds = await getDriveFileIds(_driveApi!);

          await _googleDriveAppData.uploadDriveFile(
            driveApi: _driveApi!,
            file: userFile,
            driveFileId: driveFileIds.userFileId,
          );

          await _googleDriveAppData.uploadDriveFile(
            driveApi: _driveApi!,
            file: recordFile,
            driveFileId: driveFileIds.recordFileId,
          );

          await _googleDriveAppData.uploadDriveFile(
            driveApi: _driveApi!,
            file: planFile,
            driveFileId: driveFileIds.planFileId,
          );

          googleDriveInfo!['backupDateTime'] = await backupDateTime();

          await user.save();
          setState(() {});

          closeDialog(context);
        }
      } catch (e) {
        closeDialog(context);
        showSnackBar(context: context, text: "에러 발생 ㅠㅠ!", buttonName: "확인");
      }
    }

    onRestore() async {
      HiveBoxPathsClass hiveBoxPaths = await getHiveBoxPaths();

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingDialog(
          text: '데이터 복원 중..',
          subText: '(백업 데이터가 많을 경우 시간이 오래 걸려요)',
          color: Colors.white,
        ),
      );

      try {
        if (_driveApi != null) {
          final gUser = await _googleDriveAppData.getDriveFile(
            _driveApi!,
            'userbox.hive',
          );
          final gRecord = await _googleDriveAppData.getDriveFile(
            _driveApi!,
            'recordbox.hive',
          );
          final gPlan = await _googleDriveAppData.getDriveFile(
            _driveApi!,
            'planbox.hive',
          );

          await _googleDriveAppData.restoreDriveFile(
            driveApi: _driveApi!,
            driveFile: gUser,
            targetLocalPath: hiveBoxPaths.userBoxPath,
          );

          await _googleDriveAppData.restoreDriveFile(
            driveApi: _driveApi!,
            driveFile: gRecord,
            targetLocalPath: hiveBoxPaths.recordBoxPath,
          );

          await _googleDriveAppData.restoreDriveFile(
            driveApi: _driveApi!,
            driveFile: gPlan,
            targetLocalPath: hiveBoxPaths.planBoxPath,
          );
        }
        closeDialog(context);

        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ConfirmDialog(
            width: 300,
            titleText: '복원 완료',
            contentIcon: Icons.restart_alt_rounded,
            contentText1: "데이터 복원이 완료 됐어요.",
            contentText2: "앱을 완전히 종료한 후 다시 시작해주세요.",
            onPressedOk: () async => await Restart.restartApp(),
            onPressedCancel: () async => await Restart.restartApp(),
          ),
        );
      } catch (e) {
        closeDialog(context);
        showSnackBar(context: context, text: '에러 발생 ㅠㅠ!', buttonName: "확인");
      }
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
                      backupDateTime: ymdeHm(
                              locale: locale,
                              dateTime: googleDriveInfo?['backupDateTime']) ??
                          '없음',
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
    return Text(
      text.tr(),
      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
    );
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
              style: TextStyle(
                color: grey.original,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: grey.original,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: title, size: 13, color: grey.original),
          SpaceWidth(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: textColor),
            ),
          ),
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

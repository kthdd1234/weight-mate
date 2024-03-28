import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:path/path.dart' as path;

class GoogleDriveAppData {
  /// sign in with google
  Future<GoogleSignInAccount?> signInGoogle() async {
    GoogleSignInAccount? googleUser;

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        scopes: [
          drive.DriveApi.driveAppdataScope,
          drive.DriveApi.driveFileScope,
        ],
      );

      googleUser = await googleSignIn.signInSilently(reAuthenticate: true) ??
          await googleSignIn.signIn();
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }

    return googleUser;
  }

  /// sign out from google
  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  /// get google drive client
  Future<drive.DriveApi?> getDriveApi(GoogleSignInAccount googleUser) async {
    drive.DriveApi? driveApi;

    try {
      Map<String, String> headers = await googleUser.authHeaders;
      GoogleAuthClient client = GoogleAuthClient(headers);
      driveApi = drive.DriveApi(client);
    } catch (e) {
      final apiError = e as DetailedApiRequestError;

      // return apiError.status;
      return null;
    }

    return driveApi;
  }

  /// upload file to google drive
  Future<DriveFileClass> uploadDriveFile({
    required drive.DriveApi driveApi,
    required io.File file,
    String? driveFileId,
  }) async {
    try {
      drive.File fileMetadata = drive.File();
      fileMetadata.name = path.basename(file.absolute.path);

      late drive.File response;
      if (driveFileId != null) {
        /// [driveFileId] not null means we want to update existing file
        response = await driveApi.files.update(
          fileMetadata,
          driveFileId,
          uploadMedia: drive.Media(
            file.openRead(),
            file.lengthSync(),
          ),
        );
      } else {
        /// [driveFileId] is null means we want to create new file
        fileMetadata.parents = ['appDataFolder'];
        response = await driveApi.files.create(
          fileMetadata,
          uploadMedia: drive.Media(
            file.openRead(),
            file.lengthSync(),
          ),
        );
      }

      return DriveFileClass(driveFile: response);
    } catch (e) {
      debugPrint(e.toString());

      return DriveFileClass(errorCode: 0);
    }
  }

  /// download file from google drive
  Future<io.File?> restoreDriveFile({
    required drive.DriveApi driveApi,
    required drive.File? driveFile,
    required String targetLocalPath,
  }) async {
    if (driveFile == null) {
      return null;
    }

    try {
      drive.Media media = await driveApi.files.get(
        driveFile.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      List<int> dataStore = [];

      await media.stream.forEach((element) {
        dataStore.addAll(element);
      });

      io.File file = io.File(targetLocalPath);
      file.writeAsBytesSync(dataStore);

      return file;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// get drive file info
  Future<drive.File?> getDriveFile(
    drive.DriveApi driveApi,
    String filename,
  ) async {
    try {
      drive.FileList fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, name, modifiedTime)',
      );
      List<drive.File>? files = fileList.files;
      drive.File? driveFile = files?.firstWhere(
        (element) => element.name == filename,
      );

      return driveFile;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

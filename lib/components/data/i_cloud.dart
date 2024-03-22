import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/pages/common/weight_analyze_page.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:path_provider/path_provider.dart';

const String containerId = 'iCloud.com.kthdd.weightMate';
const String content = 'test file write';
const String fileName = 'fileContent';
const String privateAppFolderName = 'appDataFolder';

class ICloudContainer extends StatelessWidget {
  const ICloudContainer({super.key});

  @override
  Widget build(BuildContext context) {
    onFileList() async {
      try {
        final fileList = await ICloudStorage.gather(
          containerId: containerId,
          onUpdate: (stream) {
            stream.listen((updatedFileList) {
              print('FILES UPDATED');
              updatedFileList
                  .forEach((file) => print('-- ${file.relativePath}'));
            });
          },
        );

        print('FILES GATHERED ${fileList}');
        fileList.forEach((file) => print('-- ${file.relativePath}'));
      } catch (err) {
        if (err is PlatformException) {
          if (err.code == PlatformExceptionCode.iCloudConnectionOrPermission) {
            print(
                'Platform Exception: iCloud container ID is not valid, or user is not signed in for iCloud, or user denied iCloud permission for this app');
          } else if (err.code == PlatformExceptionCode.fileNotFound) {
            print('File not found');
          } else {
            print(
                'Platform Exception: ${err.message}; Details: ${err.details}');
          }
        } else {
          print(err.toString());
        }
      }
    }

    onUpload() async {
      try {
        final directory = await getApplicationDocumentsDirectory();

        final created = io.File("${directory.path}/$fileName");
        created.writeAsString(content);

        await ICloudStorage.upload(
          containerId: containerId,
          filePath: "${directory.path}/$fileName",
          destinationRelativePath: '$privateAppFolderName/$fileName',
          onProgress: (stream) {
            stream.listen(
              (progress) => print('Upload File Progress: $progress'),
              onDone: () => print('Upload File Done'),
              onError: (err) => print('Upload File Error: $err'),
              cancelOnError: true,
            );
          },
        );

        log('업로드!');
        return true;
      } catch (ex) {
        print(ex);
        return false;
      }
    }

    onDownLoad() async {
      final directory = await getApplicationDocumentsDirectory();

      try {
        await ICloudStorage.download(
          containerId: containerId,
          relativePath: '$privateAppFolderName/$fileName',
          destinationFilePath: '${directory.path}/$fileName',
          onProgress: (stream) {
            stream.listen(
              (progress) => print('Download File Progress: $progress'),
              onDone: () => print('Download File Done'),
              onError: (err) => print('Download File Error: $err'),
              cancelOnError: true,
            );
          },
        );

        File created = io.File("${directory.path}/$fileName");
        String contents = await created.readAsString();

        log('onDownLoad => $contents');
      } catch (e) {
        //
      }
    }

    onRemove() async {
      await ICloudStorage.delete(
        containerId: containerId,
        relativePath: "$privateAppFolderName/$fileName",
      );

      log('파일 제거!');
    }

    button({required String text, required Function() onTap}) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            CommonButton(
              text: text,
              fontSize: 13,
              bgColor: themeColor,
              radious: 5,
              textColor: Colors.white,
              onTap: onTap,
            ),
          ],
        ),
      );
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitle(title: 'iCloud 백업', svg: "cloud-data"),
          button(text: '파일 리스트', onTap: onFileList),
          button(text: '업로드', onTap: onUpload),
          button(text: '다운로드', onTap: onDownLoad),
          button(text: '삭제', onTap: onRemove),
        ],
      ),
    );
  }
}

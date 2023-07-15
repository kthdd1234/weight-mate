import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveImageToLocalDirectory(File image) async {
  final documentDirectory = await getApplicationDocumentsDirectory();
  final folderPath = '${documentDirectory.path}/eyeBody/images';
  final filePath = '$folderPath/${DateTime.now().microsecondsSinceEpoch}.png';

  await Directory(folderPath).create(recursive: true);

  final newFile = File(filePath);
  newFile.writeAsBytesSync(image.readAsBytesSync());

  return filePath;
}

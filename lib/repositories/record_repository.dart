import 'dart:developer';

import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:hive/hive.dart';

class RecordRepository {
  Box<RecordBox>? _recordBox;

  Box<RecordBox> get recordBox {
    _recordBox ??= Hive.box<RecordBox>(MateHiveBox.recordBox);
    return _recordBox!;
  }

  List<RecordBox> get recordList {
    return recordBox.values.toList();
  }

  void addRecord(RecordBox record) async {
    int key = await recordBox.add(record);

    log('[addRecord] add (key:$key) $record');
    log('result ${recordBox.values.toList()}');
  }

  void deleteRecord(int key) async {
    await recordBox.delete(key);

    log('[deleteRecord] delete (key:$key)');
    log('result ${recordBox.values.toList()}');
  }

  void updateRecord({required dynamic key, required RecordBox record}) async {
    await recordBox.put(key, record);

    log('[updateRecord] update (key:$key) $record');
    log('result ${recordBox.values.toList()}');
  }

  List<RecordBox> getRecordList() {
    return recordBox.values.toList();
  }
}

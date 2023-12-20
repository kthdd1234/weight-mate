import 'dart:developer';

import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:hive/hive.dart';

class UserRepository {
  Box<UserBox>? _userBox;
  String userProfile = 'userProfile';

  Box<UserBox> get userBox {
    _userBox ??= Hive.box<UserBox>(MateHiveBox.userBox);
    return _userBox!;
  }

  UserBox get profile {
    return userBox.get(userProfile)!;
  }

  void addUser(UserBox user) async {
    int key = await userBox.add(user);

    log('[addUser] add (key:$key) $user');
    log('result ${userBox.values.toList()}');
  }

  void deleteUser(int key) async {
    await userBox.delete(key);

    log('[deleteUser] delete (key:$key)');
    log('result ${userBox.values.toList()}');
  }

  void updateUser(UserBox user) async {
    await userBox.put(userProfile, user);

    log('[updateUser] update (key:$userProfile) $user');
    log('result ${userBox.values.toList()}');
  }
}

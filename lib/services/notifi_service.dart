import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notification =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('twitter_logo');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print('onDidReceiveLocalNotification!!');
      },
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    await notification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print('onDidReceiveNotificationResponse@@');
      },
    );
  }

  Future<bool> addNotification({
    required int id,
    required DateTime alarmTime,
    required String title,
    required String body,
  }) async {
    if (!await permissionNotification) {
      /// show native setting page
      return false;
    }

    ///exception
    final now = tz.TZDateTime.now(tz.local); // ?
    final day = (alarmTime.hour < now.hour ||
            alarmTime.hour == now.hour && alarmTime.minute <= now.minute)
        ? now.day + 1
        : now.day;

    /// add schedule notification
    final details =
        notificationDetails(id: id.toString(), title: title, body: body);

    notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        day,
        alarmTime.hour,
        alarmTime.minute,
      ).add(const Duration(seconds: 5)),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    return true;
  }

  NotificationDetails notificationDetails({
    required String id,
    required String title,
    required String body,
  }) {
    final android = AndroidNotificationDetails(
      id,
      title,
      channelDescription: body,
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = DarwinNotificationDetails();

    return NotificationDetails(android: android, iOS: ios);
  }

  Future<bool?> requestPermission() async {
    return notification
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<bool> get permissionNotification async {
    if (Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      return await requestPermission() ?? false;
    }

    return false;
  }

  Future<void> deleteMultipleAlarm(List<String> alarmIds) async {
    print('[before delete notification list] ${await pendingNotificationIds}');

    for (var alarmId in alarmIds) {
      final id = int.parse(alarmId);
      await notification.cancel(id);
    }
    print('[after delete notification list] ${await pendingNotificationIds}');
  }

  Future<List<int>> get pendingNotificationIds {
    final list = notification
        .pendingNotificationRequests()
        .then((value) => value.map((e) => e.id).toList());
    return list;
  }
}

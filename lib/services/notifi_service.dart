import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final onNotifications = BehaviorSubject<String?>();

class NotificationService {
  final FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await notification.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   print('onDidReceiveBackgroundNotificationResponse@@');
      // },
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print('onDidReceiveNotificationResponse@@');
        onNotifications.add(notificationResponse.payload);
      },
    );
  }

  Future<bool> addNotification({
    required int id,
    required DateTime dateTime,
    required DateTime alarmTime,
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!await permissionNotification) {
      /// show native setting page
      return false;
    }

    /// add schedule notification
    final details =
        notificationDetails(id: id.toString(), title: title, body: body);
    var settingDatetime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      alarmTime.hour,
      alarmTime.minute,
    );

    if (DateTime.now().isAfter(settingDatetime)) {
      settingDatetime = settingDatetime.add(const Duration(days: 1));
    }

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(settingDatetime, tz.local);

    await notification.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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

  Future<bool?> requestAndroidPermission() async {
    return notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<bool> get permissionNotification async {
    if (Platform.isAndroid) {
      return await requestAndroidPermission() ?? false;
    } else if (Platform.isIOS) {
      return await requestPermission() ?? false;
    }

    return false;
  }

  Future<void> deleteAlarm(int id) async {
    await notification.cancel(id);
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

  Future<void> deleteAllAlarm() async {
    await notification.cancelAll();
  }
}

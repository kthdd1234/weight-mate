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

    notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime(
        tz.local,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        alarmTime.hour,
        alarmTime.minute,
      ).add(const Duration(seconds: 3)),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents:
          payload == 'weight' ? DateTimeComponents.time : null,
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

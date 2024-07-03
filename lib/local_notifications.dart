import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

// on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>null,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // request notification permissions
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();


    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }


  // to schedule a local notification
  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
    required tz.TZDateTime scheduleDateTime,
    required BuildContext context
  }) async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        body,
        scheduleDateTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'channel 3', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);

         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sucessfully set at ${scheduleDateTime}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

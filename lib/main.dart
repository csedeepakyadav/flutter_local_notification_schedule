import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_tutorial/home.dart';
import 'package:flutter_local_notifications_tutorial/local_notifications.dart';
import 'another_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
 tz.initializeTimeZones();
//  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(const Duration(seconds: 1), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/another',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Homepage(),
        '/another': (context) => const AnotherPage(),
      },
    );
  }
}

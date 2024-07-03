import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications_tutorial/local_notifications.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  // To listen to any notification clicked or not
  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/another', arguments: event);
    });
  }

  // Function to pick date and time
  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        DateTime scheduledDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        tz.TZDateTime tzScheduledDateTime = tz.TZDateTime.from(
            scheduledDateTime, tz.local);

        LocalNotifications.showScheduleNotification(
          title: "Scheduled Notification",
          body: "This is a Scheduled Notification",
          payload: "This is schedule data",
          scheduleDateTime: tzScheduledDateTime,
          // ignore: use_build_context_synchronously
          context: context
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Local Notifications")),
      body: Container(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.timer_outlined),
                onPressed: _pickDateTime,
                label: const Text("Schedule Notifications"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  LocalNotifications.cancelAll();
                },
                label: const Text("Cancel All Notifications"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

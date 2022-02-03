import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:http/http.dart' as http;

import 'package:meditation_app/src/widgets/quote_widget.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var apiURL = "https://type.fit/api/quotes";

  Future<List<dynamic>> getPost() async {
    final response = await http.get(Uri.parse('$apiURL'));
    // final response = await http.get('$apiURL');
    return postFromJson(response.body);
  }

  List<dynamic> postFromJson(String str) {
    List<dynamic> jsonData = json.decode(str);
    jsonData.shuffle();
    return jsonData;
  }

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  @override
  void initState() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification?.body);
        print(message.notification?.title);
      }
    });
  }

  var task;
  var _selected;
  var _selected2;
  var val;
  var scheduledTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff885566),
        title: Text("Notification Settings"),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hp1.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
            future: getPost(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              var model = snapshot.data![0];
              setSharedPref(model);
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Center(
                          child: Text(
                            "Set Notification",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Reminder content'),
                          onChanged: (_val) {
                            task = _val;
                          },
                        ),
                        Row(
                          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: DropdownButton(
                                  value: _selected,
                                  items: [
                                    DropdownMenuItem(
                                        child: Text(
                                          "Seconds",
                                          style: TextStyle(
                                              color: Color(0xff885566),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: "Seconds"),
                                    DropdownMenuItem(
                                        child: Text(
                                          "Minutes",
                                          style: TextStyle(
                                              color: Color(0xff885566),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: "Minutes"),
                                    DropdownMenuItem(
                                        child: Text(
                                          "Hour",
                                          style: TextStyle(
                                              color: Color(0xff885566),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: "Hour")
                                  ],
                                  hint: Text(
                                    "Select period",
                                  ),
                                  onChanged: (_val) {
                                    setState(() {
                                      _selected = _val;
                                    });
                                  }),
                            ),
                            Expanded(
                              child: DropdownButton(
                                  value: _selected2,
                                  items: [
                                    DropdownMenuItem(
                                        child: Text(
                                          "one",
                                          style: TextStyle(
                                              color: Color(0xff885566),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: 1),
                                    DropdownMenuItem(
                                        child: Text(
                                          "two",
                                          style: TextStyle(
                                              color: Color(0xff885566),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: 2),
                                    DropdownMenuItem(
                                        child: Text(
                                          "three",
                                          style: TextStyle(
                                              color: Color(0xff885566),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: 3)
                                  ],
                                  hint: Text("Select  time"),
                                  onChanged: (_val) {
                                    setState(() {
                                      _selected2 = _val;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(primary: Color(0xff885566)),
                          child: Text("Motivation"),
                          onPressed: () async {
                            await AndroidAlarmManager.oneShot(
                              const Duration(seconds: 5),
                              // Ensure we have a unique alarm ID.
                              Random().nextInt(3000),
                              alertMotivation,
                              exact: true,
                              wakeup: true,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff885566)),
                            onPressed: () {
                              if (_selected == "Hour") {
                                scheduledTime = DateTime.now()
                                    .add(Duration(hours: _selected2));
                              } else if (_selected == "Minutes") {
                                scheduledTime = DateTime.now()
                                    .add(Duration(minutes: _selected2));
                              } else {
                                scheduledTime = DateTime.now()
                                    .add(Duration(seconds: _selected2));
                              }
                              NotificationApi.showScheduledNotification(
                                  scheduleDate: scheduledTime,
                                  title: ' Scheduled Notification',
                                  body: task == ''
                                      ? 'Hey, it is meditation time, get rid of the stress of the day.'
                                      : task,
                                  payload: 'nothing but an payload');
                            },
                            child: Text("Scheduled Notification")),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await NotificationApi._notifications.cancelAll();
                          },
                          child: Text("Cancel Notification"),
                          style:
                          ElevatedButton.styleFrom(primary: Color(0xff885566)),
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  //static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          await _notificationDetails(),
          payload: payload,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
          // onNotifications.add(payload);
        });
  }
}

void printSet() {
  NotificationApi.showNotification(
    title: "Notification is set",
  );
}

void setSharedPref(model) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      'model',
      model["text"].toString() == ''
          ? "Now it's time to meditate"
          : model["text"].toString());
}

void alertMotivation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  NotificationApi.showNotification(
      title: "motivation of the day",
      body: prefs.getString('model'),
      payload: 'bu ne ');
}

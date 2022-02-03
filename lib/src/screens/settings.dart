
library config.globals;
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
//import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:meditation_app/src/screens/SecurePage.dart';
import 'package:meditation_app/src/services/Connect.dart';
import 'package:meditation_app/src/services/fingerprint.dart';
import 'package:meditation_app/src/services/jailbreak_detection.dart';
import 'package:meditation_app/src/services/notification.dart';

import 'motivation_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}
bool isSwitched=false;
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Color(0xff885566),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hp1.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xff885566),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Application Info",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>jailbreakDetection()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Jailbreak Detection",
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        Icon(Icons.security)
                      ],
                    ),
                  ),
                ),
                GestureDetector(

                  onTap: () {
                    setState(() {
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>Connect(title: '',)));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "See connection status",
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        Icon(Icons.wifi)
                      ],
                    ),
                  ),
                ),
                SizedBox(height:20),
                Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.doorbell_sharp,
                        color: Color(0xff885566),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Notifications",
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(
                      width: 150,
                    ),
                    Expanded(
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        activeTrackColor: Color(0xff885566),
                        activeColor: Color(0xff885566),
                      ),
                    ),
                  ],

                ),
                Divider(
                  height: 20,
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SecurePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Birthday reminder",
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        Icon(Icons.cake)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AccountOption(context, "Set Time & Add Reminder"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MotivationPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quotes",
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),



  SizedBox(
    height: 30,
  ),




              ],
            ),
          ),
        ),
      );

  GestureDetector AccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/src/screens/HomePage.dart';


class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var mail;
  var message;
  var value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Image(
                          image:
                              AssetImage('assets/images/blue hair girl.png')),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Contact Us!',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                          labelText: "Your Mail",
                          labelStyle: TextStyle(
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          mail = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                          labelText: "Message",
                          labelStyle: TextStyle(
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          message = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    color: Color(0xFFDEA671),
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    child: Text('Submit ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        )),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

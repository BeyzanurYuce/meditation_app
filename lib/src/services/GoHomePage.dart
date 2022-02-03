
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/src/screens/LoginPage.dart';

import '../screens/HomePage.dart';

class GoHomePage extends StatelessWidget {
  const GoHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), builder: (BuildContext context, AsyncSnapshot<User?> snapshot)
      {if(snapshot.connectionState==ConnectionState.waiting)
        return Center(child: CircularProgressIndicator(),);
      else if(snapshot.hasError)
        return Center(child: Text("Something went wrong!"));
      else if(snapshot.hasData){
        return Home();
      }
      else{
        return LoginPage() ;}},

      ),
    );
  }
}

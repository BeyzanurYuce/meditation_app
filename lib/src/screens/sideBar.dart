import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/src/screens/NotesPage.dart';
import 'package:meditation_app/src/screens/previousactions.dart';
import 'package:meditation_app/src/services/google_sign_in.dart';
import 'package:meditation_app/src/screens/track_categories.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'SignUp.dart';
import 'settings.dart';

import 'Contact.dart';

import 'LoginPage.dart';

class sideBar extends StatefulWidget {
  const sideBar({Key? key}) : super(key: key);

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  final _auth = FirebaseAuth.instance;
  void initState(){
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser()async {
    try {
      final user2 = await _auth.currentUser!;

    } catch (e) {
      print(e);
    }

  }
  final user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context)  {
    final user=FirebaseAuth.instance.currentUser;
    var currentUser=FirebaseFirestore.instance.collection('Data').doc(user?.email);
    return ChangeNotifierProvider(
      create: (context)=> GoogleSignInProvider(),
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(

              accountName:  StreamBuilder(stream: currentUser.snapshots(),builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return Text(""
              //"${snapshot.data.data()['Name']}"
            ,); }
        else{
          return CircularProgressIndicator();
        }
      }),
              accountEmail: Text(user?.email??'$name@gmail.com'),
              currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(user?.photoURL??'https://www.publicdomainpictures.net/pictures/270000/velka/sunset-woman-silhouette-sunset.jpg',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover),

                  )),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://media.istockphoto.com/photos/beautiful-sunset-colors-teal-and-orange-picture-id924837306?k=20&m=924837306&s=170667a&w=0&h=EvMjoV3hmLwbZiXF-ywKrV0kW7QfNI7uDhPGmc2PoC0=',
                  ),
                  fit: BoxFit.cover,
                ),
                color: Color(0xFFFAC191),
              ),
            ),
            ListTile(
              leading:
              Icon(Icons.home, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Home'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
              },
            ),
            ListTile(
              leading:
              Icon(Icons.auto_awesome, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Meditate'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackCategories()));
              },
            ),
            ListTile(
              //tileColor:Color(0xFFE4C4D0),
              leading:
              Icon(Icons.auto_stories, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Journal'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NotesPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Previous Actions'),
              onTap:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PreviousActions()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Settings'),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));},
            ),

            ListTile(
              leading: Icon(Icons.mail, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Contact()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, size: 20, color: Color(0xFFDE9D8D)),
              title: Text('Sign out'),
              onTap: (){
                _auth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));

              },

            ),
            logout(),
          ],
        ),
      ),
    );
  }
}

class logout extends StatelessWidget {
  const logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> GoogleSignInProvider(),
      child: ListTile(
          leading: Icon(Icons.logout, size: 20, color: Color(0xFFDE9D8D)),
          title: Text('Sign out from Google Account'),
          onTap: (){
            final provider=Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.logout();
            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));

          }),
    );
  }
}
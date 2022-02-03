import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:meditation_app/src/screens/meditation_track.dart';
import 'dart:math';

import 'package:meditation_app/src/screens/sideBar.dart';

class TrackCategories extends StatefulWidget {
  @override
  State<TrackCategories> createState() => _TrackCategoriesState();
}

class _TrackCategoriesState extends State<TrackCategories> {
  Map categoriesMap = {
    'Healing': [
      'Track1',
      'Track2',
      'Track3',
      'Track4',
      'Track5',
      'Track6',
      'Track7',
      'Track8',
      'Track9'
    ],
    'Reflection': [
      'RefTrack1',
      'RefTrack2',
      'RefTrack3',
      'RefTrack4',
      'RefTrack5',
      'RefTrack6',
      'RefTrack7',
      'RefTrack8',
      'RefTrack9'
    ],
    'Campfire': [
      'CampTrack1',
      'CampTrack2',
      'CampTrack3',
      'CampTrack4',
      'CampTrack5',
      'CampTrack6',
      'CampTrack7',
      'CampTrack8',
      'CampTrack9'
    ],
    'Quiteness': [
      'QuiteTrack1',
      'QuiteTrack2',
      'QuiteTrack3',
      'QuiteTrack4',
      'QuiteTrack5',
      'QuiteTrack6',
      'QuiteTrack7',
      'QuiteTrack8',
      'QuiteTrack9'
    ],
    'Infinite Horizon': [
      'InfTrack1',
      'InfTrack2',
      'InfTrack3',
      'InfTrack4',
      'InfTrack5',
      'InfTrack6',
      'InfTrack7',
      'InfTrack8',
      'InfTrack9'
    ],
    'Peaceful Memories': [
      'PeaceTrack1',
      'PeaceTrack2',
      'PeaceTrack3',
      'PeaceTrack4',
      'PeaceTrack5',
      'PeaceTrack6',
      'PeaceTrack7',
      'PeaceTrack8',
      'PeaceTrack9'
    ],
  };
  List<String> categories = [
    'Healing',
    'Reflection',
    'Quiteness',
    'Infinite Horizon',
  ];
  // CurrentIndex points to the category that is currently shown on the page in the categories list.
  int currentIndex = 0;
  // FocusNode is there to manage the search field.
  late FocusNode trackSearchFocus;
  // For the wave progress bar
  List<double> values = [];

  LinkedHashMap playlist = new LinkedHashMap();
  loadPlaylist() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/playlist.json")
        .then((audio) {
      setState(() {
        playlist = json.decode(audio);
      });
      print(playlist[categories[currentIndex]]);
    });
  }

  @override
  void initState() {
    super.initState();
    trackSearchFocus = FocusNode();
    /* var rng = new Random();
    for (var i = 0; i < 50; i++) {
      values.add(rng.nextInt(40) * 1.0);
    } */
    loadPlaylist();
  }

  @override
  void dispose() {
    trackSearchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, Constraints) {
        if (Constraints.maxWidth < 600) {
          return Scaffold(
            drawer: sideBar(),
            resizeToAvoidBottomInset: false,
            appBar: buildAppbar(),
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: buildSearchBar(),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: buildCategorySlider(6),
                            ),
                            Expanded(
                              flex: 10,
                              child: buildTrackGrid(2),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: buildAppbar(),
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: buildSearchBar(),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: buildCategorySlider(15),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: buildTrackGrid(4),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      //To get the focus out of the search bar when tapped on AppBar
      flexibleSpace: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      ),
      centerTitle: true,
      backgroundColor: Colors.red[200],
      elevation: 0,
      title: const Text(
        'Meditate',
        style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
      ),
    );
  }

  Container buildTrackGrid(int axisCount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade50,
            offset: const Offset(
              0,
              5.0,
            ),
            blurRadius: 20.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: axisCount,
            childAspectRatio: 1,
          ),
          itemCount: playlist[categories[currentIndex]] != null
              ? playlist[categories[currentIndex]].length
              : 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(width: 5, color: Colors.white38)),
                  color: Colors.red[200],
                  child: InkWell(
                    splashColor: Colors.red.withAlpha(700),
                    onTap: () {
                      if (trackSearchFocus.hasFocus) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeditationTrack(
                                  meditation_track:
                                  playlist[categories[currentIndex]]
                                  [index]),
                            ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: playlist[categories[currentIndex]] != null
                                ? Text(
                              '${playlist[categories[currentIndex]][index]['name']}',
                              textAlign: TextAlign.center,
                            )
                                : Text('Shucsy Doodles'),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  SizedBox buildCategorySlider(double padding) {
    return SizedBox(
      height: 25,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      categories[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                        currentIndex == index ? Colors.black : Colors.grey,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 2,
                      width: 30,
                      color: currentIndex == index
                          ? Colors.black
                          : Colors.transparent,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Padding buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: TextField(
        onTap: () => trackSearchFocus.requestFocus(),
        focusNode: trackSearchFocus,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Search track'),
      ),
    );
  }
}

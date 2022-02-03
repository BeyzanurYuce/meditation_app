/*import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/src/screens/HeartRate.dart';
import 'package:meditation_app/src/services/bpm_provider.dart';
import 'package:meditation_app/src/services/pinSSL.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:async';
import 'package:flutter/rendering.dart'as http;
import 'package:http/http.dart';
import 'package:meditation_app/src/utils/ImageData.dart';
import 'dart:convert';

import 'LoginPage.dart';

class MeditationTrack extends StatefulWidget {
  final meditation_track;

  const MeditationTrack({Key? key, this.meditation_track}) : super(key: key);
  @override
  State<MeditationTrack> createState() => _MeditationTrackState();
}

class _MeditationTrackState extends State<MeditationTrack> {
  // initiating the audio MeditationTrack
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

  // image info
  late String imageUrl = "";
  String imageInfo = "Image Information";
  String imageTitle = 'Image Title';
  String mediaType = "mediaType";

  Future<Response> getImage() async {
    String url = Uri.encodeFull(
        "https://api.nasa.gov/planetary/apod?api_key=yHp7k9stnejr7yBTnnS5dUDOmXa9YjdsucozU1Dc");
    final response = await get(Uri.parse(url));
    await checkSSL(url.toString(), context).then(
            (value) async {
          if (value) {
            try {
              final response = await get(Uri.parse(url));
              if (response.statusCode == 200) {
                return response;
              } else {
                print("An error occurred:" + "${response.statusCode}");
              }
            } catch (e) {
              print(e.toString());
            }
          }
          print(value);
        });



    return response;
  }

  displayApod(Response response) {
    Map<String, dynamic> apoddetails = json.decode(response.body);

    setState(() {
      imageInfo = apoddetails['explanation'] == null
          ? "data is not available"
          : apoddetails["explanation"];
      imageTitle = apoddetails['title'] == null
          ? "data is not available"
          : apoddetails['title'];
      mediaType = apoddetails['media_type'];
      imageUrl = apoddetails['hdurl'];
    });
  }

  @override
  void initState() {
    super.initState();
    setupPlaylist();
    getImage()
        .then((response) => displayApod(response))
        .catchError((error) => print(error));
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<BpmProvider>(context, listen: false).getBpmRecords(user);
  }

  void setupPlaylist() async {
    try {
      await audioPlayer.open(
          Audio.network(this.widget.meditation_track['link']),
          autoStart: false,
          playInBackground: PlayInBackground.disabledRestoreOnForeground);
    } catch (t) {
      print('Issue');
    }
  }

  /*   audioPlayer.open(Audio('${this.widget.meditation_track['link']}'),
        autoStart: false,
        playInBackground: PlayInBackground.disabledRestoreOnForeground);
  }
 */
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bpmProvider = Provider.of<BpmProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          //To get the focus out of the search bar when tapped on AppBar
/*         flexibleSpace: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        ), */
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            '${this.widget.meditation_track['name']}',
            style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
          ),
        ),
        backgroundColor: Colors.white,
        body: imageUrl != ''
            ? Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, Constraints) {
              if (Constraints.maxWidth < 600) {
                return Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: audioPlayer.builderRealtimePlayingInfos(
                          builder: (context, realtimePlayingInfos) {
                            if (realtimePlayingInfos != null) {
                              return audioPlayerWidget(
                                  realtimePlayingInfos, screenWidth);
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    Expanded(
                      flex: 2,
                      child: buildMantra(),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                      buildHeartrateMonitor(_bpmProvider.bpmRecords),
                    )
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: audioPlayer.builderRealtimePlayingInfos(
                          builder: (context, realtimePlayingInfos) {
                            if (realtimePlayingInfos != null) {
                              return audioPlayerWidget(
                                  realtimePlayingInfos, screenWidth);
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 2,
                              child: buildHeartrateMonitor(
                                  _bpmProvider.bpmRecords),
                            ),
                            Expanded(
                              flex: 2,
                              child: buildMantra(),
                            ),
                          ],
                        ))
                  ],
                );
              }
            }),
          ),
        )
            : CircularProgressIndicator());
  }

  Padding buildHeartrateMonitor(passedData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => heartrate()));
              },
              child: Text("Click for Heart Rate",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 15,
                      fontWeight: FontWeight.normal)),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade50,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.red.shade100,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SfSparkLineChart(
                  color: Colors.grey,
                  lastPointColor: Colors.red,
                  axisLineColor: Colors.transparent,
                  data: <double>[12, 23, 23, 13, 123],
                ),
              )),
        ),
      ]),
    );
  }

  Column buildMantra() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text(
        'Loka samasta sukhino bhavantu',
        style: TextStyle(fontSize: 16, letterSpacing: 2),
      ),
      Spacer(
        flex: 1,
      ),
      Text(
        'May all beings be happy and free',
        style: TextStyle(fontSize: 10),
      ),
      Spacer(
        flex: 3,
      )
    ]);
  }

  Widget audioPlayerWidget(
      RealtimePlayingInfos realtimePlayingInfos, double screenWidth) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(height: 20),
      CircularPercentIndicator(
        backgroundColor: Color(0xFFFFEBEE),
        progressColor: Colors.red[300],
        radius: 150.0,
        lineWidth: 6.0,
        circularStrokeCap: CircularStrokeCap.butt,
        center: IconButton(
          iconSize: 90,
          icon: CircleAvatar(
            radius: 50.0,
            backgroundImage:
            AssetImage('assets/images/meditation_track_img.png'),
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            audioPlayer.playOrPause();
          },
        ),
        percent: realtimePlayingInfos.currentPosition.inSeconds /
            realtimePlayingInfos.duration.inSeconds,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: 2,
            child: IconButton(
              icon: Icon(Icons.double_arrow_rounded),
              onPressed: () => audioPlayer.seekBy(Duration(seconds: -10)),
            ),
          ),
          IconButton(
            icon: Icon(realtimePlayingInfos.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded),
            onPressed: () => audioPlayer.playOrPause(),
          ),
          IconButton(
              onPressed: () => audioPlayer.seekBy(Duration(seconds: 10)),
              icon: Icon(Icons.double_arrow_rounded)),
        ],
      )
    ]);
  }
}
*//////////////////////////////////////////////////
/* import 'dart:collection';
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

 */
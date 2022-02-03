import 'package:assets_audio_player/assets_audio_player.dart';
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
                      flex: 3,
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
                      //flex: 2,
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
                              flex: 1,
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
      padding: const EdgeInsets.all(10),
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
            height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.red.shade100,
                  width: 3,
                ),
              ),
               child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SfSparkLineChart(
                  color: Colors.grey,
                  lastPointColor: Colors.red,
                  axisLineColor: Colors.transparent,
                  data: <double>[12, 10, 23, 13, 123],
                ),
              ) ),
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
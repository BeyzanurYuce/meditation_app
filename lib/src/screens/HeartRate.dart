import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

import 'package:meditation_app/src/services/bpm_provider.dart';
import 'package:provider/provider.dart';

class heartrate extends StatelessWidget {
  const heartrate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart BPM',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HeartRatePage(),
    );
  }
}

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({Key? key}) : super(key: key);

  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  final userInfo = FirebaseAuth.instance.currentUser;
  Widget? dialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart BPM Values'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsetsDirectional.all(20),
              child: Text(
                  "Measure your BPM heart rate and see the impact of today's meditation on your health.")),
          Expanded(
              child: Center(
                  child: Text("Slowly place your finger on the camera"))),
          isBPMEnabled
              ? dialog = HeartBPMDialog(
            context: context,
            onRawData: (value) {
              setState(() {
                if (data.length >= 50) data.removeAt(0);
                data.add(value);
              });
              // chart = BPMChart(data);
            },
            onBPM: (value) => setState(() {
              if (bpmValues.length >= 100) bpmValues.removeAt(0);
              bpmValues.add(SensorValue(
                  value: value.toDouble(), time: DateTime.now()));
            }),
          )
              : Expanded(child: SizedBox()),
          isBPMEnabled && data.isNotEmpty
              ? Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              height: 180,
              child: BPMChart(data),
            ),
          )
              : SizedBox(),
          isBPMEnabled && bpmValues.isNotEmpty
              ? Container(
            decoration: BoxDecoration(border: Border.all()),
            constraints: BoxConstraints.expand(height: 180),
            child: BPMChart(bpmValues),
          )
              : SizedBox(),
          Expanded(
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.favorite_rounded),
                label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
                onPressed: () => setState(() {
                  if (isBPMEnabled) {
                    isBPMEnabled = false;
                    Provider.of<BpmProvider>(context, listen: false)
                        .saveBpmRecord(bpmValues, userInfo);
                    ;
                    // dialog.
                  } else
                    isBPMEnabled = true;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

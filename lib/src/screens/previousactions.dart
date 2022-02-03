import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/src/services/bpm_provider.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class PreviousActions extends StatefulWidget {
  const PreviousActions({Key? key}) : super(key: key);

  @override
  State<PreviousActions> createState() => _PreviousActionsState();
}

class _PreviousActionsState extends State<PreviousActions> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<BpmProvider>(context, listen: false).getBpmRecords(user);
  }

  @override
  Widget build(BuildContext context) {
    final _bpmProvider = Provider.of<BpmProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
          'Meditation Data',
          style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _bpmProvider.bpmRecords.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                  '${_bpmProvider.bpmRecords[index]['date']}')),
                          Expanded(
                            flex: 3,
                            child: buildHeartrateMonitor(
                                _bpmProvider.bpmRecords[index]['bpm_record']),
                          )
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildHeartrateMonitor(passedData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
          height: 150,
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
              data: passedData.cast<double>(),
            ),
          )),
    );
  }
}

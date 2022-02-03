import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:heart_bpm/heart_bpm.dart';

class BpmProvider with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  List bpmRecords = [];

/*   Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  } */

  Future<void> getBpmRecords(userInfo) async {
    var idToken;
    idToken = await userInfo?.getIdToken();
    var url =
        'https://take-care-of-you-73cdf-default-rtdb.firebaseio.com/bpmRecords.json?auth=$idToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List _bpmRecords = [];
      if (extractedData != null) {
        extractedData.forEach((data_id, data) {
          _bpmRecords.add(data);
          bpmRecords = _bpmRecords;
          notifyListeners();
        });
      }
      print(bpmRecords[0]);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> saveBpmRecord(List<SensorValue> bpmValues, userInfo) async {
    var idToken;
    idToken = await userInfo?.getIdToken();
    var url =
        'https://take-care-of-you-73cdf-default-rtdb.firebaseio.com/bpmRecords.json?auth=$idToken';
    List _bpmRecord = [];
    bpmValues.forEach((data) {
      _bpmRecord.add(data.value);
    });
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'date': DateTime.now().toString(),
          'bpm_record': _bpmRecord,
        }),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

/*   void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  } */
}

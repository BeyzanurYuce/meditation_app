import 'package:flutter/material.dart';
import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

class _PinSSL {
  String serverURL = '';
  HttpMethod httpMethod = HttpMethod.Get;
  Map<String, String> headerHttp = new Map();
  String allowedSHAFingerprint = '';
  int timeout = 0;
  late SHA sha;
}

_PinSSL _data = new _PinSSL();
Future checkSSL(String requestURL, BuildContext context) async {
  bool checked = false;
  String _fingerprint =
      "47 0D 16 F7 E2 61 10 E8 F0 20 CC C2 D0 91 D2 3B ED C1 89 CC";
  List<String> allowedShA1FingerprintList = [];
  allowedShA1FingerprintList.add(_fingerprint);
  try {
    await SslPinningPlugin.check(
      serverURL: requestURL,
      headerHttp: _data.headerHttp,
      httpMethod: HttpMethod.Get,
      sha: SHA.SHA1,
      allowedSHAFingerprints: allowedShA1FingerprintList,
      timeout: 60,
    ).then((value) {
      print(value);
      if (value == "CONNECTION_SECURE") {
        checked = true;
      } else if (value == "CONNECTION_NOT_SECURE") {
        checked = false;
      } else {
        checked = false;
      }
    });
    return checked;
  } catch (e) {
    print("unsuccessful SSL");
  }
}
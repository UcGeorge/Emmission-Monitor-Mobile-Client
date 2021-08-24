import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ActivityProvider extends ChangeNotifier {
  double? percentC;
  Map<String, dynamic>? dailyData;
  Map<String, dynamic>? weeklyData;
  Map<String, dynamic>? monthlyData;

  void getData(String token, String username) async {
    try {
      print('Getting sessions');
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
        'GET',
        Uri.parse('https://crunch-carbon.herokuapp.com/sessions'),
      );
      request.bodyFields = {'token': token, 'username': username};
      request.headers.addAll(headers);

      print('Sending request');
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Got response');

      if (response.statusCode == 200) {
        print(responseBody);
        try {
          _parseData(jsonDecode(responseBody));
        } catch (e) {
          print('Json parse error: $e');
        }
      } else {
        print(responseBody);
      }
    } catch (e) {
      print(e);
    }
  }

  void _parseData(Map<String, dynamic> jsonBody) {}
}

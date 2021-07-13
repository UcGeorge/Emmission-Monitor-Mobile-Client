import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DashboardProvider extends ChangeNotifier {
  double? totalC;
  double? previousC;
  double? percentC;

  void getSessions(String token, String username) async {
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
          Map<String, dynamic> jsonBody = jsonDecode(responseBody);
          // token = jsonBody['token'];
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
}

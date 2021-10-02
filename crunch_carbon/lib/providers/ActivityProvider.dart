import 'dart:convert';

import 'package:crunch_carbon/models/fuel.dart';
import 'package:crunch_carbon/models/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ActivityProvider extends ChangeNotifier {
  List<Session> sessionList = [];

  Future<List<Session>> getSessions(String token, String username) async {
    if(sessionList.isNotEmpty){
      // print('Session list length: ${sessionList.length}');
      return sessionList;
    }else{
      // print('sessionList is empty');
      await refreshSessions(token, username);
      return sessionList;
    }
  }

  Future<void> refreshSessions(String token, String username) async {
    try {
      // print('Getting sessions');
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
        'GET',
        Uri.parse('https://crunch-carbon.herokuapp.com/sessions'),
      );
      request.bodyFields = {'token': token, 'username': username};
      request.headers.addAll(headers);

      // print('Sending request');
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      // print('Got response');

      if (response.statusCode == 200) {
        // print(responseBody);
        try {
          sessionList = _parseData(await jsonDecode(responseBody));
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

  List<Session> _parseData(Map<String, dynamic> jsonBody) {

    var fuelList = (jsonBody['fuel'] as List).map((e) => Fuel(e['ID'], e['name'], e['factor']));

    List<Session> sessionList = (jsonBody['sessions'] as List).map((e) => Session(
      fuelList.where((element) => element.id == e['fuel_ID']).first,
      e['distance'],
      null,
      emissionQuantity: e['emission_quantity'],
      dateCreated: DateTime.parse(e['dateadded']),
    )).toList();

    // print('Session list length: ${sessionList.length}');
    return sessionList;
  }
}

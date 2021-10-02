import 'dart:convert';

import 'package:crunch_carbon/models/fuel.dart';
import 'package:crunch_carbon/models/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DashboardProvider extends ChangeNotifier {
  double? totalC;
  double? previousC;
  double? percentC;
  double? totalDistance;

  bool isThisWeek(Session e){
    DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday));
    DateTime lastDayOfWeek = today.add(Duration(days: DateTime.daysPerWeek - today.weekday));
    return firstDayOfWeek.isBefore(e.dateCreated) && lastDayOfWeek.isAfter(e.dateCreated);
  }

  bool isLastWeek(Session e){
    DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday - DateTime.daysPerWeek));
    DateTime lastDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    return firstDayOfWeek.isBefore(e.dateCreated) && lastDayOfWeek.isAfter(e.dateCreated);
  }

  double _totalCarbonUsed(List<Session> sessionList){
    double sum = 0;
    sessionList.where((e) => isThisWeek(e)).map((e) => e.emissionQuantity).forEach((num e){sum += e.toDouble();});
    return sum;
  }

  double _totalCarbonUsedLastWeek(List<Session> sessionList){
    double sum = 0;
    sessionList.where((e) => isLastWeek(e)).map((e) => e.emissionQuantity).forEach((num e){sum += e.toDouble();});
    return sum;
  }

  double _totalDistanceCovered(List<Session> sessionList){
    double sum = 0;
    sessionList.where((e) => isThisWeek(e)).map((e) => e.distance).forEach((num e){sum += e.toDouble();});
    return sum;
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

  Future<void> getSessions(String token, String username) async {
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
        try {
          List<Session> sessionList = _parseData(await jsonDecode(responseBody));
          totalC = _totalCarbonUsed(sessionList);
          totalDistance = _totalDistanceCovered(sessionList);
          previousC = _totalCarbonUsedLastWeek(sessionList);
          if(totalC! > previousC!){
            percentC = ((totalC! - previousC!)/previousC!)*100;
            if(percentC == double.infinity){
              percentC = 100;
            }
          }else{
            percentC = ((previousC! - totalC!)/previousC!)*100;
          }
          notifyListeners();
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

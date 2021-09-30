import 'dart:convert';

import 'package:crunch_carbon/models/fuel.dart';
import 'package:crunch_carbon/models/location.dart';
import 'package:crunch_carbon/models/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as Location_accuracy;
import 'package:http/http.dart' as http;

class SessionProvider extends ChangeNotifier {
  String? fuelOption;
  String? vehicleType;
  String? plateNo;
  LocationService locationService;
  double distanceTravelled = 0;
  bool isInTransit = false;
  UserLocation? lastLocation;
  UserLocation? currentLocation;
  double calculatedDistance = 0;
  int countKeeper = 0;

  SessionProvider() : this.locationService = LocationService();

  void initialize(String fuelOption, String vehicleType, String plateNo) {
    this.fuelOption = fuelOption;
    this.vehicleType = vehicleType;
    this.plateNo = plateNo;
  }

  void startTrip() async {
    isInTransit = true;
    notifyListeners();
    while (isInTransit) {
      countKeeper++;
      if (lastLocation == null) {
        currentLocation = await locationService.getLocation(
          onError: (errorMessage) {
            print(errorMessage);
            endTrip();
          },
        );
        notifyListeners();
        lastLocation = currentLocation;
      } else {
        currentLocation = await locationService.getLocation(
          onError: (errorMessage) {
            print(errorMessage);
            endTrip();
          },
        );
        if (currentLocation != null) {
          calculatedDistance = Geolocator.distanceBetween(
            lastLocation!.latitude,
            lastLocation!.longitude,
            currentLocation!.latitude,
            currentLocation!.longitude,
          );

          distanceTravelled += calculatedDistance;

          notifyListeners();
          lastLocation = currentLocation;
        }
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  Future<PutSessionStatus> putSession(String token, String username, Session session) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('PUT', Uri.parse('https://crunch-carbon.herokuapp.com/sessions'));
    request.bodyFields = {
      'username': username,
      'fuel': session.fuel.id.toString(),
      'distance': session.distance.toString(),
      'emission_quantity': session.emissionQuantity.toString(),
      'token': token
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('putSession is successful');
      return PutSessionStatus.Success;
    }
    else {
      print('putSession is a failure');
      return PutSessionStatus.Failure;
    }
  }

  Future<List<Fuel>> getFuel(String token, String username) async {
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
          Map<String, dynamic> jsonBody = await jsonDecode(responseBody);
          List<Fuel> fuelList = (jsonBody['fuel'] as List).map((e) => Fuel(e['ID'], e['name'], e['factor'])).toList();
          print('Fuel list length: ${fuelList.length}');
          return fuelList;
        } catch (e) {
          print('Json parse error: $e');
          return [];
        }
      } else {
        print(responseBody);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  void endTrip() async {
    await Future.delayed(Duration(seconds: 5));
    fuelOption = null;
    vehicleType = null;
    plateNo = null;
    locationService;
    distanceTravelled = 0;
    isInTransit = false;
    lastLocation = null;
    currentLocation = null;
    calculatedDistance = 0;
    countKeeper = 0;
    notifyListeners();
  }
}

class LocationService {
  Future<bool> _checkPermissions() async {
    var location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<bool> allIsWell() async => await _checkPermissions();

  Future<UserLocation?> getLocation(
      {required void onError(String errorMessage)}) async {
    if (await _checkPermissions()) {
      try {
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy:
                Location_accuracy.LocationAccuracy.bestForNavigation);
        return UserLocation(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
        );
      } on Exception catch (e) {
        onError('Could not get location: ${e.toString()}');
        return null;
      }
    }
    onError('Insufficient privileges.');
    return null;
  }
}


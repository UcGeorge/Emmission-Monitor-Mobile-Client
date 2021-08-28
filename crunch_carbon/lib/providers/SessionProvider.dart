import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class SessionProvider extends ChangeNotifier {
  String? fuelOption;
  String? vehicleType;
  String? plateNo;
  LocationService locationService;
  double? distanceTravelled;
  bool isInTransit = false;

  SessionProvider() : this.locationService = LocationService();

  void initialize(String fuelOption, String vehicleType, String plateNo) {
    this.fuelOption = fuelOption;
    this.vehicleType = vehicleType;
    this.plateNo = plateNo;
  }

  void startTrip() async {
    isInTransit = true;
  }

  void endTrip() {
    isInTransit = false;
  }
}

class LocationService {
  late UserLocation _currentLocation;

  LocationService() {
    _checkPermissions();
  }

  Future<bool> _checkPermissions() async {
    print('Checking permissions and services');
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print('Location service is disabled.');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location service was denied.');
        return false;
      }
    }

    print('Location service has been enabled.');

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('Location permission is not granted.');
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Location permission was denied.');
        return false;
      }
    }

    print('Location permission has been granted.');

    return true;
  }

  var location = Location();

  Future<bool> allIsWell() async => await _checkPermissions();

  Future<UserLocation?> getLocation() async {
    if (await _checkPermissions()) {
      try {
        var userLocation = await location.getLocation();
        _currentLocation = UserLocation(
          latitude: userLocation.latitude ?? 0,
          longitude: userLocation.longitude ?? 0,
        );
      } on Exception catch (e) {
        print('Could not get location: ${e.toString()}');
      }

      return _currentLocation;
    }
    return null;
  }
}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}

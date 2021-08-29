import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as Location_accutacy;

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
        }
      }
      notifyListeners();
      await Future.delayed(Duration(seconds: 5));
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
  LocationService() {
    _checkPermissions();
  }

  Future<bool> _checkPermissions() async {
    var location = Location();
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

  Future<bool> allIsWell() async => await _checkPermissions();

  Future<UserLocation?> getLocation(
      {required void onError(String errorMessage)}) async {
    if (await _checkPermissions()) {
      try {
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy:
                Location_accutacy.LocationAccuracy.bestForNavigation);
        return UserLocation(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
        );
      } on Exception catch (e) {
        onError('Could not get location: ${e.toString()}');
        return null;
      }
    }
    onError('Insufficent privileges.');
    return null;
  }
}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}

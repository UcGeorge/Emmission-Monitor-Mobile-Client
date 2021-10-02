
import 'package:crunch_carbon/models/fuel.dart';
import 'package:crunch_carbon/models/vehicle.dart';

class Session{
  Fuel fuel;
  num distance;
  Vehicle? vehicle;
  late num emissionQuantity;
  late DateTime dateCreated;

  Session(this.fuel, this.distance, this.vehicle, {DateTime? dateCreated, num? emissionQuantity}){
    this.emissionQuantity = emissionQuantity ?? vehicle!.fuelEfficiency * distance * fuel.factor;
    this.dateCreated = dateCreated ?? DateTime.now();
  }
}


enum PutSessionStatus{
  Success, Failure
}
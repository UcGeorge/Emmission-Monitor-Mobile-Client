
import 'package:crunch_carbon/models/fuel.dart';

class Session{
  Fuel fuel;
  double distance;
  late double emissionQuantity;
  late DateTime dateCreated;

  Session(this.fuel, this.distance, {DateTime? dateCreated, double? emissionQuantity}){
    this.emissionQuantity = emissionQuantity ?? (fuel.quantityConsumed / distance) * fuel.factor;
    this.dateCreated = dateCreated ?? DateTime.now();
  }
}


enum PutSessionStatus{
  Success, Failure
}
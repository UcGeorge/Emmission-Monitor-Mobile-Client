
import 'package:crunch_carbon/models/fuel.dart';

class Session{
  Fuel fuel;
  num distance;
  late num emissionQuantity;
  late DateTime dateCreated;

  Session(this.fuel, this.distance, {DateTime? dateCreated, num? emissionQuantity}){
    this.emissionQuantity = emissionQuantity ?? (fuel.quantityConsumed / distance) * fuel.factor;
    this.dateCreated = dateCreated ?? DateTime.now();
  }
}


enum PutSessionStatus{
  Success, Failure
}